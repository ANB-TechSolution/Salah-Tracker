import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../utils/constants/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _locationPermissionGranted = false;
  bool _locationServicesEnabled = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
    _startLocationCheckTimer();
  }

  Future<void> _checkLocationStatus() async {
    // Check if location permission is granted
    final permissionStatus = await Permission.location.status;
    final locationPermissionGranted = permissionStatus.isGranted;

    // Check if location services are enabled
    final locationServicesEnabled = await Geolocator.isLocationServiceEnabled();

    if (mounted) {
      setState(() {
        _locationPermissionGranted = locationPermissionGranted;
        _locationServicesEnabled = locationServicesEnabled;
      });
    }

    // Navigate to the next screen if both conditions are met
    if (_locationPermissionGranted && _locationServicesEnabled) {
      _navigateToNextScreen();
    }
  }

  void _startLocationCheckTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkLocationStatus();
    });
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (mounted) {
      setState(() {
        _locationPermissionGranted = status.isGranted;
      });
    }
  }

  Future<void> _requestLocationServices() async {
    if (!_locationServicesEnabled) {
      await Geolocator.openLocationSettings();
      final locationServicesEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (mounted) {
        setState(() {
          _locationServicesEnabled = locationServicesEnabled;
        });
      }
    }
  }

  void _navigateToNextScreen() {
    _timer?.cancel(); // Stop the timer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SalahTrackerScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.colorPrimaryDark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 200),
            Image.asset(
              "assets/images/drawer.png",
              width: double.maxFinite,
            ),
            const Text(
              'Prayer Tracker',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 227, 119, 25),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (!_locationPermissionGranted) {
                        await _requestLocationPermission();
                      }
                      if (!_locationServicesEnabled) {
                        await _requestLocationServices();
                      }
                    },
                    child: const Text(
                      'Enable Location',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!_locationPermissionGranted || !_locationServicesEnabled)
                    const SizedBox(height: 10),
                  if (!_locationPermissionGranted)
                    Text(
                      'Location permission needed for accurate prayer times.',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (!_locationServicesEnabled)
                    Text(
                      'Please enable location services.',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);

    if (mounted) {
      setState(() {
        _themeMode = themeMode;
      });
    }
  }
}
