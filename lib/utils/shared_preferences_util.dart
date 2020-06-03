///
/// `shared_preferences_util.dart`
/// Class contains shared preferences and file reading/writing methods
/// Source: Reading docs and copied from them.
///

import 'package:shared_preferences/shared_preferences.dart';
import 'package:storemanager/main.dart';

class SharedPreferencesUtil {
  static void saveIsDarkThemeMode(bool mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('IsDarkMode', mode);
  }

  static Future<bool> getIsDarkThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool('IsDarkMode'));
  }

  static void saveIsLogin(bool mode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('isLoggedIn', mode);
  }

  static Future<bool> getIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') != null)
      return (prefs.getBool('isLoggedIn'));

    return false;
  }

  static void saveStoreId(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('StoreID', id);
  }

  static Future<String> getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('StoreID') != null)
      return (prefs.getString('StoreID'));
    else
      return "0";
  }
}
