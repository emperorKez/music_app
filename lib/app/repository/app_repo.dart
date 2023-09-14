import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRepository {
  checkFirstRun() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
      return isFirstRun;
    } catch (_) {}
  }

  setFirstRun() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isFirstRun', true);
    } catch (_) {}
  }

  getTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool darkMode = prefs.getBool('darkMode') ?? false;
      return darkMode;
    } catch (e) {
      return false;
    }
  }

  setTheme(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('darkMode', isDark);
      return isDark;
    } catch (e) {
      return false;
    }
  }

  getAppVersionInfo() async {
    return await PackageInfo.fromPlatform();
  }

  static Future sharedPref() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs;
    } catch (_) {}
  }
}
