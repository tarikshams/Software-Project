import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openComingSoon(BuildContext context, String title) {
    Navigator.pushNamed(context, '/coming', arguments: title);
  }

  @override
  Widget build(BuildContext context) {
    final List<_Feature> features = [
      _Feature(title: 'Chat', icon: Icons.chat_bubble_rounded, onTap: (ctx) => Navigator.pushNamed(ctx, '/chat')),
      _Feature(title: 'Mood Tracker', icon: Icons.emoji_emotions_rounded, onTap: (ctx) => _openComingSoon(ctx, 'Mood Tracker')),
      _Feature(title: 'Breathing', icon: Icons.self_improvement, onTap: (ctx) => _openComingSoon(ctx, 'Breathing Exercises')),
      _Feature(title: 'Journal', icon: Icons.book_rounded, onTap: (ctx) => _openComingSoon(ctx, 'Journal')),
      _Feature(title: 'Insights', icon: Icons.insights_rounded, onTap: (ctx) => _openComingSoon(ctx, 'Insights')),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Elevate Emotion'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _BackgroundImage(),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(140, 0, 0, 0),
                  Color.fromARGB(160, 0, 0, 0),
                  Color.fromARGB(180, 0, 0, 0),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find your calm today',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.96),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: features.length,
                      itemBuilder: (context, index) {
                        final _Feature f = features[index];
                        return _FeatureCard(
                          title: f.title,
                          iconData: f.icon,
                          onTap: () => f.onTap(context),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // High-quality calming background (Unsplash). Replace with an asset later if desired.
    const String url =
        'https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=1974&auto=format&fit=crop';
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(Colors.black26, BlendMode.darken),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: (_, __, ___) => Container(color: Colors.black87),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.iconData,
    required this.onTap,
  });

  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Material(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.06),
                Colors.white.withValues(alpha: 0.02),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: colors.primary.withValues(alpha: 0.16),
                child: Icon(iconData, color: colors.primary),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature {
  const _Feature({required this.title, required this.icon, required this.onTap});
  final String title;
  final IconData icon;
  final void Function(BuildContext) onTap;
}
