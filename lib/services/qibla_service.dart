import 'package:dio/dio.dart';

class QiblaService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://api.aladhan.com/v1/qibla';

  Future<double> getQiblaDirection(double latitude, double longitude) async {
    try {
      // Construct the full URL with latitude and longitude as path parameters
      final url = '$_baseUrl/$latitude/$longitude';

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        // Correctly parse the direction from the nested 'data' map
        final Map<String, dynamic> responseData = response.data;
        final Map<String, dynamic> data = responseData['data'];

        // Extract the direction and ensure it's a double
        final direction = data['direction'];

        // Ensure we return a double
        return direction is double
            ? direction
            : double.parse(direction.toString());
      } else {
        throw Exception('Failed to load Qibla direction');
      }
    } catch (e) {
      print('Error fetching Qibla direction: $e');
      rethrow;
    }
  }
}
