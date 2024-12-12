import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/prayer_service.dart';
import '../utils/constants/prayer_setting.dart';

class PrayerTimingsProvider with ChangeNotifier {
  final String location;
  final double latitude;
  final double longitude;
  final PrayerService _prayerService;
  final SharedPreferences _prefs;

  // State variables
  Timer? _timer;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _prayerData;

  // Settings variables
  late int _selectedCalculationMethod;
  String _selectedHighLatMethod = '';

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedCalculationMethod => _selectedCalculationMethod;
  String get selectedHighLatMethod => _selectedHighLatMethod;

  // Prayer data getters
  Map<String, String> get timings {
    return (_prayerData?['timings'] as Map<String, dynamic> ?? {})
        .map((key, value) => MapEntry(key, value.toString()));
  }

  String get currentPrayer => _prayerData?['currentPrayer'] ?? 'Unknown';
  String get remainingTime => _prayerData?['remainingTime'] ?? '00:00';

  PrayerTimingsProvider({
    required this.location,
    required this.latitude,
    required this.longitude,
    required SharedPreferences prefs,
  })  : _prefs = prefs,
        _prayerService = PrayerService(prefs: prefs) {
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    try {
      // Load saved settings
      _loadSavedSettings();

      // Fetch initial prayer times
      await _fetchPrayerTimes();

      // Start periodic refresh
      _startPeriodicRefresh();
    } catch (e) {
      _handleInitializationError(e);
    }
  }

  void _loadSavedSettings() {
    final savedMethod = _prefs.getString('highLatMethod');
    _selectedHighLatMethod = PrayerSettings.getHighLatMethod(savedMethod);

    final savedCalculationMethod = _prefs.getInt('calculationMethod');
    _selectedCalculationMethod =
        PrayerSettings.getCalculationMethod(savedCalculationMethod);
  }

  Future<void> _fetchPrayerTimes() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      final result = await _prayerService.getPrayerTimes(
        latitude: latitude,
        longitude: longitude,
      );

      // Validate and update prayer data
      if (_validatePrayerData(result)) {
        _prayerData = result;
        _error = null;
      } else {
        throw Exception('Invalid prayer data');
      }
    } catch (e) {
      _error = 'Failed to fetch prayer times: ${e.toString()}';
      _prayerData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _validatePrayerData(Map<String, dynamic> data) {
    return data.containsKey('timings') &&
        data.containsKey('currentPrayer') &&
        data.containsKey('remainingTime');
  }

  void _handleInitializationError(dynamic error) {
    _error = 'Initialization failed: ${error.toString()}';
    notifyListeners();
  }

  void _startPeriodicRefresh() {
    // Cancel any existing timer
    _timer?.cancel();

    // Start a new timer to refresh every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _fetchPrayerTimes();
    });
  }

  Future<void> updateCalculationMethod(int method) async {
    try {
      await _prefs.setInt('calculationMethod', method);
      _selectedCalculationMethod = method;
      await refresh();
    } catch (e) {
      _error = 'Failed to update calculation method: $e';
      notifyListeners();
    }
  }

  Future<void> updateHighLatMethod(String method) async {
    try {
      await _prefs.setString('highLatMethod', method);
      _selectedHighLatMethod = method;
      await refresh();
    } catch (e) {
      _error = 'Failed to update high latitude method: $e';
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _error = null;
    await _fetchPrayerTimes();
  }

  String convertTo12HourFormat(String time) {
    try {
      if (time.isEmpty) return '--:--';

      final parts = time.split(':');
      if (parts.length < 2) return time;

      int hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';

      hour = hour % 12;
      hour = hour == 0 ? 12 : hour;

      return '$hour:$minute $period';
    } catch (e) {
      print('Time conversion error: $e');
      return time;
    }
  }

  bool isCurrentPrayer(String prayer) {
    return prayer.toLowerCase() == currentPrayer.toLowerCase();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
