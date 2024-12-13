import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

// Qibla Service Provider
class QiblaServiceProvider {
  static const String _baseUrl = "http://api.aladhan.com/v1/qibla";

  Future<double> getQiblaDirection(double latitude, double longitude) async {
    final url = Uri.parse("$_baseUrl/$latitude/$longitude");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']['direction']; // Qibla direction in degrees
    } else {
      throw Exception("Failed to fetch Qibla direction");
    }
  }
}

// Qibla Screen State Provider
class QiblaScreenProvider extends ChangeNotifier {
  double? _qiblaDirection;
  double _currentAzimuth = 0.0;
  List<double> _accelerometerValues = [0, 0, 0];
  List<double> _magnetometerValues = [0, 0, 0];
  bool _isLoading = true;
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _magnetometerSubscription;

  // Getters
  double? get qiblaDirection => _qiblaDirection;
  double get currentAzimuth => _currentAzimuth;
  bool get isLoading => _isLoading;

  QiblaScreenProvider(QiblaServiceProvider service) {
    _initializeSensors();
    fetchQiblaDirection(service);
  }

  void _initializeSensors() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      _accelerometerValues = [event.x, event.y, event.z];
      _calculateAzimuth();
    });

    _magnetometerSubscription = magnetometerEvents.listen((event) {
      _magnetometerValues = [event.x, event.y, event.z];
      _calculateAzimuth();
    });
  }

  Future<void> fetchQiblaDirection(QiblaServiceProvider service) async {
    try {
      // Replace with actual location or use geolocation
      final direction = await service.getQiblaDirection(40.7128, -74.0060);
      _qiblaDirection = direction;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _qiblaDirection = null;
      notifyListeners();
    }
  }

  void _calculateAzimuth() {
    if (_accelerometerValues.isEmpty || _magnetometerValues.isEmpty) return;

    List<double> rotationMatrix = List.filled(9, 0.0);
    List<double> orientation = List.filled(3, 0.0);

    QiblaScreenProvider._getRotationMatrix(
      rotationMatrix,
      _accelerometerValues,
      _magnetometerValues,
    );

    QiblaScreenProvider._getOrientation(rotationMatrix, orientation);

    _currentAzimuth = (orientation[0] * (180 / pi) + 360) % 360;
    notifyListeners();
  }

  // Static methods for rotation calculations
  static bool _getRotationMatrix(
    List<double> R,
    List<double> gravity,
    List<double> geomagnetic,
  ) {
    double Ax = gravity[0], Ay = gravity[1], Az = gravity[2];
    double Ex = geomagnetic[0], Ey = geomagnetic[1], Ez = geomagnetic[2];

    double Hx = Ey * Az - Ez * Ay;
    double Hy = Ez * Ax - Ex * Az;
    double Hz = Ex * Ay - Ey * Ax;

    double normH = sqrt(Hx * Hx + Hy * Hy + Hz * Hz);
    if (normH < 0.1) return false;

    Hx /= normH;
    Hy /= normH;
    Hz /= normH;

    double invA = 1.0 / sqrt(Ax * Ax + Ay * Ay + Az * Az);
    Ax *= invA;
    Ay *= invA;
    Az *= invA;

    double Mx = Ay * Hz - Az * Hy;
    double My = Az * Hx - Ax * Hz;
    double Mz = Ax * Hy - Ay * Hx;

    R[0] = Hx;
    R[1] = Hy;
    R[2] = Hz;
    R[3] = Mx;
    R[4] = My;
    R[5] = Mz;
    R[6] = Ax;
    R[7] = Ay;
    R[8] = Az;

    return true;
  }

  static void _getOrientation(List<double> R, List<double> values) {
    values[0] = atan2(R[1], R[4]); // Azimuth
    values[1] = asin(-R[7]); // Pitch
    values[2] = atan2(-R[6], R[8]); // Roll
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _magnetometerSubscription?.cancel();
    super.dispose();
  }
}
