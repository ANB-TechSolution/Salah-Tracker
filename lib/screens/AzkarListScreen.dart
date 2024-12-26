import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salahtracker/utils/helper_function.dart';
import 'package:share_plus/share_plus.dart';

class AzkarListScreen extends StatelessWidget {
  final String categoryName;
  final List<Map<String, String>> categoryAzkar;

  const AzkarListScreen(
      {required this.categoryName, required this.categoryAzkar});

  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Center(
          child: Text(categoryName),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categoryAzkar.length,
        itemBuilder: (context, index) {
          final azkar = categoryAzkar[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Arabic Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        azkar['arabic']!,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Color.fromARGB(255, 207, 207, 207)),
                  const SizedBox(height: 10),
                  // English Translation
                  Text(
                    "English Translation:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    azkar['english']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Urdu Translation
                  Text(
                    "Urdu Translation:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          azkar['urdu']!,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Optional: Truncate overflow text
                          maxLines: 3, // Optional: Limit to a single line
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  // Copy and Share Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text:
                                  "${azkar['arabic']}\n\nEnglish Translation: ${azkar['english']}\n\nUrdu Translation: ${azkar['urdu']}"));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Copied to clipboard")),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text("Copy"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Share.share(
                              "${azkar['arabic']}\n\nEnglish Translation: ${azkar['english']}\n\nUrdu Translation: ${azkar['urdu']}");
                        },
                        icon: const Icon(Icons.share),
                        label: const Text("Share"),
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
