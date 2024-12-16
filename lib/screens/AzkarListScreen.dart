import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class AzkarListScreen extends StatelessWidget {
  final String categoryName;
  final List<Map<String, String>> categoryAzkar;

  AzkarListScreen({required this.categoryName, required this.categoryAzkar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Center(
          child: Text(categoryName),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: categoryAzkar.length,
        itemBuilder: (context, index) {
          final azkar = categoryAzkar[index];
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Arabic Text
                  Text(
                    azkar['arabic']!,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: const Color.fromARGB(255, 207, 207, 207)),
                  SizedBox(height: 10),
                  // English Translation
                  Text(
                    "English Translation:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    azkar['english']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Urdu Translation
                  Text(
                    "Urdu Translation:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    azkar['urdu']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
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
                            SnackBar(content: Text("Copied to clipboard")),
                          );
                        },
                        icon: Icon(Icons.copy),
                        label: Text("Copy"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Share.share(
                              "${azkar['arabic']}\n\nEnglish Translation: ${azkar['english']}\n\nUrdu Translation: ${azkar['urdu']}");
                        },
                        icon: Icon(Icons.share),
                        label: Text("Share"),
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
