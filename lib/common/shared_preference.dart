import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class AppPreferences {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  saveStringPreference(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(key, value);
  }

  saveBoolPreference(String key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  saveIntPreference(String key, int? value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(key, value!);
  }

  saveDoublePreference(String key, double value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setDouble(key, value);
  }

  saveListPreference(String key, List<String> value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setStringList(key, value);
  }
  // saveCountryListPreference(String key, List<Country> value) async {
  //   final SharedPreferences prefs = await _prefs;
  //   await prefs.setStringList(key, value);
  // }

  getStringPreference(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  getBoolPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  getIntPreference(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(key) ?? -1;
  }

  getDoublePreference(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble(key) ?? -1;
  }

  getListPreference(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(key) ?? '';
  }

  clearPreferences() async {
    await appPreferences.saveStringPreference(Constants.firstName, '');
    await appPreferences.saveStringPreference(Constants.lastName, '');
    await appPreferences.saveStringPreference(Constants.accessToken, '');
    await appPreferences.saveBoolPreference(Constants.refreshLogin, false);
    await appPreferences.saveBoolPreference(Constants.keepRememberIn, false);
  }

  static final AppPreferences _appPreferences = AppPreferences._internal();
  factory AppPreferences() {
    return _appPreferences;
  }
  AppPreferences._internal();

  //for road map
  static Future<void> saveLevelCompleted(String roadmapId, int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$roadmapId-level_$level', true);
  }

  static Future<bool> isLevelCompleted(String roadmapId, int levelIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("$roadmapId-level_$levelIndex") ?? false;
  }

  static Future<void> saveOnBoardingLevelCompleted(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_level_$level', true);
  }

  static Future<bool> isOnBoardingLevelCompleted(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_level_$level') ?? false;
  }
}

AppPreferences appPreferences = AppPreferences();
