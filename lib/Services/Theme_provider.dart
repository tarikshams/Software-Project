// filepath: lib/Services/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_getInitialTheme());

  static ThemeMode _getInitialTheme() {
    final box = Hive.box('userData');
    final theme = box.get('theme', defaultValue: 'light');
    return theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  void setTheme(String theme) {
    final box = Hive.box('userData');
    box.put('theme', theme);
    state = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }
}