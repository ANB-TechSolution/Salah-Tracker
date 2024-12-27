import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreenProvider with ChangeNotifier {
  String _location = "Loading location...";
  LocationData? _locationData;
  final Location _locationService = Location();

  // Add getters for latitude and longitude
  double get latitude => _locationData?.latitude ?? 0.0;
  double get longitude => _locationData?.longitude ?? 0.0;

  String get location => _location;
  LocationData? get locationData => _locationData;

  final List<Map<String, dynamic>> _cardsData = [
    {'name': 'Prayer Timing', 'image': 'assets/icons/timings.png'},
    {'name': 'Learn Quran', 'image': 'assets/icons/quran.png'},
    {'name': '6 Kalma', 'image': 'assets/icons/prayer.png'},
    {'name': 'Azkar', 'image': 'assets/icons/dua.png'},
    {'name': 'Allah 99 Names', 'image': 'assets/icons/allahnames.png'},
    {'name': 'Tasbeeh Counter', 'image': 'assets/icons/counter.png'},
    {'name': 'Qibla Finder', 'image': 'assets/icons/compass.png'},
    {'name': 'Settings', 'image': 'assets/icons/settings.png'},
    {'name': 'Notification', 'image': 'assets/icons/settings.png'}
  ];

  List<Map<String, dynamic>> get cardsData => _cardsData;

  MainScreenProvider() {
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      // Configure location service
      await _locationService.changeSettings(
        accuracy: LocationAccuracy.balanced, // Lower accuracy for better speed
        interval: 10000, // Update interval in milliseconds
      );

      // Get location
      _locationData = await _locationService.getLocation();

      // Get address using reverse geocoding
      await _getAddressFromLatLng();

      // Optional: Listen to location changes
      _locationService.onLocationChanged.listen((LocationData currentLocation) {
        _locationData = currentLocation;
        _getAddressFromLatLng();
        notifyListeners(); // Notify listeners when location changes
      });
    } catch (e) {
      _location = "Could not fetch location.";
      notifyListeners();
    }
  }

  Future<void> _getAddressFromLatLng() async {
    if (_locationData == null) return;

    try {
      // Using Open Street Map (Free, no API key needed)
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${_locationData!.latitude}&lon=${_locationData!.longitude}&zoom=18&addressdetails=1'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];
        _location =
            "${address['city'] ?? address['town'] ?? address['village']}, ${address['country']}";
        notifyListeners();
      }
    } catch (e) {
      _location = "Could not fetch address.";
      notifyListeners();
    }
  }
}
