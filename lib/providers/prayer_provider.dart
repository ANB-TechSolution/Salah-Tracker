import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../services/notifi_service.dart';
import '../services/prayer_service.dart';

class PrayerTimingsProvider with ChangeNotifier {
  final PrayerService _prayerService;
  final NotificationService _notificationService = NotificationService();
  String? _location;
  DateTime? _lastNotificationTime;

  Map<String, String> _prayerNames = {
    'Fajr': "It's Fajr time",
    'Sunrise': "It's time for Sunrise",
    'Dhuhr': "It's Dhuhr time",
    'Asr': "It's Asr time",
    'Maghrib': "It's Maghrib time",
    'Isha': "It's Isha time"
  };

  void _checkAndNotify(Map<String, dynamic> timings) {
    final now = DateTime.now();
    if (_lastNotificationTime?.day != now.day) {
      _lastNotificationTime = null;
    }

    for (var prayer in _prayerNames.keys) {
      if (timings.containsKey(prayer)) {
        final prayerTime = _parseTime(timings[prayer]);

        if (now.isAfter(prayerTime) &&
            now.difference(prayerTime).inMinutes < 1 &&
            (_lastNotificationTime == null ||
                now.difference(_lastNotificationTime!).inMinutes >= 1)) {
          _notificationService.showNotification(
            title: 'Prayer Timing',
            body: _prayerNames[prayer] ?? '',
          );
          _lastNotificationTime = now;
        }
      }
    }
  }

  DateTime _parseTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  @override
  Future<void> _fetchPrayerTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _prayerData =
          await _prayerService.getPrayerTimes(customLocation: _location);
      _checkAndNotify(_prayerData?['timings'] ?? {});
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic>? _prayerData;
  Timer? _timer;
  bool _isLoading = true;

  PrayerTimingsProvider(this._prayerService, {String? location}) {
    _location = location;
    _initializePrayerTimes();
  }

  // Getters
  Map<String, dynamic>? get prayerData => _prayerData;
  bool get isLoading => _isLoading;
  String get location =>
      _prayerData?['location'] ?? _location ?? 'Unknown Location';

  Map<String, dynamic> get timings => _prayerData?['timings'] ?? {};
  String get currentPrayer => _prayerData?['currentPrayer'] ?? '';
  String get remainingTime => _prayerData?['remainingTime'] ?? '';
  String get gregorianDate => DateFormat('dd MMMM yyyy').format(DateTime.now());

  bool isCurrentPrayer(String prayer) => prayer == currentPrayer;

  void _initializePrayerTimes() async {
    _startTimer();
    await _fetchPrayerTimes();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _fetchPrayerTimes();
    });
  }

  String convertTo12HourFormat(String time) {
    try {
      final DateFormat inputFormat = DateFormat("HH:mm");
      final DateFormat outputFormat = DateFormat("h:mm a");
      final DateTime dateTime = inputFormat.parse(time);
      return outputFormat.format(dateTime);
    } catch (e) {
      return time;
    }
  }

  // Refresh prayer times manually
  Future<void> refresh() => _fetchPrayerTimes();

  // Allow updating location
  Future<void> updateLocation(String location) async {
    _location = location;
    await _fetchPrayerTimes();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
