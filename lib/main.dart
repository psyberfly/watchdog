import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/settings/settings_cubit.dart';
import 'screens/script_runner_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit()..loadScriptsFromDataDir(),
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
                  minimumSize: WidgetStateProperty.all(Size(120, 120)),
                ),
              ),
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
