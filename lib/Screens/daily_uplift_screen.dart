import 'package:flutter/material.dart';

// ===========================
// Daily Uplift Screen
// ===========================
class DailyUpliftScreen extends StatefulWidget {
  const DailyUpliftScreen({super.key});

  @override
  State<DailyUpliftScreen> createState() => _DailyUpliftScreenState();
}

class _DailyUpliftScreenState extends State<DailyUpliftScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  bool _isPlayingSound = false;
  String _selectedSound = 'rain';

  final List<DailyQuote> _quotes = [
    DailyQuote(
      text: 'Every day is a new beginning. Take a deep breath and start again.',
      author: 'Anonymous',
      category: 'motivation',
      color: const Color(0xFFE67E22),
    ),
    DailyQuote(
      text: 'You are never too old to set another goal or to dream a new dream.',
      author: 'C.S. Lewis',
      category: 'inspiration',
      color: const Color(0xFF9B59B6),
    ),
    DailyQuote(
      text: 'The only way to do great work is to love what you do.',
      author: 'Steve Jobs',
      category: 'success',
      color: const Color(0xFF3498DB),
    ),
    DailyQuote(
      text: 'Happiness is not something ready-made. It comes from your own actions.',
      author: 'Dalai Lama',
      category: 'happiness',
      color: const Color(0xFF2ECC71),
    ),
    DailyQuote(
      text: 'Believe you can and you\'re halfway there.',
      author: 'Theodore Roosevelt',
      category: 'confidence',
      color: const Color(0xFFFF6B6B),
    ),
    DailyQuote(
      text: 'Peace comes from within. Do not seek it without.',
      author: 'Buddha',
      category: 'peace',
      color: const Color(0xFF87CEEB),
    ),
    DailyQuote(
      text: 'The future belongs to those who believe in the beauty of their dreams.',
      author: 'Eleanor Roosevelt',
      category: 'dreams',
      color: const Color(0xFFFFD700),
    ),
  ];

  final Map<String, String> _sounds = {
    'rain': '🌧️ Gentle Rain',
    'ocean': '🌊 Ocean Waves',
    'forest': '🌲 Forest Birds',
    'fireplace': '🔥 Crackling Fire',
    'whitenoise': '⚪ White Noise',
    'meditation': '🧘‍♀️ Meditation Music',
  };

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  DailyQuote get _todayQuote {
    final today = DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year, 1, 1)).inDays;
    return _quotes[dayOfYear % _quotes.length];
  }

  void _toggleSound() {
    setState(() => _isPlayingSound = !_isPlayingSound);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isPlayingSound
            ? 'Playing ${_sounds[_selectedSound]} 🎵'
            : 'Sound stopped'),
        backgroundColor: const Color(0xFFE67E22),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _changeSound(String sound) {
    setState(() {
      _selectedSound = sound;
      if (_isPlayingSound) {
        _isPlayingSound = false;
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() => _isPlayingSound = true);
        });
      }
    });
  }

  void _shareQuote() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quote shared! 📱'),
        backgroundColor: Color(0xFF2ECC71),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quote = _todayQuote;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Daily Uplift', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Color(0xFFE67E22)),
            onPressed: _shareQuote,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Quote Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: FadeTransition(
                opacity: _fadeController,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
                      .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic)),
                  child: _QuoteCard(quote: quote),
                ),
              ),
            ),

            // Background Sounds Section
            _SoundSelectionSection(
              sounds: _sounds,
              selectedSound: _selectedSound,
              isPlaying: _isPlayingSound,
              onSelect: _changeSound,
              onToggle: _toggleSound,
            ),

            // Daily Affirmation
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: const [
                    Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFD700), size: 32),
                    SizedBox(height: 16),
                    Text('Today\'s Affirmation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    SizedBox(height: 12),
                    Text(
                      'I am worthy of love, respect, and happiness. I choose to be kind to myself today.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Quote Card Widget
class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote});
  final DailyQuote quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [quote.color.withOpacity(0.1), quote.color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: quote.color.withOpacity(0.3), width: 2),
        boxShadow: [BoxShadow(color: quote.color.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: quote.color.withOpacity(0.2), borderRadius: BorderRadius.circular(40)),
            child: Icon(_getQuoteIcon(quote.category), color: quote.color, size: 40),
          ),
          const SizedBox(height: 24),
          Text('"${quote.text}"', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, height: 1.4)),
          const SizedBox(height: 20),
          Text('— ${quote.author}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: quote.color)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: quote.color.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text(quote.category.toUpperCase(), style: TextStyle(color: quote.color, fontWeight: FontWeight.w600, letterSpacing: 1, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  IconData _getQuoteIcon(String category) {
    switch (category) {
      case 'motivation': return Icons.trending_up_rounded;
      case 'inspiration': return Icons.lightbulb_rounded;
      case 'success': return Icons.star_rounded;
      case 'happiness': return Icons.sentiment_very_satisfied_rounded;
      case 'confidence': return Icons.psychology_rounded;
      case 'peace': return Icons.self_improvement_rounded;
      case 'dreams': return Icons.nightlight_rounded;
      default: return Icons.format_quote_rounded;
    }
  }
}

// Sound Selection Section Widget
class _SoundSelectionSection extends StatelessWidget {
  const _SoundSelectionSection({required this.sounds, required this.selectedSound, required this.isPlaying, required this.onSelect, required this.onToggle});

  final Map<String, String> sounds;
  final String selectedSound;
  final bool isPlaying;
  final void Function(String) onSelect;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [Icon(Icons.music_note_rounded, color: Color(0xFFE67E22)), SizedBox(width: 12), Text('Background Sounds', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))]),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.5),
              itemCount: sounds.length,
              itemBuilder: (context, index) {
                final key = sounds.keys.elementAt(index);
                final value = sounds[key]!;
                final selected = selectedSound == key;
                return GestureDetector(
                  onTap: () => onSelect(key),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFE67E22) : theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: selected ? const Color(0xFFE67E22) : theme.colorScheme.primary.withOpacity(0.2)),
                    ),
                    alignment: Alignment.center,
                    child: Text(value, style: TextStyle(color: selected ? Colors.white : theme.textTheme.bodyLarge!.color, fontWeight: FontWeight.w600)),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: onToggle,
                icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                label: Text(isPlaying ? 'Stop' : 'Play'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE67E22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================
// DailyQuote Model
// ===========================
class DailyQuote {
  DailyQuote({
    required this.text,
    required this.author,
    required this.category,
    required this.color,
  });

  final String text;
  final String author;
  final String category;
  final Color color;
}
