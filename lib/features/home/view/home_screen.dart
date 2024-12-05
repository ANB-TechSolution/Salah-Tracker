import 'package:flutter/material.dart';
import 'package:salah_tracker/utils/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Thu, 05 Dec 2024',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/home/menu.webp',
            height: 24, // Adjust size
            width: 24,
            color: TColors.white,
          ),
          onPressed: () {
            // Handle menu button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColors.white,
                fontFamily:
                    'TraditionalArabic', // Optional: Specify a custom Arabic font
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Salah Tracker",
              style: TextStyle(
                color: TColors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCard(
                    imagePath:
                        'assets/icons/home/timings.png', // Replace with your image asset
                    label: 'Prayer Timings',
                    onTap: () {
                      // Handle Prayer Timings button press
                    },
                  ),
                  _buildCard(
                    imagePath:
                        'assets/icons/home/prayer.png', // Replace with your image asset
                    label: 'Learn Quran',
                    onTap: () {
                      // Handle Learn Quran button press
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String imagePath, // Accept asset image path
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 40, // Adjust size
              width: 40, // Adjust size
              color: const Color(0xFF5A98CA), // Optional: Apply a tint color
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
