import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MainScreenProvider with ChangeNotifier {
  String _location = "Loading location...";
  late Position _position;

  String get location => _location;
  Position get position => _position;

  final List<Map<String, dynamic>> _cardsData = [
    {'name': 'Prayer Timing', 'icon': Icons.timelapse},
    {'name': 'Learn Quran', 'icon': Icons.book},
    {'name': '6 Kalma', 'icon': Icons.brightness_6},
    {'name': 'Azkar', 'icon': Icons.nightlight_round},
    {'name': 'Allah 99 Names', 'icon': Icons.star},
    {'name': 'Tasbeeh Counter', 'icon': Icons.speed},
    {'name': 'Qibla Finder', 'icon': Icons.compare_arrows_sharp},
    {'name': 'Settings', 'icon': Icons.settings},
  ];

  List<Map<String, dynamic>> get cardsData => _cardsData;

  MainScreenProvider() {
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _location = "Location services are disabled.";
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _location = "Location permission denied.";
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _location = "Location permissions are permanently denied.";
      notifyListeners();
      return;
    }

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
