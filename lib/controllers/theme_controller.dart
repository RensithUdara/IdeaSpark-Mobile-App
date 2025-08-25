import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static const String _themeKey = 'isDarkMode';

  // Load theme preference
  static Future<bool> loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  // Save theme preference
  static Future<void> saveThemePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  // Toggle theme
  static Future<bool> toggleTheme() async {
    bool currentTheme = await loadThemePreference();
    bool newTheme = !currentTheme;
    await saveThemePreference(newTheme);
    return newTheme;
  }
}
