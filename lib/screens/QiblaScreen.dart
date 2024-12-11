import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

// Qibla Service
class QiblaService {
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

// Qibla Screen
class QiblaScreen extends StatefulWidget {
  const QiblaScreen({Key? key}) : super(key: key);

  @override
  _QiblaScreenState createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _qiblaDirection; // Qibla direction in degrees
  double _currentAzimuth = 0.0; // Device's azimuth (rotation angle)
  List<double> _accelerometerValues = [0, 0, 0];
  List<double> _magnetometerValues = [0, 0, 0];
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _magnetometerSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeSensors();
    _fetchQiblaDirection();
  }

  void _initializeSensors() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      setState(() {
        _accelerometerValues = [event.x, event.y, event.z];
        _calculateAzimuth();
      });
    });

    _magnetometerSubscription = magnetometerEvents.listen((event) {
      setState(() {
        _magnetometerValues = [event.x, event.y, event.z];
        _calculateAzimuth();
      });
    });
  }

  Future<void> _fetchQiblaDirection() async {
    final service = QiblaService();
    try {
      final direction = await service.getQiblaDirection(
          40.7128, -74.0060); // Replace with actual location
      setState(() {
        _qiblaDirection = direction;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _qiblaDirection = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching Qibla direction: $e")),
      );
    }
  }

  void _calculateAzimuth() {
    if (_accelerometerValues.isEmpty || _magnetometerValues.isEmpty) return;

    // Create rotation matrix
    List<double> rotationMatrix = List.filled(9, 0.0);
    List<double> orientation = List.filled(3, 0.0);

    SensorMath.getRotationMatrix(
      rotationMatrix,
      _accelerometerValues,
      _magnetometerValues,
    );

    SensorMath.getOrientation(rotationMatrix, orientation);

    // Update azimuth (in degrees)
    setState(() {
      _currentAzimuth = (orientation[0] * (180 / pi) + 360) % 360;
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _magnetometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Finder'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _qiblaDirection == null
                ? const Text('Unable to determine Qibla direction')
                : _buildQiblaView(),
      ),
    );
  }

  Widget _buildQiblaView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Compass dial
        Transform.rotate(
          angle:
              -_currentAzimuth * (pi / 180), // Rotate compass based on azimuth
          child: const Image(
            image: AssetImage("assets/images/dial.png"),
            fit: BoxFit.contain,
          ),
        ),
        // Qibla arrow
        Transform.rotate(
          angle: ((_qiblaDirection! - _currentAzimuth + 200) * (pi / 180)),
          child: Image(
            image: const AssetImage("assets/images/qibla_arrow.png"),
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.4,
          ),
        ),
      ],
    );
  }
}

class SensorMath {
  /// Computes the rotation matrix using accelerometer and magnetometer values.
  static bool getRotationMatrix(
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
    if (normH < 0.1) return false; // Device is close to free fall

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

  /// Computes the orientation (azimuth, pitch, roll) from the rotation matrix.
  static void getOrientation(List<double> R, List<double> values) {
    values[0] = atan2(R[1], R[4]); // Azimuth
    values[1] = asin(-R[7]); // Pitch
    values[2] = atan2(-R[6], R[8]); // Roll
  }
}
