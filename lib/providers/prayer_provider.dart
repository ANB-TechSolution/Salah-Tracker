import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../services/prayer_service.dart';

class PrayerTimingsProvider with ChangeNotifier {
  final PrayerService _prayerService;
  String? _location;

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

  Future<void> _fetchPrayerTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      // If a specific location is provided, use it. Otherwise, let service determine location
      _prayerData =
          await _prayerService.getPrayerTimes(customLocation: _location);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
