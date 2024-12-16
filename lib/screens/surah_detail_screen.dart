import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loadSurahDetails();
  }

  Future<void> loadSurahDetails() async {
    try {
      // Check if Surah details are cached in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('surah_${widget.surahNumber}');
      if (cachedData != null) {
        setState(() {
          verses = json.decode(cachedData);
          isDownloaded = true;
          isLoading = false;
        });
      } else {
        fetchSurahDetails();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = "Error loading Surah details: $e";
      });
    }
  }

  Future<void> fetchSurahDetails() async {
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
        errorMessage = "Error fetching Surah details: $e";
      });
    }
  }

  Future<void> downloadSurah() async {
    try {
      // Cache Surah details in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('surah_${widget.surahNumber}', json.encode(verses));

      setState(() {
        isDownloaded = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Surah downloaded successfully!")),
      );
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
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            hasError = false;
                          });
                          fetchSurahDetails();
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
                            // Verse Number
                            Text(
                              "Verse ${verse['verse_number'] ?? ''}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Arabic Text
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

                            // Translation Text
                            Text(
                              verse['translation_text'] ??
                                  'No translation available',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.copy,
                                      color: Colors.teal),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            "${verse['verse_number']}\n${verse['arabic_text']}\n${verse['translation_text']}"));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Verse copied to clipboard")),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share,
                                      color: Colors.teal),
                                  onPressed: () {
                                    Share.share(
                                        "${verse['verse_number']}\n${verse['arabic_text']}\n${verse['translation_text']}");
                                  },
                                ),
                              ],
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
