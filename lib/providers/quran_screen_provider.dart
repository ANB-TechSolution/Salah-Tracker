import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class QuranProvider extends ChangeNotifier {
  List<dynamic> _surahs = [];
  List<dynamic> _translations = [];
  Set<int> _favoriteSurahIds = {};
  String _selectedTranslation = '131';
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = "";
  String _searchQuery = "";

  List<dynamic> get surahs => _filteredSurahs();
  List<dynamic> get translations => _translations;
  Set<int> get favoriteSurahIds => _favoriteSurahIds;
  String get selectedTranslation => _selectedTranslation;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  QuranProvider() {
    _init();
  }

  Future<void> _init() async {
    await _fetchFavorites();
    await _fetchTranslations();
    await fetchSurahs();
  }

  Future<void> _fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteSurahIds = prefs
            .getStringList('favoriteSurahIds')
            ?.map((e) => int.parse(e))
            .toSet() ??
        {};
    notifyListeners();
  }

  Future<void> toggleFavorite(int surahId) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favoriteSurahIds.contains(surahId)) {
      _favoriteSurahIds.remove(surahId);
    } else {
      _favoriteSurahIds.add(surahId);
    }
    prefs.setStringList('favoriteSurahIds',
        _favoriteSurahIds.map((e) => e.toString()).toList());
    notifyListeners();
  }

  Future<void> _fetchTranslations() async {
    try {
      final url =
          Uri.parse("https://api.quran.com/api/v4/resources/translations");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _translations = data['translations'];
        await _saveToLocal('savedTranslations', _translations);
      } else {
        throw Exception(
            "Failed to load translations. Status code: ${response.statusCode}");
      }
    } catch (_) {
      _translations = await _loadFromLocal('savedTranslations');
    }
    notifyListeners();
  }

  Future<void> fetchSurahs() async {
    try {
      final url = Uri.parse("https://api.quran.com/api/v4/chapters");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _surahs = data['chapters'];
        _isLoading = false;
        await _saveToLocal('savedSurahs', _surahs);
      } else {
        throw Exception(
            "Failed to load Surahs. Status code: ${response.statusCode}");
      }
    } catch (_) {
      _surahs = await _loadFromLocal('savedSurahs');
      _isLoading = false;
      _hasError = _surahs.isEmpty;
      _errorMessage = _hasError
          ? "Failed to load data. Please connect to the internet."
          : "";
    }
    notifyListeners();
  }

  Future<void> _saveToLocal(String key, List<dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(data));
  }

  Future<List<dynamic>> _loadFromLocal(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(key);
    return savedData != null ? json.decode(savedData) : [];
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void updateSelectedTranslation(String? translationId) {
    if (translationId != null) {
      _selectedTranslation = translationId;
      notifyListeners();
    }
  }

  List<dynamic> _filteredSurahs() {
    return _surahs.where((surah) {
      final englishName = surah['name_simple'].toLowerCase();
      final arabicName = surah['name_arabic'].toLowerCase();
      final number = surah['id'].toString();
      return englishName.contains(_searchQuery) ||
          arabicName.contains(_searchQuery) ||
          number.contains(_searchQuery);
    }).toList();
  }
}
