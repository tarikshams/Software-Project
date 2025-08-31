import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

// ---------------------------
// Daily Uplift Provider
// ---------------------------
final dailyUpliftProvider =
    StateNotifierProvider<DailyUpliftNotifier, AsyncValue<String>>(
        (ref) => DailyUpliftNotifier());

class DailyUpliftNotifier extends StateNotifier<AsyncValue<String>> {
  DailyUpliftNotifier() : super(const AsyncValue.loading()) {
    loadDailyUplift();
  }

  final String _apiUrl = 'https://type.fit/api/quotes'; // Example API

  Future<void> loadDailyUplift() async {
    try {
      // Step 1: Check Hive for today's saved uplift
      final box = Hive.box('dailyUplift');
      final todayKey = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD

      if (box.containsKey(todayKey)) {
        // Found offline
        state = AsyncValue.data(box.get(todayKey));
        return;
      }

      // Step 2: Fetch from API if not found offline
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          // Pick a random quote
          final randomIndex = DateTime.now().millisecondsSinceEpoch % data.length;
          final quoteData = data[randomIndex];
          final String quote = quoteData['text'] ?? 'Have a great day!';
          
          // Save to Hive
          box.put(todayKey, quote);
          
          // Update state
          state = AsyncValue.data(quote);
          return;
        }
      }

      // Fallback if API fails
      state = const AsyncValue.data('Stay positive and keep going! 💫');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
