import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_screen_provider.dart';
import 'favoritesScreen.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    favoriteSurahIds:
                        context.read<QuranProvider>().favoriteSurahIds,
                    surahs: context.read<QuranProvider>().surahs,
                    onToggleFavorite:
                        context.read<QuranProvider>().toggleFavorite,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => provider.fetchSurahs(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: provider.selectedTranslation,
                  decoration: const InputDecoration(
                    labelText: 'Select Translation',
                    border: OutlineInputBorder(),
                  ),
                  items: provider.translations
                      .map<DropdownMenuItem<String>>((dynamic translation) {
                    return DropdownMenuItem<String>(
                      value: translation['id'].toString(),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, // 80% of screen width
                        child: Text(
                          '${translation['name']} (${translation['language_name']})',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: provider.updateSelectedTranslation,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: provider.updateSearchQuery,
                  decoration: const InputDecoration(
                    hintText: "Search Surah by number, English or Arabic name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.surahs.length,
                  itemBuilder: (context, index) {
                    final surah = provider.surahs[index];
                    final isFavorite =
                        provider.favoriteSurahIds.contains(surah['id']);
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Revelation Place: ${surah['revelation_place']}'),
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => provider.toggleFavorite(surah['id']),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurahDetailScreen(
                                surahNumber: surah['id'],
                                translationId: provider.selectedTranslation,
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
          );
        },
      ),
    );
  }
}
