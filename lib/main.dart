import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/settings_cubit.dart';
import 'screens/script_runner_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: 'Watchdog',
            theme: ThemeData.dark().copyWith(
              iconTheme: IconThemeData(
                size: 30.0, // Global icon size
              ),
              iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(
                  iconSize: const WidgetStatePropertyAll(50),
                  //padding: WidgetStateProperty.all(EdgeInsets.all(4)),
                  minimumSize: WidgetStateProperty.all(Size(120, 120)),
                ),
              ),
              // Set global tooltip theme and font size
              tooltipTheme: TooltipThemeData(
                textStyle: TextStyle(
                  fontSize: settingsState
                      .fontSize, // Inherit font size from SettingsCubit
                  color: Colors.white, // Tooltip text color
                ),
                decoration: BoxDecoration(
                  color: Colors.black87, // Tooltip background color
                ),
              ),
            ),
            home: ScriptRunnerHome(),
          );
        },
      ),
    );
  }
}
