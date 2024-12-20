import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/main_screen_provider.dart';
import '../providers/setting_provider.dart';
import '../widgets/JuristicMethodSection.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainScreenProvider =
        Provider.of<MainScreenProvider>(context, listen: false);

    return FutureBuilder<void>(
      future: Provider.of<SettingsProvider>(context, listen: false).init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                backgroundColor: Colors.teal,
              ),
              body: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Location Details
                  Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Location Details:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                "Country: ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                  "${mainScreenProvider.location.split(",")[1]}"),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "City: ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                  "${mainScreenProvider.location.split(",")[0]}"),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Location: ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                  "${mainScreenProvider.position.latitude.toStringAsFixed(6)}, ${mainScreenProvider.position.longitude.toStringAsFixed(6)}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Prayer Calculation Method
                  CalculationMethodSection(
                    currentMethod: settings.calculationMethod,
                    onMethodChanged: settings.setCalculationMethod,
                  ),
                  const SizedBox(height: 20),

                  // Juristic Method
                  JuristicMethodSection(
                    currentMethod: settings.juristicMethod,
                    onMethodChanged: settings.setJuristicMethod,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
