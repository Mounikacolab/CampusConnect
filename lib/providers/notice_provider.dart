import 'package:flutter/foundation.dart';
import '../models/notice.dart';
import '../services/notice_storage.dart';

enum NoticeStatus { loading, error, empty, data }

class NoticeProvider extends ChangeNotifier {
  final NoticeStorage _storage = NoticeStorage();
  List<Notice> _notices = [];
  NoticeStatus _status = NoticeStatus.loading;
  String? _errorMessage;
  String _selectedDepartment = 'All';

  List<Notice> get notices => List.unmodifiable(_notices);
  NoticeStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get selectedDepartment => _selectedDepartment;

  List<String> get departments => const [
        'All', 'Computer Science', 'AIML', 'ECE', 'EEE',
        'Mechanical', 'Civil', 'General'
      ];

  List<Notice> get filteredNotices {
    if (_selectedDepartment == 'All') return List.unmodifiable(_notices);
    return List.unmodifiable(
      _notices.where((n) => n.department == _selectedDepartment),
    );
  }

  Future<void> loadNotices() async {
    _status = NoticeStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _notices = await _storage.readNotices();
      _status = _notices.isEmpty ? NoticeStatus.empty : NoticeStatus.data;
    } catch (e) {
      _errorMessage = 'Unable to load notices. Please try again.';
      _status = NoticeStatus.error;
    }
    notifyListeners();
  }

  Future<void> addNotice(Notice notice) async {
    final updated = [notice, ..._notices];
    await _storage.saveNotices(updated);
    _notices = updated;
    _status = NoticeStatus.data;
    notifyListeners();
  }

  void selectDepartment(String department) {
    _selectedDepartment = department;
    notifyListeners();
  }

  Future<void> deleteNotice(String id) async {
    final updated = _notices.where((notice) => notice.id != id).toList();
    await _storage.saveNotices(updated);
    _notices = updated;
    _status = _notices.isEmpty ? NoticeStatus.empty : NoticeStatus.data;
    notifyListeners();
  }
}
