// prayer_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants/prayer_setting.dart';

class PrayerService {
  static const String baseUrl = 'https://api.aladhan.com/v1/timings';
  final SharedPreferences prefs;
  final http.Client _client;

  PrayerService({
    required this.prefs,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getPrayerTimes({
    required double latitude,
    required double longitude,
  }) async {
    if (latitude == null || longitude == null) {
      throw Exception('Latitude and Longitude are required');
    }

    final now = DateTime.now();
    final date = DateFormat('dd-MM-yyyy').format(now);

    final calcMethod = prefs.getInt(PrayerSettings.CALC_METHOD_KEY) ?? 1;
    final highLatMethod =
        prefs.getString(PrayerSettings.HIGH_LAT_METHOD_KEY) ?? 'none';

    final queryParameters = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'method': calcMethod.toString(),
      'date': date,
    };

    try {
      final uri = Uri.parse(baseUrl).replace(
        queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!_validateApiResponse(data)) {
          throw Exception('Invalid API response format');
        }

        final timings = data['data']['timings'] as Map<String, dynamic>;
        final currentPrayer = _getCurrentPrayer(timings);
        final remainingTime = _calculateRemainingTime(timings[currentPrayer]);

        return {
          'timings': timings,
          'currentPrayer': currentPrayer,
          'remainingTime': remainingTime,
          'meta': data['data']['meta'],
        };
      } else {
        throw HttpException(
            'Failed to load prayer times: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching prayer times: ${e.toString()}');
    }
  }

  bool _validateApiResponse(Map<String, dynamic> data) {
    try {
      return data['data'] != null &&
          data['data']['timings'] is Map<String, dynamic> &&
          data['data']['meta'] != null;
    } catch (e) {
      return false;
    }
  }

  String _getCurrentPrayer(Map<String, dynamic> timings) {
    final now = DateTime.now();
    final prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    try {
      for (int i = prayers.length - 1; i >= 0; i--) {
        final prayerTime = _parseTime(timings[prayers[i]] ?? '');
        if (prayerTime != null && prayerTime.isBefore(now)) {
          return prayers[i];
        }
      }
      return prayers[0];
    } catch (e) {
      return prayers[0];
    }
  }

  DateTime? _parseTime(String time) {
    try {
      final now = DateTime.now();
      final parts = time.split(':');
      if (parts.length != 2) return null;

      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (e) {
      return null;
    }
  }

  String _calculateRemainingTime(String prayerTime) {
    try {
      final now = DateTime.now();
      final prayer = _parseTime(prayerTime);

      if (prayer == null) return '-- remaining';

      if (prayer.isBefore(now)) {
        final tomorrow = DateTime(now.year, now.month, now.day + 1);
        final nextPrayer = DateTime(
          tomorrow.year,
          tomorrow.month,
          tomorrow.day,
          prayer.hour,
          prayer.minute,
        );
        return _formatDuration(nextPrayer.difference(now));
      }

      return _formatDuration(prayer.difference(now));
    } catch (e) {
      return '-- remaining';
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m remaining';
  }

  Future<void> saveCalculationMethod(int method) async {
    await prefs.setInt(PrayerSettings.CALC_METHOD_KEY, method);
  }

  Future<void> saveHighLatMethod(String method) async {
    await prefs.setString(PrayerSettings.HIGH_LAT_METHOD_KEY, method);
  }
}
