// services/script_service.dart
import 'package:process_run/shell.dart';

class ScriptService {
  final Shell shell = Shell();

  Future<String> runScript(String scriptPath) async {
    var result = await shell.run(scriptPath);
    return result.outText;
  }
}
