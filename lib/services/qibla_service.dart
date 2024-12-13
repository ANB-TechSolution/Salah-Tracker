// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class QiblaService {
//   static const String _baseUrl = "http://api.aladhan.com/v1/qibla";

//   Future<double> getQiblaDirection(double latitude, double longitude) async {
//     final url = Uri.parse("$_baseUrl/$latitude/$longitude");
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['data']['direction']; // Qibla direction in degrees
//     } else {
//       throw Exception("Failed to fetch Qibla direction");
//     }
//   }
// }
