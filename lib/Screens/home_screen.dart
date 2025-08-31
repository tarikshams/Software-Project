import 'package:flutter/material.dart';

/// =========================
/// Home Screen with Animated Theme & Mood Selection
/// =========================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0; // BottomNavigationBar selected index
  String _selectedMood = '😊'; // Current mood selection
  final String _nickname = 'Friend'; // User nickname (can be dynamic)

  /// List of moods to display
  final List<String> _moods = ['😊', '😌', '😔', '😤', '😴', '🤗', '😌', '😇'];

  /// Animation controller for mood selection scaling
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// =========================
  /// Handle BottomNavigationBar taps
  /// =========================
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 1: // Chat
        Navigator.pushNamed(context, '/chat');
        break;
      case 2: // Mood History
        Navigator.pushNamed(context, '/mood-history');
        break;
      case 3: // Profile/Settings
        Navigator.pushNamed(context, '/settings-profile');
        break;
    }
  }

  /// =========================
  /// Handle mood selection with animation
  /// =========================
  void _onMoodSelected(String mood) async {
    _animationController.forward(from: 0.0); // start animation
    setState(() => _selectedMood = mood);
    // TODO: Save mood to database or local storage
    await Future.delayed(const Duration(milliseconds: 200));
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge!.color;
    final cardBackground = theme.cardColor;

    final List<_Feature> features = [
      _Feature(
        title: 'Chat',
        icon: Icons.chat_bubble_rounded,
        color: Colors.blue,
        onTap: (ctx) => Navigator.pushNamed(ctx, '/chat'),
      ),
      _Feature(
        title: 'Quick Emotion\nInteraction',
        icon: Icons.psychology_rounded,
        color: Colors.purple,
        onTap: (ctx) => Navigator.pushNamed(ctx, '/quick-emotion'),
      ),
      _Feature(
        title: 'Daily Uplift',
        icon: Icons.wb_sunny_rounded,
        color: Colors.orange,
        onTap: (ctx) => Navigator.pushNamed(ctx, '/daily-uplift'),
      ),
      _Feature(
        title: 'Wellness\nExercises',
        icon: Icons.self_improvement_rounded,
        color: Colors.green,
        onTap: (ctx) => Navigator.pushNamed(ctx, '/wellness-exercises'),
      ),
      _Feature(
        title: 'Mood History',
        icon: Icons.timeline_rounded,
        color: Colors.indigo,
        onTap: (ctx) => Navigator.pushNamed(ctx, '/mood-history'),
      ),
      _Feature(
        title: 'Emergency\nSupport',
        icon: Icons.emergency_rounded,
        color: Colors.red,
        onTap: (ctx) => Navigator.pushNamed(ctx, '/emergency-support'),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Section
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi $_nickname,',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'How are you today?',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: theme.primaryColorLight,
                    child: Icon(
                      Icons.person_rounded,
                      color: theme.primaryColorDark,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              /// Mood Selection Section
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select your mood:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _moods.map((mood) {
                        final isSelected = mood == _selectedMood;
                        return GestureDetector(
                          onTap: () => _onMoodSelected(mood),
                          child: ScaleTransition(
                            scale: isSelected ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.primaryColorLight
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: isSelected
                                      ? theme.primaryColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  mood,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              /// Feature Grid Section
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    final feature = features[index];
                    return _FeatureCard(
                      title: feature.title,
                      iconData: feature.icon,
                      color: feature.color,
                      onTap: () => feature.onTap(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      /// Bottom Navigation Bar with Animated Theme
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: cardBackground,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: theme.textTheme.bodySmall?.color,
          backgroundColor: cardBackground,
          elevation: 8,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

/// Feature Card Widget
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.iconData,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(iconData, color: color, size: 28),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Feature Model
class _Feature {
  const _Feature({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final void Function(BuildContext) onTap;
}
