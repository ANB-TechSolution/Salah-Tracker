import 'package:flutter/material.dart';
import 'package:salahtracker/screens/favoritesScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Set<int> favoriteSurahIds = {};
  String selectedTranslation = '131';
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = "";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchFavorites();
    fetchTranslations().then((_) {
      fetchSurahs();
    });
  }

  // Check if there is saved data
  Future<bool> isDataSavedLocally() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('savedSurahs');
  }

  // Save Surahs to local storage
  Future<void> saveSurahsLocally(List<dynamic> surahs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedSurahs', json.encode(surahs));
  }

  // Load Surahs from local storage
  Future<void> loadSurahsLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSurahs = prefs.getString('savedSurahs');
    if (savedSurahs != null) {
      setState(() {
        surahs = json.decode(savedSurahs);
      });
    }
  }

  // Save Translations to local storage
  Future<void> saveTranslationsLocally(List<dynamic> translations) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedTranslations', json.encode(translations));
  }

  // Load Translations from local storage
  Future<void> loadTranslationsLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTranslations = prefs.getString('savedTranslations');
    if (savedTranslations != null) {
      setState(() {
        translations = json.decode(savedTranslations);
      });
    }
  }

  // Fetch translations from API or load from local storage
  Future<void> fetchTranslations() async {
    try {
      final url = Uri.parse("https://api.quran.com/api/v4/resources/translations");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          translations = data['translations'];
        });
        await saveTranslationsLocally(translations);
      } else {
        throw Exception(
            "Failed to load translations. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Load locally if network fails
      await loadTranslationsLocally();
    }
  }

  // Fetch Surahs from API or load from local storage
  Future<void> fetchSurahs() async {
    try {
      final url = Uri.parse("https://api.quran.com/api/v4/chapters");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          surahs = data['chapters'];
          isLoading = false;
        });
        await saveSurahsLocally(surahs);
      } else {
        throw Exception(
            "Failed to load Surahs. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Load locally if network fails
      final dataSavedLocally = await isDataSavedLocally();
      if (dataSavedLocally) {
        await loadSurahsLocally();
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage =
              "Failed to load data. Please connect to the internet.";
        });
      }
    }
  }

  Future<void> fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteSurahIds = prefs
              .getStringList('favoriteSurahIds')
              ?.map((e) => int.parse(e))
              .toSet() ??
          {};
    });
  }

  Future<void> toggleFavorite(int surahId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteSurahIds.contains(surahId)) {
        favoriteSurahIds.remove(surahId);
      } else {
        favoriteSurahIds.add(surahId);
      }
      prefs.setStringList('favoriteSurahIds',
          favoriteSurahIds.map((e) => e.toString()).toList());
    });
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
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favoriteSurahIds: favoriteSurahIds,
                    surahs: surahs,
                    onToggleFavorite: toggleFavorite,
                  ),
                ),
              );
            },
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
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTranslation = newValue!;
                          });
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
                          final isFavorite =
                              favoriteSurahIds.contains(surah['id']);
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
                              trailing: IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                ),
                                onPressed: () => toggleFavorite(surah['id']),
                              ),
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
