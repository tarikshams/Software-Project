// filepath: lib/Screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../Services/theme_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  String? _selectedTone;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() {
    final box = Hive.box('userData');
    final savedNickname = box.get('nickname');
    final savedTone = box.get('tone');
    if (savedNickname != null) {
      _nicknameController.text = savedNickname;
    }
    if (savedTone != null) {
      setState(() {
        _selectedTone = savedTone;
      });
    }
  }

  void _saveData() {
    final box = Hive.box('userData');
    box.put('nickname', _nicknameController.text.trim());
    if (_selectedTone != null) {
      box.put('tone', _selectedTone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch current theme mode
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Welcome to Elevate Emotion 🌟",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Let's personalize your experience",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 30),

              // Nickname Input
              Text(
                "What's your nickname?",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: "Enter your nickname",
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Bot Tone Selection
              Text(
                "Choose a bot tone",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ["Playful", "Romantic", "Stress-free"].map((tone) {
                  final isSelected = _selectedTone == tone;
                  return ChoiceChip(
                    label: Text(tone),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTone = tone;
                      });
                    },
                    selectedColor: colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),

              // Theme Selection
              Text(
                "Choose your theme",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ["Light", "Dark"].map((themeChoice) {
                  final isSelected = (themeChoice == "Dark" && isDarkMode) ||
                      (themeChoice == "Light" && !isDarkMode);

                  return ChoiceChip(
                    label: Text(themeChoice),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        ref
                            .read(themeModeProvider.notifier)
                            .setTheme(themeChoice.toLowerCase());
                      }
                    },
                    selectedColor: colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _saveData(); // save nickname + tone
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
