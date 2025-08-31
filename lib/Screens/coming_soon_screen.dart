import 'package:flutter/material.dart';

class ComingSoonScreen extends StatefulWidget {
  const ComingSoonScreen({super.key});

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _textController;

  @override
  void initState() {
    super.initState();

    // Icon bounce animation
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Fade-in text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    // Check if navigating to Mood History
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final title = ModalRoute.of(context)?.settings.arguments as String? ?? 'Coming Soon';
      if (title == 'Mood History') {
        Navigator.pushReplacementNamed(context, '/mood-history');
      }
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String title = ModalRoute.of(context)?.settings.arguments as String? ?? 'Coming Soon';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Animated icon
              ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.1).animate(
                  CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
                ),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE67E22).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(Icons.construction_rounded, size: 60, color: Color(0xFFE67E22)),
                ),
              ),

              const SizedBox(height: 32),

              // Animated title text
              FadeTransition(
                opacity: _textController,
                child: Text(
                  '$title is coming soon!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Animated description
              FadeTransition(
                opacity: _textController,
                child: const Text(
                  'We\'re working hard to bring you this amazing feature. Stay tuned for updates!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF718096),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
