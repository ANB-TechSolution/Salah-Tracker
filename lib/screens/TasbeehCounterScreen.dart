import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../utils/helper_function.dart';

class TasbeehCounterScreen extends StatefulWidget {
  @override
  _TasbeehCounterScreenState createState() => _TasbeehCounterScreenState();
}

class _TasbeehCounterScreenState extends State<TasbeehCounterScreen> {
  int _counter = 0; // Tasbeeh counter
  Color _color = Colors.teal.withAlpha(10); // Initial alpha
  bool _isTapped = false; // Flag to track if the user has tapped
  bool _isCounterBlack =
      true; // Flag to switch the counter color after 7 counts

  final String currentDate = DateFormat('EEEE, dd MMMM').format(DateTime.now());

  // Load saved count from SharedPreferences
  void _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0; // Default to 0 if no saved count
      _color = Colors.teal.withAlpha((_counter * 8).clamp(10, 255));
    });
  }

  // Save the current counter to SharedPreferences
  void _saveCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', _counter);
  }

  // Method to handle tapping and updating the counter and color
  void _incrementCounter() {
    setState(() {
      if (_counter < 33) {
        _counter++;
        // Change color of counter text after 7 counts
        if (_counter > 4) {
          _isCounterBlack = false; // Change counter color to white after 7
        }
        _color = Colors.teal.withAlpha((_counter * 3).clamp(10, 255));
      } else {
        _counter = 0;
        _color =
            Colors.teal.withAlpha(10); // Reset the alpha when count reaches 33
        _isCounterBlack = true; // Reset counter color back to black
      }
      _isTapped = true; // Mark that the user has tapped
    });
  }

  // Reset the counter to 0
  void _resetCounter() {
    setState(() {
      _counter = 0;
      _color = Colors.teal.withAlpha(10);
      _isCounterBlack = true; // Reset to black after reset
      _isTapped = false; // Reset the tap flag
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCounter(); // Load the saved counter when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Tasbeeh Counter'),
        backgroundColor: Colors.teal,
      ),
      body: GestureDetector(
        onTap: _incrementCounter,
        child: Container(
          color: _color, // Background color changes with alpha
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_isTapped)
                      Text(
                        'Tap the screen to start counting',
                        style: TextStyle(
                          fontSize: 18,
                          color: HelperFunction.isDarkMode(context)
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      'Count: $_counter',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _saveCounter(); // Save count
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(150, 50),
                      ),
                      child: const Text(
                        'Save Count',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _resetCounter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(150, 50),
                      ), // Reset count to 0
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
