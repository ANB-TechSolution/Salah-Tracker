// Add a new JuristicMethodSection widget
import 'package:flutter/material.dart';

import '../providers/setting_provider.dart';

class JuristicMethodSection extends StatelessWidget {
  final String currentMethod;
  final Function(String) onMethodChanged;

  const JuristicMethodSection({
    Key? key,
    required this.currentMethod,
    required this.onMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Asr Calculation Method",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: currentMethod,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: SettingsProvider.juristicMethods.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onMethodChanged(value);
          },
        ),
      ],
    );
  }
}
