import 'package:flutter/material.dart';
import 'Screens/home_screen.dart';
import 'Screens/chat_screen.dart';
import 'Screens/splash_screen.dart';
import 'Screens/onboarding_screen.dart';
import 'Screens/coming_soon_screen.dart';

void main() {
  runApp(const ElevateEmotionApp());
}

class ElevateEmotionApp extends StatelessWidget {
  const ElevateEmotionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elevate Emotion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        '/coming': (context) => const ComingSoonScreen(),
        // add the rest of your screens here
      },
    );
  }
}
