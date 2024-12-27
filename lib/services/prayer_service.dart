import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import '../providers/setting_provider.dart';

class PrayerService {
  final SettingsProvider? settingsProvider;

  PrayerService({this.settingsProvider});

  Future<Map<String, dynamic>> getPrayerTimes({String? customLocation}) async {
    // Determine location priority:
    // 1. Custom location passed as argument
    // 2. Location from settings
    // 3. Current device location
    // 4. Fallback to Mecca
    String location = await _determineLocation(customLocation);

    // Get current date
    final now = DateTime.now();
    final date = DateFormat('dd-MM-yyyy').format(now);

    // Determine calculation method and parameters
    final params = await _determineCalculationParams();

    // Construct URL with all parameters
    final String url = 'https://api.aladhan.com/v1/timingsByAddress/$date?'
        'address=$location'
        '&method=${params['method']}'
        '&school=${params['school']}'
        '&latitude=${params['latitude']}'
        '&longitude=${params['longitude']}'
        '&timezonestring=${params['timezone']}'
        '&tune=0,0,0,0,0,0,0,0,0';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final timings = data['data']['timings'] as Map<String, dynamic>;
      final meta = data['data']['meta'];

      // Calculate remaining time for current prayer
      final currentPrayer = _getCurrentPrayer(timings);
      final remainingTime = _calculateRemainingTime(timings[currentPrayer]);

      return {
        'timings': timings,
        'currentPrayer': currentPrayer,
        'remainingTime': remainingTime,
        'meta': meta,
        'location': location,
      };
    } else {
      throw Exception('Failed to load prayer times');
    }
  }

  Future<String> _determineLocation(String? customLocation) async {
    // Priority order for location
    if (customLocation != null && customLocation.isNotEmpty) {
      return customLocation;
    }

    if (settingsProvider != null) {
      await settingsProvider!.init();
      if (settingsProvider!.location.isNotEmpty) {
        return settingsProvider!.location;
      }
    }

    // Try to get current device location
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return 'Mecca, Saudi Arabia';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();
        return '${position.latitude},${position.longitude}';
      }
    } catch (e) {
      // Silently fail and use default
    }

    // Fallback to default location
    return 'Mecca, Saudi Arabia';
  }

  Future<Map<String, dynamic>> _determineCalculationParams() async {
    // Default parameters
    Map<String, dynamic> params = {
      'method': 3, // Muslim World League
      'school': 0, // Standard Calculation
      'latitude': 0.0,
      'longitude': 0.0,
      'timezone': '',
    };

    // If SettingsProvider is available, try to get its parameters
    if (settingsProvider != null) {
      await settingsProvider!.init();
      final settingsParams = settingsProvider!.getPrayerCalculationParams();

      // Merge settings with default, prioritizing settings
      settingsParams.forEach((key, value) {
        if (value != null && value != 0.0 && value != '') {
          params[key] = value;
        }
      });
    }

    return params;
  }

  String _getCurrentPrayer(Map<String, dynamic> timings) {
    final now = DateTime.now();
    final prayers = [
      'Fajr',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha'
    ]; // Keep original prayer list

    for (int i = prayers.length - 1; i >= 0; i--) {
      final prayerTime = _parseTime(timings[prayers[i]]);
      if (now.isAfter(prayerTime)) {
        return i == prayers.length - 1 ? prayers[0] : prayers[i + 1];
      }
    }
    return prayers[0];
  }

  String _calculateRemainingTime(String prayerTime) {
    final now = DateTime.now();
    final prayer = _parseTime(prayerTime);

    if (prayer.isBefore(now)) {
      // If prayer time has passed, calculate time until next day's prayer
      final nextPrayer = prayer.add(const Duration(days: 1));
      return _formatDuration(nextPrayer.difference(now));
    }

    return _formatDuration(prayer.difference(now));
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

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m remaining';
  }
}
