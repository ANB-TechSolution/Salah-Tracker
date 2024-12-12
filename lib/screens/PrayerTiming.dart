import 'dart:async';

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
  late Future<Map<String, dynamic>> _prayerData;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _prayerData = PrayerService().getPrayerTimes(widget.location);
    // Update remaining time every minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _prayerData = PrayerService().getPrayerTimes(widget.location);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String gregorianDate =
        DateFormat('dd MMMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Times'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _prayerData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No prayer times available'));
          }

          final data = snapshot.data!;
          final prayerTimes = data['timings'] as Map<String, dynamic>;
          final currentPrayer = data['currentPrayer'] as String;
          final remainingTime = data['remainingTime'] as String;

          return Column(
            children: [
              // Location and mosque image section
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        'https://t4.ftcdn.net/jpg/02/63/48/39/360_F_263483946_oUd7VNlXB7fbDhhmVkur6ytxBgsBTaH7.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.location,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              gregorianDate,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Next Prayer: $currentPrayer',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    remainingTime,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Prayer times list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
                    final prayer = prayers[index];
                    final time = _convertTo12HourFormat(prayerTimes[prayer]);
                    final isCurrentPrayer = prayer == currentPrayer;

                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.only(bottom: 12),
                      color:
                          isCurrentPrayer ? Colors.teal.shade50 : Colors.white,
                      child: ListTile(
                        leading: Icon(
                          Icons.access_time,
                          color: isCurrentPrayer ? Colors.teal : Colors.grey,
                        ),
                        title: Text(
                          prayer,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: isCurrentPrayer
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: Text(
                          time,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isCurrentPrayer ? Colors.teal : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _convertTo12HourFormat(String time) {
    try {
      final DateFormat inputFormat = DateFormat("HH:mm");
      final DateFormat outputFormat = DateFormat("h:mm a");
      final DateTime dateTime = inputFormat.parse(time);
      return outputFormat.format(dateTime);
    } catch (e) {
      return time;
    }
  }
}
