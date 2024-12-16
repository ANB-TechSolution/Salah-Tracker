import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../providers/qibla_provider.dart';

class QiblaScreen extends StatelessWidget {
  final double rotationOffset;

  const QiblaScreen({
    Key? key,
    this.rotationOffset = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QiblaScreenProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Qibla Direction'),
        ),
        body: Consumer<QiblaScreenProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage.isNotEmpty) {
              return Center(child: Text(provider.errorMessage));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedRotation(
                        turns: (-provider.deviceHeading + rotationOffset) / 360,
                        duration: const Duration(milliseconds: 16),
                        child: Image.asset(
                          'assets/images/dial.png',
                          width: double.maxFinite,
                        ),
                      ),
                      AnimatedRotation(
                        turns: (provider.qiblaDirection -
                                provider.deviceHeading +
                                rotationOffset) /
                            360,
                        duration: const Duration(milliseconds: 16),
                        child: Image.asset(
                          'assets/images/qibla_arrow.png',
                          width: 300,
                          height: 300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
