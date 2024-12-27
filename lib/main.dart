import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salahtracker/screens/AllahNamesScreen.dart';
import 'package:salahtracker/screens/AzkarCategoryScreen.dart';
import 'package:salahtracker/screens/PrayerTiming.dart';
import 'package:salahtracker/screens/QiblaScreen.dart';
import 'package:salahtracker/screens/QuranScreen.dart';
import 'package:salahtracker/screens/SettingsScreen.dart';
import 'package:salahtracker/screens/SixKalmaScreen.dart';
import 'package:salahtracker/screens/TasbeehCounterScreen.dart';
import 'package:salahtracker/screens/onBoardingScreen.dart';
import 'package:salahtracker/services/notifi_service.dart';
import 'providers/main_screen_provider.dart';
import 'providers/on_boarding_provider.dart';
import 'providers/quran_screen_provider.dart';
import 'providers/setting_provider.dart';
import 'screens/background_slider.dart';
import 'utils/theme/theme.dart';
//

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MainScreenProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OnboardingProvider>(context, listen: false).init();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const OnboardingScreen(),
    );
  }
}

class SalahTrackerScreen extends StatelessWidget {
  final String currentDate = DateFormat('EEEE, dd MMMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final mainScreenProvider = Provider.of<MainScreenProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: Stack(
          children: [
            // Background Slider
            SizedBox(
              height: 300,
              child: BackgroundSlider(),
            ),
            // AppBar Content
            AppBar(
              foregroundColor: Colors.white,
              backgroundColor:
                  Colors.black.withOpacity(0.3), // Semi-transparent overlay
              flexibleSpace: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Text(
                      'Salah Tracker',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentDate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        mainScreenProvider.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return SettingsScreen();
                  },
                ));
              },
            ),
          ],
        ),
      ),
      body: mainScreenProvider.location == "Loading location..."
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: mainScreenProvider.cardsData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        switch (mainScreenProvider.cardsData[index]['name']) {
                          case 'Settings':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingsScreen()),
                            );
                            break;

                          case 'Learn Quran':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuranScreen()),
                            );
                            break;
                          case 'Prayer Timing':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrayerTimingScreen(
                                      location: mainScreenProvider.location)),
                            );
                            break;
                          case '6 Kalma':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SixKalmaScreen()),
                            );
                            break;
                          case 'Azkar':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AzkarCategoryScreen()),
                            );
                            break;
                          case 'Allah 99 Names':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllahNamesScreen()),
                            );
                            break;
                          case 'Tasbeeh Counter':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TasbeehCounterScreen()),
                            );
                            break;
                          case 'Qibla Finder':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QiblaScreen(
                                        rotationOffset: 90,
                                        location: mainScreenProvider.location,
                                        lat: mainScreenProvider.latitude,
                                        long: mainScreenProvider.longitude,
                                      )),
                            );
                            break;
                          default:
                            break;
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            mainScreenProvider.cardsData[index]['image'],
                            height: 90,
                            width: 90,
                            color: Colors
                                .teal, // Optional: remove if you want original image colors
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mainScreenProvider.cardsData[index]['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
