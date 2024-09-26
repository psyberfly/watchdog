import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings_cubit.dart';

class RemoveScriptConfirmation extends StatelessWidget {
  final VoidCallback onConfirm;

  RemoveScriptConfirmation({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return AlertDialog(
          title: Text(
            'Remove Script',
            style: TextStyle(
                fontSize:
                    settingsState.fontSize), // Dynamic font size for title
          ),
          content: Text(
            'Are you sure you want to remove this script?',
            style: TextStyle(
                fontSize:
                    settingsState.fontSize), // Dynamic font size for content
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: settingsState
                        .fontSize), // Dynamic font size for Cancel button
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onConfirm();
                Navigator.pop(context); // Close dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set button color to red
              ),
              child: Text(
                'Remove',
                style: TextStyle(
                    fontSize: settingsState
                        .fontSize), // Dynamic font size for Remove button
              ),
            ),
          ],
        );
      },
    );
  }
}
