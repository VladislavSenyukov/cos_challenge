import 'dart:convert';

import 'package:cos_challenge/core/network_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static const _userIdKey = 'userId';
  static const _lastVinDataKey = 'lastVinData';

  static Future<SharedPreferences> _getPrefs() async =>
      SharedPreferences.getInstance();

  static Future<void> setUserId(String? userId) async {
    final prefs = await _getPrefs();
    await (userId != null
        ? prefs.setString(_userIdKey, userId)
        : prefs.remove(_userIdKey));
  }

  static Future<String?> getUserId() async =>
      (await _getPrefs()).getString(_userIdKey);

  static Future<void> setLastVinData(VinData? vinData) async {
    final prefs = await _getPrefs();
    if (vinData == null) {
      await prefs.remove(_lastVinDataKey);
      return;
    }
    final lastVinDataString = json.encode(vinData.toJson());
    await prefs.setString(_lastVinDataKey, lastVinDataString);
  }

  static Future<VinData?> getLastVinData() async {
    final lastVinDataString = (await _getPrefs()).getString(_lastVinDataKey);
    return lastVinDataString != null
        ? VinData.fromJson(json.decode(lastVinDataString))
        : null;
  }
}
