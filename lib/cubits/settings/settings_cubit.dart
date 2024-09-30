import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define your SettingsState
class SettingsState {
  final double fontSize;
  final List<Map<String, String>>
      scripts; // List of scripts and their env files

  SettingsState({
    this.fontSize = 14.0,
    this.scripts = const [],
  });

  SettingsState copyWith({
    double? fontSize,
    List<Map<String, String>>? scripts,
  }) {
    return SettingsState(
      fontSize: fontSize ?? this.fontSize,
      scripts: scripts ?? this.scripts,
    );
  }
}

// Define the SettingsCubit
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  // Load all scripts from the data directory
  Future<void> loadScriptsFromDataDir() async {
    String dataDirPath =
        '/home/anorak/Anorak/watchdog/data'; // Define your data directory path
    final scripts = await _scanDataDirectory(dataDirPath);

    // Update the state with the loaded scripts
    emit(state.copyWith(scripts: scripts));
  }

  // Function to scan the data directory for scripts and .env files
  Future<List<Map<String, String>>> _scanDataDirectory(
      String dataDirPath) async {
    final dataDir = Directory(dataDirPath);
    List<Map<String, String>> scriptsWithEnv = [];

    if (await dataDir.exists()) {
      final subDirs = dataDir.listSync().whereType<Directory>();

      for (var dir in subDirs) {
        final scriptFile = File('${dir.path}/script.sh');
        final envFile = File('${dir.path}/.env');

        if (await scriptFile.exists() && await envFile.exists()) {
          // Add the script and env file paths to the list
          scriptsWithEnv.add({
            'script': scriptFile.path,
            'env': envFile.path,
          });
        }
      }
    }

    return scriptsWithEnv;
  }

  // Method to run the script and return its output
  Future<String> runScript(String scriptPath, String envFilePath) async {
    try {
      // Get the directory where the script is located
      final scriptDirectory = Directory(scriptPath).parent.path;

      // Run the script and set the working directory
      final result = await Process.run(
        'bash',
        [scriptPath],
        workingDirectory: scriptDirectory, // Set the working directory
        environment:
            await _loadEnvVars(envFilePath), // Load environment variables
      );

      // Capture and return the script output
      if (result.exitCode == 0) {
        return result.stdout; // Successful execution returns standard output
      } else {
        return 'Error: ${result.stderr}'; // In case of failure, return error output
      }
    } catch (e, stackTrace) {
      return 'Failed to run script. Exception: $e\nStack trace:\n$stackTrace';
    }
  }

  // Load environment variables from the .env file into a Map
  Future<Map<String, String>> _loadEnvVars(String envFilePath) async {
    final envFile = File(envFilePath);
    Map<String, String> envVars = {};

    if (await envFile.exists()) {
      final lines = await envFile.readAsLines();
      for (var line in lines) {
        if (line.trim().isNotEmpty && !line.startsWith('#')) {
          var parts = line.split('=');
          if (parts.length == 2) {
            envVars[parts[0].trim()] = parts[1].trim();
          }
        }
      }
    }

    return envVars;
  }
}
