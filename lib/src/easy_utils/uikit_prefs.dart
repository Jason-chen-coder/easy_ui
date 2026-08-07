import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UikitPrefs {
  UikitPrefs._();

  static final UikitPrefs instance = UikitPrefs._();

  Future<SharedPreferences>? _preferencesFuture;

  Future<SharedPreferences> get _preferences {
    return _preferencesFuture ??= SharedPreferences.getInstance();
  }

  static const String keyPrefix = 'easy_ui.';

  static String buildKey(String key) => '$keyPrefix$key';

  static Future<bool> containsKey(String key) async {
    return instance.hasKey(key);
  }

  Future<bool> hasKey(String key) async {
    final preferences = await _preferences;
    return preferences.containsKey(buildKey(key));
  }

  static Future<T?> getJson<T>(
    String key,
    T? Function(Object? json) fromJson,
  ) async {
    return instance.readJson(key, fromJson);
  }

  Future<T?> readJson<T>(String key, T? Function(Object? json) fromJson) async {
    final preferences = await _preferences;
    final value = preferences.get(buildKey(key));
    if (value is! String) {
      return null;
    }

    try {
      return fromJson(jsonDecode(value));
    } catch (_) {
      return null;
    }
  }

  static Future<bool> setJson(String key, Object? json) async {
    return instance.writeJson(key, json);
  }

  Future<bool> writeJson(String key, Object? json) async {
    final preferences = await _preferences;
    return preferences.setString(buildKey(key), jsonEncode(json));
  }

  static Future<bool> remove(String key) async {
    return instance.delete(key);
  }

  Future<bool> delete(String key) async {
    final preferences = await _preferences;
    return preferences.remove(buildKey(key));
  }

  static void resetInstanceForTesting() {
    instance._preferencesFuture = null;
  }
}
