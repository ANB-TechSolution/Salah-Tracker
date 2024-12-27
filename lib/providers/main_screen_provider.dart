import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MainScreenProvider with ChangeNotifier {
  String _location = "Loading location...";
  late Position _position;

  String get location => _location;
  Position get position => _position;

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
      _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
      Placemark place = placemarks[0];

      _location = "${place.locality}, ${place.country}";
    } catch (e) {
      _location = "Could not fetch location.";
    }
    notifyListeners();
  }
}
