// cubit/script_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/script_info.dart';
import '../services/script_service.dart';
import '../utils/storage_util.dart';

class ScriptState {
  final List<ScriptInfo> scripts;
  final List<String> outputs;
  final List<bool> isRunning;
  final bool isInitialized;

  ScriptState({
    required this.scripts,
    required this.outputs,
    required this.isRunning,
    required this.isInitialized,
  });

  ScriptState copyWith({
    List<ScriptInfo>? scripts,
    List<String>? outputs,
    List<bool>? isRunning,
    bool? isInitialized,
  }) {
    return ScriptState(
      scripts: scripts ?? this.scripts,
      outputs: outputs ?? this.outputs,
      isRunning: isRunning ?? this.isRunning,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class ScriptCubit extends Cubit<ScriptState> {
  final ScriptService _scriptService = ScriptService();

  ScriptCubit()
      : super(ScriptState(
          scripts: [],
          outputs: [],
          isRunning: [],
          isInitialized: false,
        )) {
    loadScripts();
  }

  Future<void> loadScripts() async {
    List<ScriptInfo> scripts = await StorageUtil.loadScripts();
    int scriptCount = scripts.length;
    emit(state.copyWith(
      scripts: scripts,
      outputs: List<String>.filled(scriptCount, ''),
      isRunning: List<bool>.filled(scriptCount, false),
      isInitialized: true,
    ));

    for (int i = 0; i < scriptCount; i++) {
      runScript(i);
    }
  }

  Future<void> saveScripts() async {
    await StorageUtil.saveScripts(state.scripts);
  }

  Future<void> runScript(int index) async {
    List<bool> isRunning = List.from(state.isRunning);
    isRunning[index] = true;
    emit(state.copyWith(isRunning: isRunning));

    try {
      String output = await _scriptService.runScript(state.scripts[index].path);
      List<String> outputs = List.from(state.outputs);
      outputs[index] = output;
      emit(state.copyWith(outputs: outputs));
    } catch (e) {
      List<String> outputs = List.from(state.outputs);
      outputs[index] = 'Error running script:\n$e';
      emit(state.copyWith(outputs: outputs));
    } finally {
      isRunning[index] = false;
      emit(state.copyWith(isRunning: isRunning));
    }
  }

  Future<void> refreshCurrentScript(int index) async {
    await runScript(index);
  }

  Future<void> addScript(String path, String name) async {
    List<ScriptInfo> scripts = List.from(state.scripts)
      ..add(ScriptInfo(path: path, name: name));
    List<String> outputs = List.from(state.outputs)..add('');
    List<bool> isRunning = List.from(state.isRunning)..add(false);

    emit(state.copyWith(
      scripts: scripts,
      outputs: outputs,
      isRunning: isRunning,
    ));

    await saveScripts();
    int index = scripts.length - 1;
    await runScript(index);
  }

  Future<void> removeScript(int index) async {
    List<ScriptInfo> scripts = List.from(state.scripts)..removeAt(index);
    List<String> outputs = List.from(state.outputs)..removeAt(index);
    List<bool> isRunning = List.from(state.isRunning)..removeAt(index);

    emit(state.copyWith(
      scripts: scripts,
      outputs: outputs,
      isRunning: isRunning,
    ));

    await saveScripts();
  }
}
