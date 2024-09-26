// utils/storage_util.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/script_info.dart';

class StorageUtil {
  static const String _scriptsKey = 'scripts';

  static Future<void> saveScripts(List<ScriptInfo> scripts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> scriptsJson = scripts.map((script) => jsonEncode(script.toMap())).toList();
    await prefs.setStringList(_scriptsKey, scriptsJson);
  }

  static Future<List<ScriptInfo>> loadScripts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? scriptsJson = prefs.getStringList(_scriptsKey);
    if (scriptsJson != null) {
      return scriptsJson.map((script) => ScriptInfo.fromMap(jsonDecode(script))).toList();
    }
    return [];
  }
}
