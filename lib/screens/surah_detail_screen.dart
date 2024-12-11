import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool hasError = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchSurahDetails();
  }

  Future<void> fetchSurahDetails() async {
    final url = Uri.parse(
        "https://api.quran.com/api/v4/quran/verses/uthmani?chapter_number=${widget.surahNumber}");
    final translationUrl = Uri.parse(
        "https://api.quran.com/api/v4/quran/translations/${widget.translationId}?chapter_number=${widget.surahNumber}");
    try {
      // Fetch both verses and their translations
      final responses = await Future.wait([http.get(url), http.get(translationUrl)]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final verseData = json.decode(responses[0].body);
        final translationData = json.decode(responses[1].body);

        setState(() {
          // Combine verses and translations
          verses = List.generate(
            verseData['verses'].length,
            (index) => {
              'verse_number': verseData['verses'][index]['verse_key'] ?? '',
              'arabic_text': verseData['verses'][index]['text_uthmani'] ?? '',
              'translation_text': translationData['translations'][index]['text'] ?? '',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Surah ${widget.surahNumber} Details"),
        backgroundColor: Colors.teal,
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          "Verse ${verse['verse_number'] ?? ''}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              verse['arabic_text'] ?? 'No Arabic text available',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              verse['translation_text'] ??
                                  'No translation available',
                              style: const TextStyle(
                                fontSize: 14,
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
