import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // To format the date
import 'package:watchdog_app/cubits/settings/settings_cubit.dart';

class ScriptRunnerHome extends StatefulWidget {
  @override
  _ScriptRunnerHomeState createState() => _ScriptRunnerHomeState();
}

class _ScriptRunnerHomeState extends State<ScriptRunnerHome> {
  String? selectedScript; // Store the currently selected script
  String scriptOutput = ''; // Store the output of the script
  bool isLoading = false; // Track whether a script is currently running
  Map<String, DateTime> lastRunTimes =
      {}; // Store the last run times of scripts

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Script Runner'),
      ),
      body: Row(
        children: [
          // Left side: List of script names with last run date
          Expanded(
            flex: 1,
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                if (state.scripts.isEmpty) {
                  return Center(
                    child: Text('No scripts found in the data directory.'),
                  );
                }

                return ListView.builder(
                  itemCount: state.scripts.length,
                  itemBuilder: (context, index) {
                    final scriptData = state.scripts[index];
                    final scriptPath = scriptData['script']!;
                    // Extract the parent directory name of script.sh
                    final scriptName =
                        Directory(scriptPath).parent.path.split('/').last;

                    // Get the last run time (if any) and format it
                    final lastRunTime = lastRunTimes[scriptName];
                    String lastRunDisplay = lastRunTime != null
                        ? DateFormat.yMMMd().add_jm().format(lastRunTime)
                        : 'Never run';

                    return ListTile(
                      title: Text(scriptName),
                      subtitle: Text('Last run: $lastRunDisplay'),
                      selected: scriptName ==
                          selectedScript, // Highlight selected script
                      onTap: () {
                        setState(() {
                          selectedScript = scriptName;
                          scriptOutput = ''; // Clear the previous output
                          isLoading = true; // Start loading
                        });
                        // Run the script and get the output
                        _runScript(context, scriptPath, scriptData['env']!,
                            scriptName);
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Right side: Script output display or loader with fixed size
          Expanded(
            flex: 2,
            child: Container(
              height: double.maxFinite,
              padding: EdgeInsets.all(16),
              color: Colors.black,
              child: SizedBox(
                height:
                    400, // Set a fixed height for the output area (adjust as needed)
                child: isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loader while running
                    : scriptOutput.isNotEmpty
                        ? SingleChildScrollView(
                            child: Text(
                              scriptOutput,
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'monospace'),
                            ),
                          )
                        : Center(
                            child: Text(
                              'Select a script to run.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to run the selected script and update the last run time
  void _runScript(BuildContext context, String scriptPath, String envPath,
      String scriptName) async {
    final settingsCubit = context.read<SettingsCubit>();
    final output = await settingsCubit.runScript(scriptPath, envPath);

    setState(() {
      scriptOutput = output; // Update the script output
      isLoading = false; // Stop loading after the script completes
      lastRunTimes[scriptName] = DateTime.now(); // Update the last run time
    });
  }
}
