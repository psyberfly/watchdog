import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adjust Font Size',
                  style: TextStyle(fontSize: state.fontSize + 10),
                ),
                Slider(
                  value: state.fontSize,
                  min: 30.0, // Start from 30
                  max: 50.0, // You can adjust the max as needed
                  divisions: 20, // Number of steps on the slider
                  label: state.fontSize.toString(),
                  onChanged: (newValue) {
                    context.read<SettingsCubit>().setFontSize(newValue);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
