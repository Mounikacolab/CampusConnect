import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notice.dart';

class NoticeStorage {
  static const _storageKey = 'campus_connect_notices_v1';

  Future<List<Notice>> readNotices() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Notice.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveNotices(List<Notice> notices) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(notices.map((notice) => notice.toJson()).toList());
    final saved = await prefs.setString(_storageKey, raw);
    if (!saved) throw Exception('Could not save notices on this device.');
  }
}
