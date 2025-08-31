import 'package:flutter/material.dart';

class WellnessExercisesScreen extends StatefulWidget {
  const WellnessExercisesScreen({super.key});

  @override
  State<WellnessExercisesScreen> createState() => _WellnessExercisesScreenState();
}

class _WellnessExercisesScreenState extends State<WellnessExercisesScreen> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _pulseController;
  bool _isBreathing = false;
  bool _isPlayingSound = false;
  String _selectedSound = 'meditation';
  final TextEditingController _journalController = TextEditingController();
  final List<String> _journalPrompts = [
    'What made you smile today?',
    'What\'s something you\'re grateful for right now?',
    'How are you feeling in this moment?',
    'What would make today better?',
    'What\'s something you\'re looking forward to?',
  ];
  int _currentPromptIndex = 0;

  final Map<String, String> _sounds = {
    'meditation': '🧘‍♀️ Meditation',
    'nature': '🌿 Nature Sounds',
    'ocean': '🌊 Ocean Waves',
    'rain': '🌧️ Gentle Rain',
    'forest': '🌲 Forest Ambience',
    'whitenoise': '⚪ White Noise',
  };

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _pulseController.dispose();
    _journalController.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isBreathing = true;
    });
    _breathingController.repeat();
    _pulseController.repeat();
  }

  void _stopBreathing() {
    setState(() {
      _isBreathing = false;
    });
    _breathingController.stop();
    _pulseController.stop();
  }

  void _toggleSound() {
    setState(() {
      _isPlayingSound = !_isPlayingSound;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isPlayingSound
              ? 'Playing ${_sounds[_selectedSound]} 🎵'
              : 'Sound stopped',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
          setState(() {
            _isPlayingSound = true;
          });
        });
      }
    });
  }

  void _nextPrompt() {
    setState(() {
      _currentPromptIndex = (_currentPromptIndex + 1) % _journalPrompts.length;
    });
  }

  void _saveJournal() {
    if (_journalController.text.trim().isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Journal entry saved! 📝'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          duration: const Duration(seconds: 2),
        ),
      );
      _journalController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final secondaryColor = theme.colorScheme.secondary;
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Wellness Exercises',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Breathing Exercise
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.air_rounded,
                        color: primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Breathing Exercise',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Breathing circle
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: AnimatedBuilder(
                      animation: _breathingController,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1.0 + (_pulseController.value * 0.3),
                                  child: Text(
                                    _isBreathing ? 'Breathe' : 'Ready',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Take slow, deep breaths. Inhale for 4 seconds, hold for 4, exhale for 4.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isBreathing ? _stopBreathing : _startBreathing,
                      icon: Icon(
                        _isBreathing ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      ),
                      label: Text(
                        _isBreathing ? 'Stop Breathing' : 'Start Breathing',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isBreathing
                            ? theme.colorScheme.error
                            : primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Journaling Exercise
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        color: secondaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Journaling',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Prompt
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: secondaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Today\'s Prompt:',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _journalPrompts[_currentPromptIndex],
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Text input
                  TextField(
                    controller: _journalController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Write your thoughts here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: secondaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: surfaceColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _nextPrompt,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: secondaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'New Prompt',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveJournal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Save Entry',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Visualization Exercise
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.visibility_rounded,
                        color: theme.colorScheme.tertiary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Visualization',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Visualization image placeholder
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.tertiary.withOpacity(0.2),
                          primaryColor.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.tertiary.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.landscape_rounded,
                            color: theme.colorScheme.tertiary,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Peaceful Scene',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Close your eyes and imagine yourself in a peaceful place. Feel the calmness and serenity.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Starting guided visualization... 🧘‍♀️'),
                            backgroundColor: theme.colorScheme.tertiary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.tertiary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Start Visualization',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Sound Exercise
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.music_note_rounded,
                        color: primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Ambient Sounds',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Sound selection grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _sounds.length,
                    itemBuilder: (context, index) {
                      final soundKey = _sounds.keys.elementAt(index);
                      final soundName = _sounds[soundKey]!;
                      final isSelected = _selectedSound == soundKey;

                      return GestureDetector(
                        onTap: () => _changeSound(soundKey),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryColor.withOpacity(0.1)
                                : surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? primaryColor
                                  : theme.dividerColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                soundName.split(' ')[0], // Emoji
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  soundName.split(' ').skip(1).join(' '),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? primaryColor
                                        : textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _toggleSound,
                      icon: Icon(
                        _isPlayingSound ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      ),
                      label: Text(
                        _isPlayingSound ? 'Stop Sound' : 'Play Sound',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPlayingSound
                            ? theme.colorScheme.error
                            : primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}