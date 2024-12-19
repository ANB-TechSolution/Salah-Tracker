import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final String translationId;

  SurahDetailScreen({required this.surahNumber, required this.translationId});

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  List<dynamic> verses = [];
  bool isLoading = true;
  bool isDownloaded = false;
  bool hasError = false;
  bool isConnected = true;
  String errorMessage = "";
  late Box surahBox;

  @override
  void initState() {
    super.initState();
    initializeHive();
  }

  /// Initialize Hive and check data availability
  Future<void> initializeHive() async {
    await Hive.initFlutter();
    surahBox = await Hive.openBox('surahBox');
    checkConnectionAndLoadData();
  }

  /// Check network connection and load data accordingly
  Future<void> checkConnectionAndLoadData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });

    if (isConnected) {
      await loadSurahDetails();
    } else {
      await loadCachedData();
    }
  }

  /// Load cached Surah data if offline
  Future<void> loadCachedData() async {
    try {
      final cachedData =
          surahBox.get('surah_${widget.surahNumber}_${widget.translationId}');
      if (cachedData != null) {
        setState(() {
          verses = List<dynamic>.from(json.decode(cachedData));
          isDownloaded = true;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = "No data available offline. Please download first.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = "Error loading cached data: $e";
      });
    }
  }

  /// Fetch Surah details from the API
  Future<void> loadSurahDetails() async {
    final url = Uri.parse(
        "https://api.quran.com/api/v4/quran/verses/uthmani?chapter_number=${widget.surahNumber}");
    final translationUrl = Uri.parse(
        "https://api.quran.com/api/v4/quran/translations/${widget.translationId}?chapter_number=${widget.surahNumber}");

    try {
      final responses =
          await Future.wait([http.get(url), http.get(translationUrl)]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final verseData = json.decode(responses[0].body);
        final translationData = json.decode(responses[1].body);

        setState(() {
          verses = List.generate(
            verseData['verses'].length,
            (index) => {
              'verse_number': verseData['verses'][index]['verse_key'] ?? '',
              'arabic_text': verseData['verses'][index]['text_uthmani'] ?? '',
              'translation_text':
                  translationData['translations'][index]['text'] ?? '',
            },
          );
          isLoading = false;
        });
      } else {
        throw Exception(
            "Failed to load data. Verse status: ${responses[0].statusCode}, Translation status: ${responses[1].statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = "Connect Internet";
      });
    }
  }

  /// Download and cache Surah data for offline use
  Future<void> downloadSurah() async {
    try {
      if (verses.isEmpty) {
        await loadSurahDetails();
      }

      if (verses.isNotEmpty) {
        await surahBox.put(
          'surah_${widget.surahNumber}_${widget.translationId}',
          json.encode(verses),
        );

        setState(() {
          isDownloaded = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Surah downloaded successfully!")),
        );
      } else {
        throw Exception("Failed to fetch Surah details.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to download Surah: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Surah ${widget.surahNumber} Details"),
        backgroundColor: Colors.teal,
        actions: [
          if (!isDownloaded)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: downloadSurah,
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      if (isConnected)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              hasError = false;
                            });
                            loadSurahDetails();
                          },
                          child: const Text("Retry"),
                        ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: verses.length,
                  itemBuilder: (context, index) {
                    final verse = verses[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Verse ${verse['verse_number'] ?? ''}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              verse['arabic_text'] ??
                                  'No Arabic text available',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const Divider(height: 16, color: Colors.grey),
                            Text(
                              verse['translation_text'] ??
                                  'No translation available',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
