import 'package:flowdo/common/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [ThemeServices] class consists of properties and methods related theme
class ThemeServices extends ChangeNotifier {
  /// SharedPreferences instance
  late SharedPreferences prefs;

  /// ThemeMode
  ///
  /// By default, set to `ThemeMode.system`
  late ThemeMode _currentTheme;

  /// ThemeMode getter
  ThemeMode get currentTheme => _currentTheme;

  // Constructor
  ThemeServices() {
    _currentTheme = ThemeMode.system;
    loadFromPrefs();
  }

  /// Method to initialise SharedPreferences
  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// Method to toggle ThemeMode
  ///
  /// Pass in [ThemeMode] to set to `themeMode` param
  toggleTheme(ThemeMode themeMode) async {
    _currentTheme = themeMode;
    saveToPrefs();
    notifyListeners();
  }

  /// Method to load themeMode from SharedPreferences
  loadFromPrefs() async {
    await _initPrefs();
    _currentTheme = getPrefs();
    notifyListeners();
  }

  getPrefs() {
    switch (prefs.getString(Strings.themeKey)) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  /// Method to save themeMode to SharedPreferences
  saveToPrefs() async {
    await _initPrefs();
    prefs.setString(Strings.themeKey, _currentTheme.name);
  }
}