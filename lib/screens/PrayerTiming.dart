import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/prayer_service.dart';

class PrayerTimingScreen extends StatefulWidget {
  final String location;

  PrayerTimingScreen({required this.location});

  @override
  _PrayerTimingScreenState createState() => _PrayerTimingScreenState();
}

class _PrayerTimingScreenState extends State<PrayerTimingScreen> {
  late Future<Map<String, String>> _prayerTimes;

  @override
  void initState() {
    super.initState();
    _prayerTimes =
        PrayerService().getPrayerTimes(widget.location); // Fetch prayer times
  }

  String _convertTo12HourFormat(String time) {
    try {
      final DateFormat inputFormat = DateFormat("HH:mm");
      final DateFormat outputFormat = DateFormat("h:mm a");
      final DateTime dateTime = inputFormat.parse(time);
      return outputFormat.format(dateTime);
    } catch (e) {
      return time; // If there's an error, return the original time
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current date (Gregorian)
    final String gregorianDate =
        DateFormat('dd MMMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Times'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _prayerTimes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No prayer times available'));
          }

          final prayerTimes = snapshot.data!;

          // Filter prayer times (Fajr to Isha)
          final List<String> prayerNames = [
            'Fajr',
            'Dhuhr',
            'Asr',
            'Maghrib',
            'Isha'
          ];

          final Map<String, String> filteredPrayerTimes = {};
          for (var prayer in prayerNames) {
            if (prayerTimes.containsKey(prayer)) {
              filteredPrayerTimes[prayer] =
                  _convertTo12HourFormat(prayerTimes[prayer]!);
            }
          }

          return Column(
            children: [
              // Location and mosque image with city name and Gregorian date overlay
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height *
                    0.3, // 30% height of screen
                child: Stack(
                  children: [
                    // Mosque image
                    Positioned.fill(
                      child: Image.network(
                        'https://t4.ftcdn.net/jpg/02/63/48/39/360_F_263483946_oUd7VNlXB7fbDhhmVkur6ytxBgsBTaH7.jpg',
                        fit: BoxFit
                            .fill, // Stretch the image to fit the width of the screen
                      ),
                    ),
                    // Overlay text (city name and Gregorian date)
                    Positioned(
                      top: 20, // Position at the top of the image
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              widget.location,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 14, 14, 14),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '$gregorianDate',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(179, 8, 8, 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Prayer times cards in horizontal ListView
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: filteredPrayerTimes.length,
                    itemBuilder: (context, index) {
                      String prayerName =
                          filteredPrayerTimes.keys.elementAt(index);
                      String prayerTime = filteredPrayerTimes[prayerName] ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Prayer name on the left
                                Text(
                                  prayerName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Prayer time on the right
                                Text(
                                  prayerTime,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
