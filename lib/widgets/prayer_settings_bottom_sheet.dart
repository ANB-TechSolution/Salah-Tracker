import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_timing_provider.dart';
import '../utils/constants/prayer_setting.dart';

class PrayerSettingsBottomSheet extends StatelessWidget {
  const PrayerSettingsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<PrayerTimingsProvider>(
        builder: (context, provider, _) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Prayer Calculation Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCalculationMethodDropdown(context, provider),
                const SizedBox(height: 16),
                _buildHighLatitudeMethodDropdown(context, provider),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Save Settings'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalculationMethodDropdown(
      BuildContext context, PrayerTimingsProvider provider) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        labelText: 'Calculation Method',
        border: OutlineInputBorder(),
      ),
      value: provider.selectedCalculationMethod,
      items: PrayerSettings.CALCULATION_METHODS.entries
          .map((e) => DropdownMenuItem(
                value: e.value,
                child: Text(e.key),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          provider.updateCalculationMethod(value);
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildHighLatitudeMethodDropdown(
      BuildContext context, PrayerTimingsProvider provider) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        labelText: 'High Latitude Method',
        border: OutlineInputBorder(),
      ),
      value: provider.selectedHighLatMethod,
      items: PrayerSettings.HIGH_LAT_METHODS.entries
          .map((e) => DropdownMenuItem(
                value: e.value,
                child: Text(e.key),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          provider.updateHighLatMethod(value);
          Navigator.pop(context);
        }
      },
    );
  }
}
