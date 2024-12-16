import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final Set<int> favoriteSurahIds;
  final List<dynamic> surahs;
  final Function(int) onToggleFavorite;

  FavoritesScreen({
    required this.favoriteSurahIds,
    required this.surahs,
    required this.onToggleFavorite,
  });

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<dynamic> favoriteSurahs;

  @override
  void initState() {
    super.initState();
    favoriteSurahs = widget.surahs
        .where((surah) => widget.favoriteSurahIds.contains(surah['id']))
        .toList();
  }

  void _removeFavorite(int surahId) {
    setState(() {
      // Remove the Surah from favorites in real-time
      favoriteSurahs.removeWhere((surah) => surah['id'] == surahId);
      widget.onToggleFavorite(surahId);
    });

    // Show a snackbar confirming the deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Surah removed from favorites.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.teal,
      ),
      body: favoriteSurahs.isEmpty
          ? const Center(
              child: Text(
                "No favorites added yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: favoriteSurahs.length,
              itemBuilder: (context, index) {
                final surah = favoriteSurahs[index];
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(
                      '${surah['name_simple']} - ${surah['name_arabic']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text('Revelation Place: ${surah['revelation_place']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFavorite(surah['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
