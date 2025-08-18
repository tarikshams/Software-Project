import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedTone = 'Playful';
  bool _notificationsEnabled = true;
  ThemeMode _themeMode = ThemeMode.light;

  Future<void> _saveProfileAndContinue() async {
    final String name = _nameController.text.trim();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasProfile', true);
    await prefs.setString('profile_name', name);
    await prefs.setString('tone', _selectedTone);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setString('theme', _themeMode == ThemeMode.dark ? 'dark' : 'light');

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to Elevate Emotion")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter your nickname:", style: TextStyle(fontSize: 18)),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Your nickname",
              ),
            ),
            const SizedBox(height: 20),

            const Text("Choose bot tone:", style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedTone,
              items: const [
                DropdownMenuItem(value: "Playful", child: Text("Playful")),
                DropdownMenuItem(value: "Romantic", child: Text("Romantic")),
                DropdownMenuItem(value: "Stress-free", child: Text("Stress-free")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTone = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text("Enable Notifications"),
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  _notificationsEnabled = val;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text("Choose Theme:", style: TextStyle(fontSize: 18)),
            Row(
              children: [
                ChoiceChip(
                  label: const Text("Light"),
                  selected: _themeMode == ThemeMode.light,
                  onSelected: (_) {
                    setState(() {
                      _themeMode = ThemeMode.light;
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text("Dark"),
                  selected: _themeMode == ThemeMode.dark,
                  onSelected: (_) {
                    setState(() {
                      _themeMode = ThemeMode.dark;
                    });
                  },
                ),
              ],
            ),
            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: _saveProfileAndContinue,
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
