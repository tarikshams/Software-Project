import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../Services/Theme_provider.dart'; // Make sure path is correct

// ===========================
// Chat Screen (Main Widget)
// ===========================
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with TickerProviderStateMixin {
  // ---------------------------
  // Variables & Controllers
  // ---------------------------
  final List<ChatMessage> _messages = <ChatMessage>[
    ChatMessage(
      text: "Hi! I'm Elevate, your emotional wellness companion. 🌟",
      fromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      text:
          "I'm here to support you through your emotional journey. How are you feeling today?",
      fromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
  ];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _botTyping = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;

  // ---------------------------
  // Init State
  // ---------------------------
  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Initial bot message with delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text:
                  "Feel free to use the quick reply buttons below, or type your own message. I'm here to help! 💙",
              fromUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // ===========================
  // Send & Bot Reply Handling
  // ===========================
  void _handleSend(String rawText) {
    final String text = rawText.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(
        ChatMessage(text: text, fromUser: true, timestamp: DateTime.now()),
      );
      _botTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    // Generate bot reply after delay
    Future.delayed(const Duration(milliseconds: 600), () {
      final String reply = _generateBotReply(text);

      // Save mood if applicable
      _saveMoodFromMessage(text);

      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(text: reply, fromUser: false, timestamp: DateTime.now()),
        );
        _botTyping = false;
      });

      _scrollToBottom();
      _fadeController.forward().then((_) => _fadeController.reset());
      _slideController.forward().then((_) => _slideController.reset());
    });
  }

  // ---------------------------
  // Scroll to bottom
  // ---------------------------
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ===========================
  // Bot Reply Generator
  // ===========================
  String _generateBotReply(String userText) {
    final String lower = userText.toLowerCase();

    if (lower.contains('stress') ||
        lower.contains('anxious') ||
        lower.contains('anxiety')) {
      final List<String> responses = [
        "I hear you. Let's try a quick 3-breath reset: inhale 4, hold 2, exhale 6. Want a gentle exercise?",
        "Stress can be overwhelming. Remember to be kind to yourself. Would you like a quick grounding exercise?",
        "It's okay to feel stressed. Let's take a moment together. Want to try some deep breathing?",
      ];
      return responses[DateTime.now().millisecond % responses.length];
    }

    if (lower.contains('sad') ||
        lower.contains('down') ||
        lower.contains('upset')) {
      final List<String> responses = [
        "I'm here for you. Three things that went okay today? Even tiny wins count. Want a journaling prompt?",
        "It's okay to feel sad. You're not alone in this. Would you like to talk about what's on your mind?",
        "I can sense you're having a tough time. Remember, this feeling will pass. Want to try something uplifting?",
      ];
      return responses[DateTime.now().millisecond % responses.length];
    }

    if (lower.contains('happy') ||
        lower.contains('great') ||
        lower.contains('good')) {
      final List<String> responses = [
        "Love that energy! What's one thing we can do to keep that momentum?",
        "That's wonderful! Your positive energy is contagious. Want to share what made you feel this way?",
        "I'm so glad you're feeling good! Let's build on this positive moment together.",
      ];
      return responses[DateTime.now().millisecond % responses.length];
    }

    if (lower.contains('angry') ||
        lower.contains('mad') ||
        lower.contains('frustrated')) {
      final List<String> responses = [
        "That sounds tough. Try labeling the emotion 1–10 and a 60‑second grounding. Want to try now?",
        "Anger is a valid emotion. Let's work through it together. Would you like a calming exercise?",
        "I understand you're frustrated. It's okay to feel this way. Want to try some anger management techniques?",
      ];
      return responses[DateTime.now().millisecond % responses.length];
    }

    final List<String> defaultResponses = [
      "Thanks for sharing. Would you like a breathing exercise, a short reflection, or a playful prompt?",
      "I appreciate you opening up to me. How can I best support you right now?",
      "Thank you for trusting me with your thoughts. What would be most helpful for you today?",
      "I'm here to listen and support you. Would you like to explore some wellness exercises together?",
    ];
    return defaultResponses[DateTime.now().millisecond %
        defaultResponses.length];
  }

  // ===========================
  // Save mood to Hive (Mood Tracker Integration)
  // ===========================
  void _saveMoodFromMessage(String text) {
  final moodBox = Hive.box('moodHistory');
  String? mood;

  final lower = text.toLowerCase();
  if (lower.contains('stressed') || lower.contains('stress') || lower.contains('anxious')) {
    mood = 'Stressed';
  } else if (lower.contains('sad') || lower.contains('down') || lower.contains('upset')) {
    mood = 'Sad';
  } else if (lower.contains('happy') || lower.contains('great') || lower.contains('good')) {
    mood = 'Happy';
  } else if (lower.contains('angry') || lower.contains('mad') || lower.contains('frustrated')) {
    mood = 'Angry';
  } else {
    mood = 'Neutral';
  }

  moodBox.add({
    'mood': mood,
    'timestamp': DateTime.now().toIso8601String(),
  });
}

  // ===========================
  // Build UI
  // ===========================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(theme),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_botTyping ? 1 : 0),
              itemBuilder: (context, index) {
                final bool isTypingTile =
                    _botTyping && index == _messages.length;
                if (isTypingTile) return const _TypingIndicator();

                final ChatMessage message = _messages[index];
                return Align(
                  alignment: message.fromUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: _MessageBubble(
                      message: message,
                      isNewBotMessage:
                          !message.fromUser && index == _messages.length - 1,
                      fadeController: _fadeController,
                      slideController: _slideController,
                    ),
                  ),
                );
              },
            ),
          ),
          // Quick Replies
          _QuickReplies(onSelect: (value) => _handleSend(value)),
          const Divider(height: 1),
          // Input bar
          SafeArea(
            top: false,
            child: _InputBar(controller: _textController, onSend: _handleSend),
          ),
        ],
      ),
    );
  }

  // ===========================
  // AppBar Widget
  // ===========================
  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.self_improvement_rounded,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Elevate',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge!.color,
                  fontSize: 18,
                ),
              ),
              Text(
                'Online',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodyMedium!.color,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Options',
          onPressed: () {},
          icon: Icon(Icons.more_vert, color: theme.textTheme.bodyMedium!.color),
        ),
      ],
    );
  }
}

