import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../providers/prayer_provider.dart';
import '../providers/setting_provider.dart';
import '../widgets/JuristicMethodSection.dart';

// Updated SettingsScreen
class SettingsScreen extends StatefulWidget {
  final String location;
  final double long;
  final double lat;

  const SettingsScreen(
      {super.key,
      required this.location,
      required this.long,
      required this.lat});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SettingsProvider>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        if (!settings.isInitialized) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            backgroundColor: Colors.teal,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Theme Toggle

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
                          Text(
                            "Country: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Text("${widget.location.split(",")[1]}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "City: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Text("${widget.location.split(",")[0]}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Location: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Text(
                              "${widget.lat.toStringAsFixed(6)}, ${widget.long.toStringAsFixed(6)}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Location Settings

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

              // Counter Sound
              // SoundSection(
              //   isEnabled: settings.counterSound,
              //   onChanged: settings.setCounterSound,
              // ),
              // const SizedBox(height: 20),

              // // Alarm Settings
              // AlarmSection(
              //   alarmSettings: settings.alarmSettings,
              //   onAlarmChanged: settings.setAlarm,
              // ),
            ],
          ),
        );
      },
    );
  }
}
