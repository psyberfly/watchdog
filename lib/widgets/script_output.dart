import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings_cubit.dart';

class ScriptOutput extends StatefulWidget {
  final String path; // The path to the script
  final VoidCallback onDelete; // Function to delete the script

  ScriptOutput({
    required this.path,
    required this.onDelete,
  });

  @override
  _ScriptOutputState createState() => _ScriptOutputState();
}

class _ScriptOutputState extends State<ScriptOutput> {
  String _output = ''; // To store the output of the script
  bool _isRunning = true; // To track if the script is still running

  @override
  void initState() {
    super.initState();
    _runScript(); // Run the script when the widget is initialized
  }

  // Function to run the script and capture its output
  Future<void> _runScript() async {
    try {
      setState(() {
        _isRunning = true;
      });

      // Run the script using Process.run
      final result = await Process.run(widget.path, []);

      setState(() {
        _output = result.stdout.toString(); // Capture the script's output
        if (result.stderr.isNotEmpty) {
          _output += '\nError: ${result.stderr}'; // Capture any errors
        }
        _isRunning = false;
      });
    } catch (e) {
      setState(() {
        _output = 'Failed to run the script: $e'; // Handle script failure
        _isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return Stack(
          children: [
            _isRunning
                ? Center(
                    child:
                        CircularProgressIndicator()) // Show progress while running
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        _output, // Display the script's output
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.white,
                          fontSize: settingsState
                              .fontSize, // Dynamic font size for script output
                        ),
                      ),
                    ),
                  ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.redAccent,
                tooltip: 'Remove Script',
                onPressed: widget.onDelete, // Handle script deletion
              ),
            ),
          ],
        );
      },
    );
  }
}
