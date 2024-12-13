import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salahtracker/screens/AllahNamesScreen.dart';
import 'package:salahtracker/screens/AzkarCategoryScreen.dart';
import 'package:salahtracker/screens/PrayerTiming.dart';
import 'package:salahtracker/screens/QiblaScreen.dart';
import 'package:salahtracker/screens/QuranScreen.dart';
import 'package:salahtracker/screens/SettingsScreen.dart';
import 'package:salahtracker/screens/SixKalmaScreen.dart';
import 'package:salahtracker/screens/TasbeehCounterScreen.dart';
import 'package:salahtracker/screens/onBoardingScreen.dart';
import 'package:salahtracker/utils/constants/colors.dart';
import 'providers/setting_provider.dart';
import 'utils/theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),

        // Add other providers here if needed
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
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        int themeModeIndex = prefs.getInt('themeMode') ?? 0;
        _themeMode = ThemeMode.values[themeModeIndex];
      });
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  Future<void> _toggleTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('themeMode', themeMode.index);

      setState(() {
        _themeMode = themeMode;
      });
    } catch (e) {
      debugPrint('Error toggling theme: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: OnboardingScreen(),
    );
  }
}

class SalahTrackerScreen extends StatefulWidget {
  @override
  _SalahTrackerScreenState createState() => _SalahTrackerScreenState();
}

class _SalahTrackerScreenState extends State<SalahTrackerScreen> {
  final String currentDate = DateFormat('EEEE, dd MMMM').format(DateTime.now());
  String location = "Loading location...";
  late Position position;

  final List<Map<String, dynamic>> cardsData = [
    {'name': 'Prayer Timing', 'icon': Icons.timelapse},
    {'name': 'Learn Quran', 'icon': Icons.book},
    {'name': '6 Kalma', 'icon': Icons.brightness_6},
    {'name': 'Azkar', 'icon': Icons.nightlight_round},
    {'name': 'Allah 99 Names', 'icon': Icons.star},
    {'name': 'Tasbeeh Counter', 'icon': Icons.speed},
    {'name': 'Qibla Finder', 'icon': Icons.compare_arrows_sharp},
    {'name': 'Settings', 'icon': Icons.settings},
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        location = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          location = "Location permission denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        location = "Location permissions are permanently denied.";
      });
      return;
    }

    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      setState(() {
        location = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        location = "Could not fetch location.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal,
          flexibleSpace: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Salah Tracker',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
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
                    ),
                  ),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
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
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: cardsData.length,
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
                  switch (cardsData[index]['name']) {
                    case 'Settings':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                                  location: location,
                                  lat: position.latitude,
                                  long: position.longitude,
                                )),
                      );
                      break;
                    case 'Learn Quran':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuranScreen()),
                      );
                      break;
                    case 'Prayer Timing':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PrayerTimingScreen(location: location)),
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
                        MaterialPageRoute(builder: (context) => QiblaScreen()),
                      );
                      break;
                    default:
                      break;
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cardsData[index]['icon'],
                      size: 40,
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cardsData[index]['name'],
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
