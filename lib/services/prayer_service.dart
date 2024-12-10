import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerService {
  static const String baseUrl = 'https://api.aladhan.com/timingsByAddress';

  Future<Map<String, String>> getPrayerTimes(String location) async {
    // Prepare the URL with location and date
    final String url =
        '$baseUrl/06-12-2024?address=$location&method=8&tune=2,3,4,5,2,3,4,5,-3';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'] as Map<String, dynamic>;

        // Convert timings to string format and return
        return timings.map((key, value) => MapEntry(key, value.toString()));
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      throw Exception('Error fetching prayer times: $e');
    }
  }
}
