import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCRUD {
  Future<void> setStringSharedPreferences(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> getStringSharedPreferences(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(key);
    return result == null ? '' : result;
  }

  Future<void> removeSharedPereferences(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<void> clearSharedPereferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
