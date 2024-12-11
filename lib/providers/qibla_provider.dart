// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:sensors_plus/sensors_plus.dart';

// class QiblaSensorProvider with ChangeNotifier {
//   double _currentAzimuth = 0.0;
//   double _previousAzimuth = 0.0;
//   double _smoothedAzimuth = 0.0;
//   List<double> _accelerometerValues = [0, 0, 0];
//   List<double> _magnetometerValues = [0, 0, 0];

//   // Smoothing parameters
//   final double _smoothingFactor = 0.2;

//   // Getters
//   double get smoothedAzimuth => _smoothedAzimuth;

//   StreamSubscription? _accelerometerSubscription;
//   StreamSubscription? _magnetometerSubscription;

//   void initializeSensors() {
//     // Cancel existing subscriptions if any
//     _accelerometerSubscription?.cancel();
//     _magnetometerSubscription?.cancel();

//     _accelerometerSubscription = accelerometerEvents.listen((event) {
//       updateAccelerometer([event.x, event.y, event.z]);
//     }, onError: (error) {
//       print('Accelerometer error: $error');
//     });

//     _magnetometerSubscription = magnetometerEvents.listen((event) {
//       updateMagnetometer([event.x, event.y, event.z]);
//     }, onError: (error) {
//       print('Magnetometer error: $error');
//     });
//   }

//   void updateAccelerometer(List<double> values) {
//     _accelerometerValues = values;
//     _calculateSmoothedAzimuth();
//   }

//   void updateMagnetometer(List<double> values) {
//     _magnetometerValues = values;
//     _calculateSmoothedAzimuth();
//   }

//   void _calculateSmoothedAzimuth() {
//     if (_accelerometerValues.isEmpty || _magnetometerValues.isEmpty) return;

//     List<double> rotationMatrix = List.filled(9, 0.0);
//     List<double> orientation = List.filled(3, 0.0);

//     bool success = _getRotationMatrix(
//       rotationMatrix,
//       _accelerometerValues,
//       _magnetometerValues,
//     );

//     if (!success) return;

//     _getOrientation(rotationMatrix, orientation);

//     // Calculate raw azimuth
//     _currentAzimuth = (orientation[0] * (180 / pi) + 360) % 360;

//     // Calculate the smallest rotation
//     double diff = _calculateShortestRotation(_previousAzimuth, _currentAzimuth);

//     // Apply smoothing
//     _smoothedAzimuth += _smoothingFactor * diff;

//     // Ensure _smoothedAzimuth stays within 0-360 range
//     _smoothedAzimuth = (_smoothedAzimuth + 360) % 360;

//     // Update previous azimuth
//     _previousAzimuth = _currentAzimuth;

//     notifyListeners();
//   }

//   double _calculateShortestRotation(double from, double to) {
//     double diff = to - from;

//     // Normalize the difference to handle wrap-around
//     if (diff.abs() > 180) {
//       diff = diff > 0 ? diff - 360 : diff + 360;
//     }

//     return diff;
//   }

//   bool _getRotationMatrix(
//     List<double> rotationMatrix,
//     List<double> accelerometerValues,
//     List<double> magnetometerValues,
//   ) {
//     // Check for valid input data
//     if (accelerometerValues.length != 3 || magnetometerValues.length != 3) {
//       return false;
//     }

//     // Normalize accelerometer and magnetometer vectors
//     final normAccel = _calculateVectorNorm(accelerometerValues);
//     final normMag = _calculateVectorNorm(magnetometerValues);

//     // Prevent division by zero
//     if (normAccel == 0 || normMag == 0) {
//       return false;
//     }

//     // Normalize vectors
//     final normAccelVector = _normalizeVector(accelerometerValues, normAccel);
//     final normMagVector = _normalizeVector(magnetometerValues, normMag);

//     // Compute East vector
//     final east = _crossProduct(normMagVector, normAccelVector);
//     final normEast = _calculateVectorNorm(east);

//     if (normEast == 0) {
//       return false;
//     }

//     final normalizedEast = _normalizeVector(east, normEast);

//     // Compute North vector
//     final north = _crossProduct(normAccelVector, normalizedEast);

//     // Fill rotation matrix
//     rotationMatrix[0] = normalizedEast[0];
//     rotationMatrix[1] = normalizedEast[1];
//     rotationMatrix[2] = normalizedEast[2];
//     rotationMatrix[3] = north[0];
//     rotationMatrix[4] = north[1];
//     rotationMatrix[5] = north[2];
//     rotationMatrix[6] = normAccelVector[0];
//     rotationMatrix[7] = normAccelVector[1];
//     rotationMatrix[8] = normAccelVector[2];

//     return true;
//   }

//   void _getOrientation(List<double> rotationMatrix, List<double> orientation) {
//     // Compute azimuth (rotation around Z axis)
//     orientation[0] = atan2(rotationMatrix[1], rotationMatrix[4]);

//     // Compute pitch (rotation around X axis)
//     orientation[1] = asin(-rotationMatrix[7]);

//     // Compute roll (rotation around Y axis)
//     orientation[2] = atan2(-rotationMatrix[6], rotationMatrix[8]);
//   }

//   // Helper methods for vector operations
//   double _calculateVectorNorm(List<double> vector) {
//     return sqrt(
//         vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
//   }

//   List<double> _normalizeVector(List<double> vector, double norm) {
//     return [vector[0] / norm, vector[1] / norm, vector[2] / norm];
//   }

//   List<double> _crossProduct(List<double> a, List<double> b) {
//     return [
//       a[1] * b[2] - a[2] * b[1],
//       a[2] * b[0] - a[0] * b[2],
//       a[0] * b[1] - a[1] * b[0]
//     ];
//   }

//   void dispose() {
//     _accelerometerSubscription?.cancel();
//     _magnetometerSubscription?.cancel();
//   }
// }
