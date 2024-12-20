import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/on_boarding_provider.dart';
import '../utils/constants/colors.dart';
import '../main.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.colorPrimaryDark,
      body: Consumer<OnboardingProvider>(
        builder: (context, onboardingProvider, child) {
          if (onboardingProvider.locationPermissionGranted &&
              onboardingProvider.locationServicesEnabled) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SalahTrackerScreen()),
              );
            });
          }

          return SingleChildScrollView(
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
                          backgroundColor:
                              const Color.fromARGB(255, 227, 119, 25),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          if (!onboardingProvider.locationPermissionGranted) {
                            await onboardingProvider
                                .requestLocationPermission();
                          }
                          if (!onboardingProvider.locationServicesEnabled) {
                            await onboardingProvider.requestLocationServices();
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
                      if (!onboardingProvider.locationPermissionGranted ||
                          !onboardingProvider.locationServicesEnabled)
                        const SizedBox(height: 10),
                      if (!onboardingProvider.locationPermissionGranted)
                        Text(
                          'Location permission needed for accurate prayer times.',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      if (!onboardingProvider.locationServicesEnabled)
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
          );
        },
      ),
    );
  }
}
