import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/hair_data.dart';

class Storage {
  static const _profileKey = 'hhc-profile';
  static const _onboardedKey = 'hhc-onboarded';
  static const _routineProgressPrefix = 'hhc-routine-progress-';

  static Future<void> saveProfile(HairProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
    await prefs.setBool(_onboardedKey, true);
  }

  static Future<HairProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null) return null;
    try {
      return HairProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> isOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardedKey) ?? false;
  }

  static Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    await prefs.remove(_onboardedKey);
  }

  static String currentWeekKey([DateTime? date]) {
    final now = date ?? DateTime.now();
    final monday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - DateTime.monday));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  static Future<Set<String>> loadRoutineProgress({String? weekKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs
        .getStringList('$_routineProgressPrefix${weekKey ?? currentWeekKey()}');
    return raw?.toSet() ?? <String>{};
  }

  static Future<void> saveRoutineProgress(Set<String> completed,
      {String? weekKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final items = completed.toList()..sort();
    await prefs.setStringList(
        '$_routineProgressPrefix${weekKey ?? currentWeekKey()}', items);
  }

  static Future<void> clearRoutineProgress({String? weekKey}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_routineProgressPrefix${weekKey ?? currentWeekKey()}');
  }
}
