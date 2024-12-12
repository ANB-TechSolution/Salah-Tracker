import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/prayer_timing_provider.dart';
import '../utils/constants/prayer_setting.dart';
import '../widgets/prayer_settings_bottom_sheet.dart';

class PrayerTimingScreen extends StatelessWidget {
  final String location;
  final double latitude;
  final double longitude;

  const PrayerTimingScreen({
    Key? key,
    required this.location,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const _LoadingScreen();
        }

        return ChangeNotifierProvider(
          create: (_) => PrayerTimingsProvider(
            location: location,
            latitude: latitude,
            longitude: longitude,
            prefs: snapshot.data!,
          ),
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Prayer Times'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _showSettingsBottomSheet(context),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<PrayerTimingsProvider>().refresh();
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<PrayerTimingsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const _LoadingScreen();
        }

        if (provider.error != null) {
          return _ErrorScreen(
            errorMessage: provider.error!,
            onRetry: provider.refresh,
          );
        }

        return _PrayerTimingsContent(
          location: location,
          onSettingsTap: () => _showSettingsBottomSheet(context),
        );
      },
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const PrayerSettingsBottomSheet(),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.teal),
          SizedBox(height: 16),
          Text(
            'Loading Prayer Times...',
            style: TextStyle(color: Colors.teal),
          )
        ],
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorScreen({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          const Text(
            'Unable to Load Prayer Times',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

class _PrayerTimingsContent extends StatelessWidget {
  final String location;
  final VoidCallback onSettingsTap;

  const _PrayerTimingsContent({
    Key? key,
    required this.location,
    required this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerTimingsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            _SettingsPanel(location: location, onSettingsTap: onSettingsTap),
            Expanded(
              child: _PrayerTimesList(
                prayerTimes: provider.timings,
                currentPrayer: provider.currentPrayer,
                convertTime: provider.convertTo12HourFormat,
                isCurrentPrayer: provider.isCurrentPrayer,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  final String location;
  final VoidCallback onSettingsTap;

  const _SettingsPanel({
    Key? key,
    required this.location,
    required this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PrayerTimingsProvider>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSettingsRow(
            title: 'Calculation Method',
            value: PrayerSettings.CALCULATION_METHODS.keys.firstWhere(
              (key) =>
                  PrayerSettings.CALCULATION_METHODS[key] ==
                  provider.selectedCalculationMethod,
              orElse: () => 'Default',
            ),
            onTap: onSettingsTap,
          ),
          _buildSettingsRow(
            title: 'High Latitude Method',
            value: PrayerSettings.HIGH_LAT_METHODS.keys.firstWhere(
              (key) =>
                  PrayerSettings.HIGH_LAT_METHODS[key] ==
                  provider.selectedHighLatMethod,
              orElse: () => 'Auto',
            ),
            onTap: onSettingsTap,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        TextButton.icon(
          icon: const Icon(Icons.settings_suggest, size: 16),
          label: Text(value),
          onPressed: onTap,
        ),
      ],
    );
  }
}

class _PrayerTimesList extends StatelessWidget {
  final Map<String, String> prayerTimes;
  final String currentPrayer;
  final String Function(String) convertTime;
  final bool Function(String) isCurrentPrayer;

  const _PrayerTimesList({
    Key? key,
    required this.prayerTimes,
    required this.currentPrayer,
    required this.convertTime,
    required this.isCurrentPrayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          child: _NextPrayerCard(
            currentPrayer: currentPrayer,
            remainingTime: context.watch<PrayerTimingsProvider>().remainingTime,
          ),
        ),
        const SizedBox(height: 16),
        ...prayers.map(_buildPrayerTimeCard).toList(),
      ],
    );
  }

  Widget _buildPrayerTimeCard(String prayer) {
    final time = convertTime(prayerTimes[prayer] ?? '');
    final isCurrent = isCurrentPrayer(prayer);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      color: isCurrent ? Colors.teal.shade50 : Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.access_time,
          color: isCurrent ? Colors.teal : Colors.grey,
        ),
        title: Text(
          prayer,
          style: TextStyle(
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontSize: 16,
            color: isCurrent ? Colors.teal : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _NextPrayerCard extends StatelessWidget {
  final String currentPrayer;
  final String remainingTime;

  const _NextPrayerCard({
    Key? key,
    required this.currentPrayer,
    required this.remainingTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Next Prayer',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentPrayer,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          Text(
            remainingTime,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
