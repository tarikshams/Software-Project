import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String title = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'Feature';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction_rounded, size: 72),
            const SizedBox(height: 12),
            Text(
              '$title is coming soon!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('We are working hard to bring this to you.'),
          ],
        ),
      ),
    );
  }
} 