import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingProvider extends ChangeNotifier {
  bool _locationPermissionGranted = false;
  bool _locationServicesEnabled = false;
  Timer? _timer;

  bool get locationPermissionGranted => _locationPermissionGranted;
  bool get locationServicesEnabled => _locationServicesEnabled;

  Future<void> init() async {
    await _checkLocationStatus();
    await _checkNotificationPermission(); // Add this
    _startLocationCheckTimer();
  }

  Future<void> _checkLocationStatus() async {
    // Check if location permission is granted
    final permissionStatus = await Permission.location.status;
    _locationPermissionGranted = permissionStatus.isGranted;

    // Check if location services are enabled
    _locationServicesEnabled = await Geolocator.isLocationServiceEnabled();

    notifyListeners();

    // Automatically stop timer if conditions are met
    if (_locationPermissionGranted && _locationServicesEnabled) {
      _stopTimer();
    }
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  void _startLocationCheckTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkLocationStatus();
    });
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    _locationPermissionGranted = status.isGranted;
    notifyListeners();
  }

  Future<void> requestLocationServices() async {
    if (!_locationServicesEnabled) {
      await Geolocator.openLocationSettings();
      _locationServicesEnabled = await Geolocator.isLocationServiceEnabled();
      notifyListeners();
    }
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
