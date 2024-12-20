import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/surah_details_provider.dart';

class SurahDetailScreen extends StatelessWidget {
  final int surahNumber;
  final String translationId;

  const SurahDetailScreen({
    Key? key,
    required this.surahNumber,
    required this.translationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SurahDetailProvider(surahNumber, translationId),
      child: Consumer<SurahDetailProvider>(
        builder: (context, provider, child) {
          bool isDark = Theme.of(context).brightness == Brightness.dark;

          return Scaffold(
            appBar: AppBar(
              title: Text("Surah $surahNumber Details"),
              backgroundColor: Colors.teal,
              actions: [
                if (!provider.isDownloaded)
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: provider.downloadSurah,
                  ),
              ],
            ),
            body: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.errorMessage,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            if (provider.isConnected)
                              ElevatedButton(
                                onPressed: provider.loadSurahDetails,
                                child: const Text("Retry"),
                              ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.verses.length,
                        itemBuilder: (context, index) {
                          final verse = provider.verses[index];
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          verse['arabic_text'] ??
                                              'No Arabic text available',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
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
        },
      ),
    );
  }
}
