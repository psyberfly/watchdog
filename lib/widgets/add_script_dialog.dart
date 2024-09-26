import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings_cubit.dart';

class AddScriptDialog extends StatefulWidget {
  @override
  _AddScriptDialogState createState() => _AddScriptDialogState();
}

class _AddScriptDialogState extends State<AddScriptDialog> {
  final _nameController = TextEditingController();
  final _pathController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  // Function to pick a file using the file picker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pathController.text =
            result.files.single.path ?? ''; // Set the picked file path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 50), // Adjust width
          child: Container(
            width: 400.0, // Set width
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Script',
                  style: TextStyle(fontSize: settingsState.fontSize),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  style: TextStyle(fontSize: settingsState.fontSize),
                  decoration: InputDecoration(
                    labelText: 'Script Name',
                    labelStyle: TextStyle(fontSize: settingsState.fontSize),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _pathController,
                  style: TextStyle(fontSize: settingsState.fontSize),
                  decoration: InputDecoration(
                    labelText: 'Script Path',
                    labelStyle: TextStyle(fontSize: settingsState.fontSize),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.folder_open), // File picker icon
                      onPressed:
                          _pickFile, // Open file picker when icon is clicked
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: settingsState.fontSize),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_nameController.text.isNotEmpty &&
                            _pathController.text.isNotEmpty) {
                          Navigator.pop(context, {
                            'name': _nameController.text,
                            'path': _pathController.text,
                          });
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(fontSize: settingsState.fontSize),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
