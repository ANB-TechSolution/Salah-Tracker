import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_provider.dart';
import '../services/prayer_service.dart';

class PrayerTimingScreen extends StatelessWidget {
  final String? location;

  PrayerTimingScreen({this.location});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrayerTimingsProvider(PrayerService(), location: location),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Prayer Times'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.refresh),
          //     onPressed: () {
          //       context.read<PrayerTimingsProvider>().refresh();
          //     },
          //   ),
          // ],
        ),
        body: Consumer<PrayerTimingsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.prayerData == null) {
              return Center(child: CircularProgressIndicator());
            }

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
                                provider.location,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                provider.gregorianDate,
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
                                      'Next Prayer: ${provider.currentPrayer}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      provider.remainingTime,
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
                      final prayers = [
                        'Fajr',
                        'Dhuhr',
                        'Asr',
                        'Maghrib',
                        'Isha'
                      ];
                      final prayer = prayers[index];
                      final time = provider.convertTo12HourFormat(
                        provider.timings[prayer],
                      );
                      final isCurrentPrayer = provider.isCurrentPrayer(prayer);

                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.only(bottom: 12),
                        color: isCurrentPrayer
                            ? Colors.teal.shade50
                            : Colors.white,
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
                              color: isCurrentPrayer
                                  ? Colors.teal
                                  : Colors.black87,
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
      ),
    );
  }
}
