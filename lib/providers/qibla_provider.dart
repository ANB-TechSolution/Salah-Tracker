import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;
import 'dart:async';
import '../services/qibla_service.dart';

class QiblaScreenProvider extends ChangeNotifier {
  final QiblaService _qiblaService = QiblaService();

  double _qiblaDirection = 0.0;
  double _deviceHeading = 0.0;
  double _smoothedHeading = 0.0;
  bool _isLoading = true;
  String _errorMessage = '';

  // Getters
  double get qiblaDirection => _qiblaDirection;
  double get deviceHeading => _smoothedHeading;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  late StreamSubscription _magnetometerSubscription;
  Timer? _smoothingTimer;

  // Low-pass filter alpha value (0 to 1)
  // Lower values mean smoother but slower updates
  final double _alpha = 0.3;

  QiblaScreenProvider() {
    _init();
  }

  void _init() {
    _fetchQiblaDirection();
    _startMagnetometerListening();
    _startSmoothingTimer();
  }

  void _startSmoothingTimer() {
    // Update smoothed heading 60 times per second
    _smoothingTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      // Apply low-pass filter
      _smoothedHeading =
          _smoothedHeading + _alpha * (_deviceHeading - _smoothedHeading);
      notifyListeners();
    });
  }

  void _startMagnetometerListening() {
    _magnetometerSubscription =
        magnetometerEvents.listen((MagnetometerEvent event) {
      // Calculate heading from magnetometer data
      double heading = math.atan2(event.y, event.x);

      // Convert radians to degrees and normalize
      heading = (heading * 180 / math.pi + 360) % 360;

      _deviceHeading = heading;
      // We don't call notifyListeners() here as the smoothing timer handles updates
    });
  }

  Future<void> _fetchQiblaDirection() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _errorMessage = 'Location permissions are required';
        _isLoading = false;
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final direction = await _qiblaService.getQiblaDirection(
        position.latitude,
        position.longitude,
      );

      _qiblaDirection = direction;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error fetching Qibla direction';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to recalibrate or refresh Qibla direction
  Future<void> recalibrate() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    await _fetchQiblaDirection();
  }

  @override
  void dispose() {
    _magnetometerSubscription.cancel();
    _smoothingTimer?.cancel();
    super.dispose();
  }
}
