import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _musicEnabled = true;
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;
  bool _darkMode = true;
  double _fpsLimit = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1F1C2C),
              Color(0xFF928DAB),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildSection('Audio', [
                      _buildSwitchTile('🎵', 'Music', _musicEnabled, (value) {
                        setState(() => _musicEnabled = value);
                      }),
                      _buildSwitchTile('🔊', 'Sound Effects', _soundEnabled, (value) {
                        setState(() => _soundEnabled = value);
                      }),
                    ]),
                    const SizedBox(height: 20),
                    _buildSection('Controls', [
                      _buildSwitchTile('📳', 'Haptic Feedback', _hapticsEnabled, (value) {
                        setState(() => _hapticsEnabled = value);
                      }),
                    ]),
                    const SizedBox(height: 20),
                    _buildSection('Graphics', [
                      _buildSliderTile('🎬', 'FPS Limit', _fpsLimit, 30, 120, (value) {
                        setState(() => _fpsLimit = value);
                      }),
                    ]),
                    const SizedBox(height: 20),
                    _buildSection('Display', [
                      _buildSwitchTile('🌙', 'Dark Mode', _darkMode, (value) {
                        setState(() => _darkMode = value);
                      }),
                    ]),
                    const SizedBox(height: 20),
                    _buildSection('About', [
                      _buildTile('ℹ️', 'Version', '1.0.0', null),
                      _buildTile('📧', 'Contact Us', 'support@fishingharbor.com', null),
                      _buildTile('⭐', 'Rate Us', 'Leave a review', () {}),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          const Expanded(
            child: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String emoji, String title, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Text(emoji, style: const TextStyle(fontSize: 24)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }

  Widget _buildSliderTile(
    String emoji,
    String title,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Text(emoji, style: const TextStyle(fontSize: 24)),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: Text(
            '${value.round()}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / 10).round(),
            activeColor: Colors.blue,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTile(String emoji, String title, String subtitle, VoidCallback? onTap) {
    return ListTile(
      leading: Text(emoji, style: const TextStyle(fontSize: 24)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: Colors.white54)
          : null,
      onTap: onTap,
    );
  }
}
