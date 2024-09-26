// widgets/remove_script_confirmation.dart
import 'package:flutter/material.dart';

class RemoveScriptConfirmation extends StatelessWidget {
  final VoidCallback onConfirm;

  RemoveScriptConfirmation({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remove Script'),
      content: Text('Are you sure you want to remove this script?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close dialog
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context); // Close dialog
          },
          child: Text('Remove'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Set button color to red
          ),
        ),
      ],
    );
  }
}
