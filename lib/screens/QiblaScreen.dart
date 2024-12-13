import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../providers/qibla_provider.dart';

// Qibla Screen with Provider
class QiblaScreen extends StatelessWidget {
  const QiblaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<QiblaServiceProvider>(
          create: (_) => QiblaServiceProvider(),
        ),
        ChangeNotifierProxyProvider<QiblaServiceProvider, QiblaScreenProvider>(
          create: (context) => QiblaScreenProvider(
            Provider.of<QiblaServiceProvider>(context, listen: false),
          ),
          update: (context, service, previous) =>
              previous ?? QiblaScreenProvider(service),
        ),
      ],
      child: const QiblaScreenView(),
    );
  }
}

class QiblaScreenView extends StatelessWidget {
  const QiblaScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QiblaScreenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Finder'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: provider.isLoading
            ? const CircularProgressIndicator()
            : provider.qiblaDirection == null
                ? const Text('Unable to determine Qibla direction')
                : _buildQiblaView(context, provider),
      ),
    );
  }

  Widget _buildQiblaView(BuildContext context, QiblaScreenProvider provider) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Compass dial
        Transform.rotate(
          angle: -provider.currentAzimuth * (pi / 180),
          child: const Image(
            image: AssetImage("assets/images/dial.png"),
            fit: BoxFit.contain,
          ),
        ),
        // Qibla arrow
        Transform.rotate(
          angle: (((provider.qiblaDirection ?? 0) -
                  provider.currentAzimuth +
                  195) *
              (pi / 180)),
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
