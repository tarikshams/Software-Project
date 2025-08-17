import 'package:flutter/material.dart';
import 'Screens/home_screen.dart';
import 'Screens/chat_screen.dart';
import 'Screens/splash_screen.dart';
import 'Screens/onboarding_screen.dart';

void main() {
  runApp(const ElevateEmotionApp());
}

class ElevateEmotionApp extends StatelessWidget {
  const ElevateEmotionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elevate Emotion',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        // add the rest of your screens here
      },
    );
  }
}
