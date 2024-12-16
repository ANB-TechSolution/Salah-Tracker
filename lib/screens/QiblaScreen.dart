import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;
import 'dart:async';

import '../services/qibla_service.dart';

class QiblaScreen extends StatefulWidget {
  // Optional custom rotation offset
  final double rotationOffset;

  const QiblaScreen({
    Key? key,
    this.rotationOffset = 0.0, // Default to 0 degrees
  }) : super(key: key);

  @override
  _QiblaScreenState createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final QiblaService _qiblaService = QiblaService();
  double _qiblaDirection = 0.0;
  double _deviceHeading = 0.0;
  bool _isLoading = true;
  String _errorMessage = '';

  late StreamSubscription _magnetometerSubscription;

  @override
  void initState() {
    super.initState();
    _fetchQiblaDirection();
    _startMagnetometerListening();
  }

  void _startMagnetometerListening() {
    _magnetometerSubscription =
        magnetometerEvents.listen((MagnetometerEvent event) {
      // Calculate heading from magnetometer data
      double heading = math.atan2(event.y, event.x);

      // Convert radians to degrees and normalize
      heading = (heading * 180 / math.pi + 360) % 360;

      setState(() {
        _deviceHeading = heading;
      });
    });
  }

  Future<void> _fetchQiblaDirection() async {
    try {
      // Request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          _errorMessage = 'Location permissions are required';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch Qibla direction
      final direction = await _qiblaService.getQiblaDirection(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _qiblaDirection = direction;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching Qibla direction';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _magnetometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Direction'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage.isNotEmpty
                ? Text(_errorMessage)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Rotating Compass Background with Custom Rotation
                          Transform.rotate(
                            angle: (-_deviceHeading + widget.rotationOffset) *
                                (math.pi / 180),
                            child: Image.asset(
                              'assets/images/dial.png',
                              width: 300,
                              height: 300,
                            ),
                          ),
                          // Fixed Qibla Arrow
                          Transform.rotate(
                            angle: (_qiblaDirection -
                                    _deviceHeading +
                                    widget.rotationOffset) *
                                (math.pi / 180),
                            child: Image.asset(
                              'assets/images/arrow.png',
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Qibla Direction: ${_qiblaDirection.toStringAsFixed(2)}°',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Device Heading: ${_deviceHeading.toStringAsFixed(2)}°',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Rotation Offset: ${widget.rotationOffset.toStringAsFixed(2)}°',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
      ),
    );
  }
}