// ===========================
// Models & Widgets
// ===========================
class ChatMessage {
  ChatMessage({
    required this.text,
    required this.fromUser,
    required this.timestamp,
  });

  final String text;
  final bool fromUser;
  final DateTime timestamp;
}

// ---------------------------
// Message Bubble
// ---------------------------
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    this.isNewBotMessage = false,
    this.fadeController,
    this.slideController,
  });

  final ChatMessage message;
  final bool isNewBotMessage;
  final AnimationController? fadeController;
  final AnimationController? slideController;

  @override
  Widget build(BuildContext context) {
    final bool fromUser = message.fromUser;
    final theme = Theme.of(context);

    final Color bubbleColor = fromUser
        ? theme.colorScheme.primary
        : theme.colorScheme.surface;
    final Color textColor = fromUser
        ? Colors.white
        : theme.textTheme.bodyLarge!.color!;
    final Color borderColor = fromUser
        ? theme.colorScheme.primary
        : theme.colorScheme.primary.withOpacity(0.2);

    Widget bubble = Container(
      constraints: const BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(fromUser ? 20 : 6),
          bottomRight: Radius.circular(fromUser ? 6 : 20),
        ),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!fromUser) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology_rounded,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Elevate',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Text(
            message.text,
            style: TextStyle(color: textColor, fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              _formatTime(message.timestamp),
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 11),
            ),
          ),
        ],
      ),
    );

    if (isNewBotMessage && fadeController != null && slideController != null) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: fadeController!, curve: Curves.easeOut),
        ),
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: slideController!,
                  curve: Curves.easeOutCubic,
                ),
              ),
          child: bubble,
        ),
      );
    }

    return bubble;
  }

  String _formatTime(DateTime time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final int hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final String minute = twoDigits(time.minute);
    final String period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

// ---------------------------
// Typing Indicator
// ---------------------------
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(6),
          ),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.psychology_rounded,
                size: 14,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            _AnimatedDot(controller: _controller, delay: 0),
            const SizedBox(width: 4),
            _AnimatedDot(controller: _controller, delay: 0.3),
            const SizedBox(width: 4),
            _AnimatedDot(controller: _controller, delay: 0.6),
          ],
        ),
      ),
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  const _AnimatedDot({required this.controller, required this.delay});

  final AnimationController controller;
  final double delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double t = (controller.value + delay) % 1.0;
        final double scale = 0.7 + (t < 0.5 ? t : 1.0 - t) * 0.6;
        final double opacity = 0.4 + (t < 0.5 ? t : 1.0 - t) * 0.6;
        return Transform.scale(
          scale: scale,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Color(0xFFE67E22),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ---------------------------
// Input Bar
// ---------------------------
class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSend});

  final TextEditingController controller;
  final void Function(String text) onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: InputBorder.none,

                  hintText: 'Type a message…',
                  hintStyle: TextStyle(
                    color: theme.textTheme.bodyMedium!.color!.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
                onSubmitted: onSend,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyLarge!.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(28),
            ),
            child: IconButton(
              onPressed: () => onSend(controller.text),
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------
// Quick Replies Widget
// ---------------------------
class _QuickReplies extends StatelessWidget {
  const _QuickReplies({required this.onSelect});

  final void Function(String value) onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<String> replies = <String>[
      'I feel stressed 😰',
      'Feeling sad today 😔',
      'I am happy! 😊',
      'Feeling angry 😤',
      'Give me an exercise 🧘‍♀️',
      'I need support 💙',
      'Tell me a joke 😄',
      'Help me relax 🌸',
    ];

    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: replies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final String label = replies[index];
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelect(label),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge!.color,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
