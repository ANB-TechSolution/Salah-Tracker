import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'surah_detail_screen.dart'; // Import SurahDetailsScreen

class QuranScreen extends StatefulWidget {
  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<dynamic> surahs = [];
  List<dynamic> translations = [];
  String selectedTranslation =
      '131'; // Default translation ID for Saheeh International (English)
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = "";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchTranslations().then((_) {
      fetchSurahs();
    });
  }

  // Fetch available translations
  Future<void> fetchTranslations() async {
    final url =
        Uri.parse("https://api.quran.com/api/v4/resources/translations");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          translations = data['translations'];
        });
      } else {
        throw Exception(
            "Failed to load translations. Status code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = "Error fetching translations: $e";
      });
    }
  }

  // Fetch list of Surahs
  Future<void> fetchSurahs() async {
    final url = Uri.parse("https://api.quran.com/api/v4/chapters");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          surahs = data['chapters'];
          isLoading = false;
        });
      } else {
        throw Exception(
            "Failed to load Surahs. Status code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = "Error fetching Surahs: $e";
      });
    }
  }

  void _filterSurahs(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredSurahs = surahs.where((surah) {
      final englishName = surah['name_simple'].toLowerCase();
      final arabicName = surah['name_arabic'].toLowerCase();
      final number = surah['id'].toString();
      return englishName.contains(searchQuery) ||
          arabicName.contains(searchQuery) ||
          number.contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Al-Quran"),
        backgroundColor: Colors.teal,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.book),
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
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            hasError = false;
                          });
                          fetchSurahs();
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: selectedTranslation,
                        decoration: const InputDecoration(
                          labelText: 'Select Translation',
                          border: OutlineInputBorder(),
                        ),
                        items: translations.map<DropdownMenuItem<String>>(
                            (dynamic translation) {
                          return DropdownMenuItem<String>(
                            value: translation['id'].toString(),
                            child: Text(
                              '${translation['name']} (${translation['language_name']})',
                              // No constraints here, full text will be displayed
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTranslation = newValue!;
                          });
                        },
                        // Use a custom child to constrain the title only
                        selectedItemBuilder: (BuildContext context) {
                          return translations
                              .map<Widget>((dynamic translation) {
                            return ConstrainedBox(
                              constraints: const BoxConstraints(
                                  maxWidth: 200), // Limit title width
                              child: Text(
                                '${translation['name']} (${translation['language_name']})',
                                overflow: TextOverflow
                                    .ellipsis, // Truncate text if too long
                                maxLines: 1,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: _filterSurahs,
                        decoration: const InputDecoration(
                          hintText:
                              "Search Surah by number, English or Arabic name",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredSurahs.length,
                        itemBuilder: (context, index) {
                          final surah = filteredSurahs[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Text(
                                  surah['id'].toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                '${surah['name_simple']} - ${surah['name_arabic']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  'Revelation Place: ${surah['revelation_place']}'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SurahDetailScreen(
                                      surahNumber: surah['id'],
                                      translationId: selectedTranslation,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
