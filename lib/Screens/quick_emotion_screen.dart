import 'package:flutter/material.dart';

class QuickEmotionScreen extends StatefulWidget {
  const QuickEmotionScreen({super.key});

  @override
  State<QuickEmotionScreen> createState() => _QuickEmotionScreenState();
}

class _QuickEmotionScreenState extends State<QuickEmotionScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  int _currentIndex = 0;
  final List<String> _favorites = [];

  final List<EmotionInteraction> _interactions = [
    EmotionInteraction(
      type: 'joke',
      text: 'Why did the scarecrow win an award? Because he was outstanding in his field! 🌾',
      emoji: '😄',
      color: const Color(0xFFFFD700),
    ),
    EmotionInteraction(
      type: 'flirty',
      text: 'Are you a parking ticket? Because you\'ve got FINE written all over you! 😉',
      emoji: '💕',
      color: const Color(0xFFFF69B4),
    ),
    EmotionInteraction(
      type: 'calming',
      text: 'Take a deep breath. You are safe. You are loved. You are enough. 💙',
      emoji: '🧘‍♀️',
      color: const Color(0xFF87CEEB),
    ),
    EmotionInteraction(
      type: 'motivational',
      text: 'You don\'t have to be perfect to be amazing. Every step forward is progress! ✨',
      emoji: '🌟',
      color: const Color(0xFF32CD32),
    ),
    EmotionInteraction(
      type: 'gratitude',
      text: 'Today, I am grateful for the little things: warm coffee, soft blankets, and you reading this. 🙏',
      emoji: '☕',
      color: const Color(0xFFDDA0DD),
    ),
    EmotionInteraction(
      type: 'silly',
      text: 'What do you call a bear with no teeth? A gummy bear! 🐻',
      emoji: '🤪',
      color: const Color(0xFFFFA500),
    ),
    EmotionInteraction(
      type: 'encouraging',
      text: 'You\'ve survived 100% of your bad days so far. You\'re doing great! 💪',
      emoji: '🔥',
      color: const Color(0xFFE67E22),
    ),
    EmotionInteraction(
      type: 'peaceful',
      text: 'In this moment, everything is okay. Let your shoulders relax and just be. 🌸',
      emoji: '🌸',
      color: const Color(0xFF98FB98),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _nextInteraction() {
    if (_currentIndex < _interactions.length - 1) {
      setState(() => _currentIndex++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _resetAnimations();
    }
  }

  void _previousInteraction() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _resetAnimations();
    }
  }

  void _resetAnimations() {
    _fadeController.reset();
    _scaleController.reset();
    _fadeController.forward();
    _scaleController.forward();
  }

  void _toggleFavorite() {
    final currentInteraction = _interactions[_currentIndex];
    setState(() {
      if (_favorites.contains(currentInteraction.text)) {
        _favorites.remove(currentInteraction.text);
      } else {
        _favorites.add(currentInteraction.text);
      }
    });

    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _favorites.contains(currentInteraction.text)
              ? 'Added to favorites! 💖'
              : 'Removed from favorites',
        ),
        backgroundColor: theme.colorScheme.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Quick Emotion',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_rounded, color: theme.colorScheme.primary),
            onPressed: _showFavorites,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Text(
                  '${_currentIndex + 1} of ${_interactions.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Row(
                  children: List.generate(
                    _interactions.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: index == _currentIndex ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == _currentIndex
                            ? theme.colorScheme.primary
                            : theme.dividerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main interaction card
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                _resetAnimations();
              },
              itemCount: _interactions.length,
              itemBuilder: (context, index) {
                final interaction = _interactions[index];
                return _buildInteractionCard(interaction, theme);
              },
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                if (_currentIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousInteraction,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: theme.colorScheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Previous',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (_currentIndex > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextInteraction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentIndex < _interactions.length - 1 ? 'Next' : 'Thanks!',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionCard(EmotionInteraction interaction, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: FadeTransition(
        opacity: _fadeController,
        child: ScaleTransition(
          scale: _scaleController,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  interaction.color.withOpacity(0.1),
                  interaction.color.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: interaction.color.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: interaction.color.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: interaction.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Center(
                    child: Text(interaction.emoji, style: const TextStyle(fontSize: 60)),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    interaction.text,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _favorites.contains(interaction.text)
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: _favorites.contains(interaction.text)
                            ? Colors.red
                            : theme.colorScheme.onSurfaceVariant,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _favorites.contains(interaction.text) ? 'Saved!' : 'Save this',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _favorites.contains(interaction.text)
                            ? Colors.red
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFavorites() {
    final theme = Theme.of(context);
    if (_favorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No favorites yet. Start saving interactions you love! 💖'),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Your Favorites',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...(_favorites.map((favorite) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite_rounded, color: Colors.red, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                favorite,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmotionInteraction {
  final String type;
  final String text;
  final String emoji;
  final Color color;

  EmotionInteraction({
    required this.type,
    required this.text,
    required this.emoji,
    required this.color,
  });
}
