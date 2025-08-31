import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Screens
import 'Screens/home_screen.dart';
import 'Screens/chat_screen.dart';
import 'Screens/splash_screen.dart';
import 'Screens/onboarding_screen.dart';
import 'Screens/coming_soon_screen.dart';
import 'Screens/mood_history_screen.dart';
import 'Screens/quick_emotion_screen.dart';
import 'Screens/daily_uplift_screen.dart';
import 'Screens/wellness_exercises_screen.dart';
import 'Screens/settings_profile_screen.dart';
import 'Screens/emergency_support_screen.dart';

// Services / Providers
import 'Services/Theme_provider.dart';
// <-- Daily Uplift provider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  // Open required Hive boxes
  await Hive.openBox('userData');
  await Hive.openBox('moodHistory');
  await Hive.openBox('dailyUplift');
  await Hive.openBox('exerciseProgress');
  await Hive.openBox('emergencyContacts');

  // Run app with Riverpod
  runApp(const ProviderScope(child: ElevateEmotionApp()));
}

class ElevateEmotionApp extends ConsumerWidget {
  const ElevateEmotionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme provider
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Elevate Emotion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode, // Controlled by Riverpod
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        '/coming': (context) => const ComingSoonScreen(),
        '/mood-history': (context) => const MoodHistoryScreen(),
        '/quick-emotion': (context) => const QuickEmotionScreen(),
        '/daily-uplift': (context) => const DailyUpliftScreen(),
        '/wellness-exercises': (context) => const WellnessExercisesScreen(),
        '/settings-profile': (context) => const SettingsProfileScreen(),
        '/emergency-support': (context) => const EmergencySupportScreen(),
      },
    );
  }
}
