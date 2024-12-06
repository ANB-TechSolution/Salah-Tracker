import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;
  final ThemeMode currentThemeMode;

  const SettingsScreen(
      {required this.toggleTheme, required this.currentThemeMode});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    // Convert ThemeMode to boolean for the switch
    _isDarkMode = widget.currentThemeMode == ThemeMode.dark;
  }

  void _onThemeToggle(bool isDark) {
    // Determine the new theme mode based on the switch value
    ThemeMode newThemeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    // Call the toggle theme function passed from parent
    widget.toggleTheme(newThemeMode);

    // Update local state
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text("Dark Theme"),
            subtitle: Text("Toggle between light and dark mode"),
            value: _isDarkMode,
            activeColor: Colors.teal,
            onChanged: _onThemeToggle,
          ),
          // You can add more settings here in the future
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Current Theme: ${_getDarkModeText()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _getDarkModeText() {
    switch (widget.currentThemeMode) {
      case ThemeMode.dark:
        return "Dark Mode";
      case ThemeMode.light:
        return "Light Mode";
      case ThemeMode.system:
      default:
        return "System Default";
    }
  }
}
