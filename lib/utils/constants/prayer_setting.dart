class PrayerSettings {
  // SharedPreferences keys for storing settings
  static const String CALC_METHOD_KEY = 'calculation_method';
  static const String HIGH_LAT_METHOD_KEY = 'high_latitude_method';

  // Calculation Methods
  static const Map<String, int> CALCULATION_METHODS = {
    'Muslim World League': 3,
    'Islamic Society of North America (ISNA)': 2,
    'Egyptian General Authority of Survey': 5,
    'Umm Al-Qura University, Makkah': 4,
    'University of Islamic Sciences, Karachi': 1,
    'Gulf Region': 7,
    'Kuwait': 8,
    'Qatar': 9,
    'Majlis Ugama Islam Singapura': 12,
    'Union des Organisations Islamiques de France': 13,
    'Diyanet İşleri Başkanlığı (Turkey)': 14,
    'Spiritual Administration of Muslims of Russia': 15,
    'Default': 1, // Fallback to University of Islamic Sciences, Karachi
  };

  // High Latitude Methods
  static const Map<String, String> HIGH_LAT_METHODS = {
    'None': 'none',
    'Middle of the Night': 'middleofnight',
    'One-Seventh': 'oneseventhnight',
    'Angle Based': 'anglebased',
    'Auto': 'auto', // Added to match the usage in PrayerTimingsProvider
  };

  // Safe method to get calculation method with a default value
  static int getCalculationMethod(int? storedMethod) {
    return storedMethod ?? CALCULATION_METHODS['Default']!;
  }

  // Safe method to get high latitude method with a default value
  static String getHighLatMethod(String? storedMethod) {
    return storedMethod ?? HIGH_LAT_METHODS['Auto']!;
  }
}
