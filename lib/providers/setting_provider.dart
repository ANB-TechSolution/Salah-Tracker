// settings_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String THEME_KEY = 'theme_mode';
  static const String LOCATION_KEY = 'location';
  static const String METHOD_KEY = 'calculation_method';
  static const String SCHOOL_KEY = 'juristic_method';
  static const String TIMEZONE_KEY = 'timezone';
  static const String LATITUDE_KEY = 'latitude';
  static const String LONGITUDE_KEY = 'longitude';
  static const String SOUND_KEY = 'counter_sound';
  static const String ADHAN_SOUND_KEY = 'adhan_sound';
  static const String ALARM_PREFIX = 'alarm_';

  late SharedPreferences _prefs;
  bool _initialized = false;

  // Prayer Calculation Methods
  static const Map<String, String> calculationMethods = {
    '0': 'Shia Ithna-Ansari',
    '1': 'University of Islamic Sciences, Karachi',
    '2': 'Islamic Society of North America',
    '3': 'Muslim World League',
    '4': 'Umm Al-Qura University, Makkah',
    '5': 'Egyptian General Authority of Survey',
    '7': 'Institute of Geophysics, University of Tehran',
    '8': 'Gulf Region',
    '9': 'Kuwait',
    '10': 'Qatar',
    '11': 'Majlis Ugama Islam Singapura, Singapore',
    '12': 'Union Organization Islamic de France',
    '13': 'Diyanet İşleri Başkanlığı, Turkey',
    '14': 'Spiritual Administration of Muslims of Russia',
    '15': 'Moonsighting Committee Worldwide',
    '99': 'Custom Settings'
  };

  // Juristic Methods (Asr calculation)
  static const Map<String, String> juristicMethods = {
    '0': 'Shafi\'i, Maliki, Ja\'fari, Hanbali',
    '1': 'Hanafi'
  };

  // Default values
  ThemeMode _themeMode = ThemeMode.system;
  String _location = '';
  String _calculationMethod = '3'; // Default to Muslim World League
  String _juristicMethod = '0'; // Default to Standard
  String _timezone = '';
  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _counterSound = true;
  String _adhanSound = 'default'; // Default Adhan sound
  Map<String, bool> _alarmSettings = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  // Getters
  bool get isInitialized => _initialized;
  ThemeMode get themeMode => _themeMode;
  String get location => _location;
  String get calculationMethod => _calculationMethod;
  String get juristicMethod => _juristicMethod;
  String get timezone => _timezone;
  double get latitude => _latitude;
  double get longitude => _longitude;
  bool get counterSound => _counterSound;
  String get adhanSound => _adhanSound;
  Map<String, bool> get alarmSettings => _alarmSettings;

  // Initialize settings from SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _themeMode = ThemeMode.values[_prefs.getInt(THEME_KEY) ?? 0];
    _location = _prefs.getString(LOCATION_KEY) ?? '';
    _calculationMethod = _prefs.getString(METHOD_KEY) ?? '3';
    _juristicMethod = _prefs.getString(SCHOOL_KEY) ?? '0';
    _timezone = _prefs.getString(TIMEZONE_KEY) ?? '';
    _latitude = _prefs.getDouble(LATITUDE_KEY) ?? 0.0;
    _longitude = _prefs.getDouble(LONGITUDE_KEY) ?? 0.0;
    _counterSound = _prefs.getBool(SOUND_KEY) ?? true;
    _adhanSound = _prefs.getString(ADHAN_SOUND_KEY) ?? 'default';

    for (String prayer in _alarmSettings.keys) {
      _alarmSettings[prayer] = _prefs.getBool('$ALARM_PREFIX$prayer') ?? true;
    }

    _initialized = true;
    notifyListeners();
  }

  // Setters with persistence
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt(THEME_KEY, mode.index);
    notifyListeners();
  }

  Future<void> setLocation(
      String location, double latitude, double longitude) async {
    _location = location;
    _latitude = latitude;
    _longitude = longitude;
    await _prefs.setString(LOCATION_KEY, location);
    await _prefs.setDouble(LATITUDE_KEY, latitude);
    await _prefs.setDouble(LONGITUDE_KEY, longitude);
    notifyListeners();
  }

  Future<void> setCalculationMethod(String method) async {
    _calculationMethod = method;
    await _prefs.setString(METHOD_KEY, method);
    notifyListeners();
  }

  Future<void> setJuristicMethod(String method) async {
    _juristicMethod = method;
    await _prefs.setString(SCHOOL_KEY, method);
    notifyListeners();
  }

  Future<void> setTimezone(String timezone) async {
    _timezone = timezone;
    await _prefs.setString(TIMEZONE_KEY, timezone);
    notifyListeners();
  }

  Future<void> setCounterSound(bool enabled) async {
    _counterSound = enabled;
    await _prefs.setBool(SOUND_KEY, enabled);
    notifyListeners();
  }

  Future<void> setAdhanSound(String sound) async {
    _adhanSound = sound;
    await _prefs.setString(ADHAN_SOUND_KEY, sound);
    notifyListeners();
  }

  Future<void> setAlarm(String prayer, bool enabled) async {
    _alarmSettings[prayer] = enabled;
    await _prefs.setBool('$ALARM_PREFIX$prayer', enabled);
    notifyListeners();
  }

  // Get prayer calculation parameters
  Map<String, dynamic> getPrayerCalculationParams() {
    return {
      'method': int.parse(_calculationMethod),
      'school': int.parse(_juristicMethod),
      'latitude': _latitude,
      'longitude': _longitude,
      'timezone': _timezone,
    };
  }

  Future<void> updateLocation(String location) async {
    // Provide default latitude and longitude if necessary.
    double defaultLatitude = 0.0;
    double defaultLongitude = 0.0;

    // Call setLocation with default latitude and longitude.
    await setLocation(location, defaultLatitude, defaultLongitude);
  }
}

// Example of how to update the CalculationMethodSection widget to use the new options
class CalculationMethodSection extends StatelessWidget {
  final String currentMethod;
  final Function(String) onMethodChanged;

  const CalculationMethodSection({
    Key? key,
    required this.currentMethod,
    required this.onMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Prayer Calculation Method",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: currentMethod,
                isExpanded: true, // Ensures dropdown items use available space
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  hintText: "Select Calculation Method",
                ),
                items: SettingsProvider.calculationMethods.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(
                      entry.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // Avoids overflow
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onMethodChanged(value);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a calculation method"),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
