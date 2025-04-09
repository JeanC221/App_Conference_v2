import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Save a string value
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // Get a string value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Save a list of strings
  Future<bool> saveStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  // Get a list of strings
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Remove a value
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Clear all values
  Future<bool> clear() async {
    return await _prefs.clear();
  }
}
