import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class SurahDetailProvider extends ChangeNotifier {
  List<dynamic> verses = [];
  bool isLoading = true;
  bool isDownloaded = false;
  bool hasError = false;
  bool isConnected = true;
  String errorMessage = "";
  late Box surahBox;

  final int surahNumber;
  final String translationId;

  SurahDetailProvider(this.surahNumber, this.translationId) {
    initializeHive();
  }

  Future<void> initializeHive() async {
    await Hive.initFlutter();
    surahBox = await Hive.openBox('surahBox');
    checkConnectionAndLoadData();
  }

  Future<void> checkConnectionAndLoadData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    isConnected = connectivityResult != ConnectivityResult.none;

    if (isConnected) {
      await loadSurahDetails();
    } else {
      await loadCachedData();
    }
    notifyListeners();
  }

  Future<void> loadCachedData() async {
    try {
      final cachedData = surahBox.get('surah_${surahNumber}_$translationId');
      if (cachedData != null) {
        verses = List<dynamic>.from(json.decode(cachedData));
        isDownloaded = true;
      } else {
        hasError = true;
        errorMessage = "No data available offline. Please download first.";
      }
    } catch (e) {
      hasError = true;
      errorMessage = "Error loading cached data: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSurahDetails() async {
    final url = Uri.parse(
        "https://api.quran.com/api/v4/quran/verses/uthmani?chapter_number=$surahNumber");
    final translationUrl = Uri.parse(
        "https://api.quran.com/api/v4/quran/translations/$translationId?chapter_number=$surahNumber");

    try {
      final responses =
          await Future.wait([http.get(url), http.get(translationUrl)]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final verseData = json.decode(responses[0].body);
        final translationData = json.decode(responses[1].body);

        verses = List.generate(
          verseData['verses'].length,
          (index) => {
            'verse_number': verseData['verses'][index]['verse_key'] ?? '',
            'arabic_text': verseData['verses'][index]['text_uthmani'] ?? '',
            'translation_text':
                translationData['translations'][index]['text'] ?? '',
          },
        );
        isDownloaded = true;
      } else {
        throw Exception(
            "Failed to load data. Verse status: ${responses[0].statusCode}, Translation status: ${responses[1].statusCode}");
      }
    } catch (e) {
      hasError = true;
      errorMessage = "Error loading data: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadSurah() async {
    try {
      if (verses.isNotEmpty) {
        await surahBox.put(
          'surah_${surahNumber}_$translationId',
          json.encode(verses),
        );
        isDownloaded = true;
      }
    } catch (e) {
      hasError = true;
      errorMessage = "Failed to download: $e";
    }
    notifyListeners();
  }
}
