import 'package:process_run/shell.dart';
import 'dart:io';

class ScriptLib {
  final Shell shell = Shell();

  Future<String> runScript(String scriptPath) async {
    var result = await shell.run(scriptPath);
    return result.outText;
  }

  Future<List<Map<String, String>>> loadScriptsFromDir(
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

  Future<void> runScriptWithEnv(String scriptPath, String envFilePath) async {
    final result = await Process.run('bash', [scriptPath],
        environment: await _loadEnvVars(envFilePath));

    if (result.exitCode == 0) {
      print('Script output: ${result.stdout}');
    } else {
      print('Error: ${result.stderr}');
    }
  }

// Helper function to load .env file into a map
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

  void loadAndRunAllScripts(String dataDirPath) async {
    final scriptsWithEnv = await loadScriptsFromDir(dataDirPath);

    for (var scriptWithEnv in scriptsWithEnv) {
      final scriptPath = scriptWithEnv['script']!;
      final envFilePath = scriptWithEnv['env']!;
      print('Running script: $scriptPath with env: $envFilePath');

      await runScriptWithEnv(scriptPath, envFilePath);
    }
  }
}
