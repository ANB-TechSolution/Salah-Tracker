import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PrayerService {
  static const String baseUrl = 'https://api.aladhan.com/v1/timings';

  Future<Map<String, dynamic>> getPrayerTimes(String location) async {
    // Get current date
    final now = DateTime.now();
    final date = DateFormat('dd-MM-yyyy').format(now);

    // Change method to 99 for Hanafi school (instead of previous method 2)
    final String url =
        'https://api.aladhan.com/v1/timingsByAddress/$date?address=$location&method=99&tune=0,0,0,0,0,0,0,0,0';

    try {
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
        };
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      throw Exception('Error fetching prayer times: $e');
    }
  }

  String _getCurrentPrayer(Map<String, dynamic> timings) {
    final now = DateTime.now();
    final prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

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
      final nextPrayer = prayer.add(Duration(days: 1));
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
