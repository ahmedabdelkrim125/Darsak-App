import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  AppSettings._();

  static final AppSettings instance = AppSettings._();

  static const String _darkKey = 'settings.dark_mode';
  static const String _lessonsKey = 'settings.notify_lessons';
  static const String _paymentsKey = 'settings.notify_payments';
  static const String _groupsKey = 'settings.notify_groups';
  static const String _reminderKey = 'settings.reminder_minutes';

  SharedPreferences? _prefs;
  bool _isDark = false;
  bool _notifyLessons = true;
  bool _notifyPayments = true;
  bool _notifyGroups = true;
  int _reminderMinutes = 15;

  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;
  bool get notifyLessons => _notifyLessons;
  bool get notifyPayments => _notifyPayments;
  bool get notifyGroups => _notifyGroups;
  int get reminderMinutes => _reminderMinutes;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _prefs = prefs;
      _isDark = prefs.getBool(_darkKey) ?? _isDark;
      _notifyLessons = prefs.getBool(_lessonsKey) ?? _notifyLessons;
      _notifyPayments = prefs.getBool(_paymentsKey) ?? _notifyPayments;
      _notifyGroups = prefs.getBool(_groupsKey) ?? _notifyGroups;
      _reminderMinutes = prefs.getInt(_reminderKey) ?? _reminderMinutes;
    } catch (_) {
      _prefs = null;
    }
  }

  void setDark(bool value) {
    if (_isDark == value) return;
    _isDark = value;
    _prefs?.setBool(_darkKey, value);
    notifyListeners();
  }

  void setNotifyLessons(bool value) {
    if (_notifyLessons == value) return;
    _notifyLessons = value;
    _prefs?.setBool(_lessonsKey, value);
    notifyListeners();
  }

  void setNotifyPayments(bool value) {
    if (_notifyPayments == value) return;
    _notifyPayments = value;
    _prefs?.setBool(_paymentsKey, value);
    notifyListeners();
  }

  void setNotifyGroups(bool value) {
    if (_notifyGroups == value) return;
    _notifyGroups = value;
    _prefs?.setBool(_groupsKey, value);
    notifyListeners();
  }

  void setReminderMinutes(int value) {
    if (_reminderMinutes == value) return;
    _reminderMinutes = value;
    _prefs?.setInt(_reminderKey, value);
    notifyListeners();
  }
}
