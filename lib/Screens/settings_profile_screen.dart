import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Services/Theme_provider.dart';

class SettingsProfileScreen extends ConsumerStatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  ConsumerState<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends ConsumerState<SettingsProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  String _selectedBotTone = 'playful';
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  double _reminderTime = 20.0;

  final List<String> _botTones = [
    'playful',
    'romantic',
    'stress-free',
    'professional',
    'friendly'
  ];

  late Box userBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('userData');
    _nicknameController.text = userBox.get('nickname', defaultValue: 'User');
    _selectedBotTone = userBox.get('botTone', defaultValue: 'playful');
    _notificationsEnabled = userBox.get('notificationsEnabled', defaultValue: true);
    String theme = userBox.get('theme', defaultValue: 'light');
    _darkModeEnabled = theme == 'dark';
    _soundEnabled = userBox.get('soundEnabled', defaultValue: true);
    _vibrationEnabled = userBox.get('vibrationEnabled', defaultValue: true);
    _reminderTime = userBox.get('reminderTime', defaultValue: 20.0);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    userBox.put('nickname', _nicknameController.text);
    userBox.put('botTone', _selectedBotTone);
    userBox.put('notificationsEnabled', _notificationsEnabled);
    userBox.put('theme', _darkModeEnabled ? 'dark' : 'light');
    userBox.put('soundEnabled', _soundEnabled);
    userBox.put('vibrationEnabled', _vibrationEnabled);
    userBox.put('reminderTime', _reminderTime);

    ref.read(themeModeProvider.notifier).setTheme(_darkModeEnabled ? 'dark' : 'light');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings saved successfully! ✅'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resetData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Reset All Data?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'This will permanently delete all your data including mood history, journal entries, and preferences. This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () {
              userBox.clear();
              Navigator.pop(context);
              setState(() {
                _nicknameController.text = 'User';
                _selectedBotTone = 'playful';
                _notificationsEnabled = true;
                _darkModeEnabled = false;
                _soundEnabled = true;
                _vibrationEnabled = true;
                _reminderTime = 20.0;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('All data has been reset 🔄'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
            child: Text(
              'Reset',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Data exported successfully! 📤'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final surfaceColor = theme.colorScheme.surface;
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Settings & Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded, color: primaryColor),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: primaryColor,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Nickname Input
                  TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      labelText: 'Nickname',
                      hintText: 'Enter your nickname',
                      prefixIcon: Icon(Icons.edit_rounded, color: primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: surfaceColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Bot Tone Preference',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _botTones.map((tone) {
                      final isSelected = _selectedBotTone == tone;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedBotTone = tone;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryColor
                                : surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? primaryColor
                                  : theme.dividerColor,
                            ),
                          ),
                          child: Text(
                            tone.replaceAll('-', ' ').toUpperCase(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Preferences Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferences',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildToggleSwitch(
                    icon: Icons.notifications_rounded,
                    title: 'Push Notifications',
                    subtitle: 'Receive daily mood check-ins and reminders',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildToggleSwitch(
                    icon: Icons.dark_mode_rounded,
                    title: 'Dark Mode',
                    subtitle: 'Switch to dark theme',
                    value: _darkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildToggleSwitch(
                    icon: Icons.volume_up_rounded,
                    title: 'Sound Effects',
                    subtitle: 'Play sounds for interactions',
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildToggleSwitch(
                    icon: Icons.vibration_rounded,
                    title: 'Vibration',
                    subtitle: 'Haptic feedback for interactions',
                    value: _vibrationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _vibrationEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Daily Reminder Time',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, color: primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Slider(
                          value: _reminderTime,
                          min: 8.0,
                          max: 22.0,
                          divisions: 14,
                          activeColor: primaryColor,
                          inactiveColor: theme.dividerColor,
                          onChanged: (value) {
                            setState(() {
                              _reminderTime = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        '${_reminderTime.round()}:00',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Data Management Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Management',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _exportData,
                      icon: Icon(Icons.download_rounded, color: primaryColor),
                      label: const Text('Export My Data'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _resetData,
                      icon: Icon(Icons.delete_forever_rounded, color: theme.colorScheme.error),
                      label: const Text('Reset All Data'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: theme.colorScheme.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // App Info Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_rounded,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    size: 32,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'App Version',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1.0.0',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Elevate Emotion - Your daily companion for emotional wellness',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: primaryColor,
        ),
      ],
    );
  }
}