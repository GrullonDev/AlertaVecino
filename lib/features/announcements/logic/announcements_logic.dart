import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/features/announcements/data/announcements_error.dart';
import 'package:neighbour_alert/features/announcements/data/repository.dart';
import 'package:neighbour_alert/features/announcements/models/announcement.dart';

class AnnouncementsLogic extends ChangeNotifier {
  AnnouncementsLogic({
    required AnnouncementsRepository repository,
    required SessionService session,
  }) : _repository = repository,
       _session = session;

  final AnnouncementsRepository _repository;
  final SessionService _session;

  List<Announcement> _announcements = [];
  AnnouncementCategory? _selectedCategory;
  bool _loading = false;
  AnnouncementsErrorType? _error;

  List<Announcement> get announcements {
    if (_selectedCategory == null) return _announcements;
    return _announcements
        .where((a) => a.category == _selectedCategory)
        .toList();
  }

  AnnouncementCategory? get selectedCategory => _selectedCategory;
  bool get loading => _loading;
  AnnouncementsErrorType? get error => _error;

  void selectCategory(AnnouncementCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void markRead(String id) {
    final idx = _announcements.indexWhere((a) => a.id == id);
    if (idx >= 0) {
      _announcements[idx] = _announcements[idx].copyWith(isRead: true);
      notifyListeners();
    }
  }

  Future<void> load() async {
    final token = _session.token;
    if (token == null) {
      _error = AnnouncementsErrorType.unauthorized;
      notifyListeners();
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _announcements = await _repository.list(token: token);
      _error = null;
    } on AnnouncementsException catch (e) {
      dev.log('[announcements] $e');
      _error = e.type;
    } catch (e) {
      dev.log('[announcements] unexpected: $e');
      _error = AnnouncementsErrorType.unknown;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();
}
