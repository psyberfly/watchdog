import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/settings_cubit.dart';
import 'screens/script_runner_home.dart';
import 'screens/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(), // Provide SettingsCubit at root
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Script Runner',
        theme: ThemeData.dark().copyWith(
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                  EdgeInsets.all(8)), // Button size (padding)
              minimumSize: WidgetStateProperty.all(
                  Size(100, 100)), // Button size (min width & height)
              maximumSize: WidgetStateProperty.all(
                  Size(200, 200)), // Button size (max width & height)
            ),
          ),
        ),
        home: ScriptRunnerHome(),
      ),
    );
  }
}
