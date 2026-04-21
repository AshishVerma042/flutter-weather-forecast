import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static void fieldFocusChanged(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }


  static void savePreferenceValues(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<dynamic> getPreferenceValues(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      key,
    );
  }
  static Future<dynamic> clearPreferenceValues() async {
    SharedPreferences value = await SharedPreferences.getInstance();
    await value.clear();

  }

  static void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static void printLog(var msg) {
    if (kDebugMode) {
      print(msg);
    }
  }
}
