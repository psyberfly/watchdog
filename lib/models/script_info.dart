// models/script_info.dart
class ScriptInfo {
  String path;
  String name;

  ScriptInfo({required this.path, required this.name});

  // Convert a ScriptInfo into a Map
  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'name': name,
    };
  }

  // Create a ScriptInfo from a Map
  factory ScriptInfo.fromMap(Map<String, dynamic> map) {
    return ScriptInfo(
      path: map['path'],
      name: map['name'],
    );
  }
}
