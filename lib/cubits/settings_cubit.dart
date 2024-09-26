import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final double fontSize;

  SettingsState({required this.fontSize});
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(fontSize: 16.0)) {
    loadFontSize();
  }

  // Load saved font size from SharedPreferences
  Future<void> loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final fontSize = prefs.getDouble('font_size') ?? 16.0;
    emit(SettingsState(fontSize: fontSize));
  }

  // Set new font size and persist it
  Future<void> setFontSize(double newSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size', newSize);
    emit(SettingsState(fontSize: newSize));
  }
}
