import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[
    ChatMessage(
      text: "Hi! I'm Elevate, your mood buddy. How are you feeling today?",
      fromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _botTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend(String rawText) {
    final String text = rawText.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        fromUser: true,
        timestamp: DateTime.now(),
      ));
      _botTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 600), () {
      final String reply = _generateBotReply(text);
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: reply,
          fromUser: false,
          timestamp: DateTime.now(),
        ));
        _botTyping = false;
      });
      _scrollToBottom();
    });
  }

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

  String _generateBotReply(String userText) {
    final String lower = userText.toLowerCase();
    if (lower.contains('stress') || lower.contains('anxious') || lower.contains('anxiety')) {
      return "I hear you. Let's try a quick 3-breath reset: inhale 4, hold 2, exhale 6. Want a gentle exercise?";
    }
    if (lower.contains('sad') || lower.contains('down') || lower.contains('upset')) {
      return "I'm here for you. Three things that went okay today? Even tiny wins count. Want a journaling prompt?";
    }
    if (lower.contains('happy') || lower.contains('great') || lower.contains('good')) {
      return "Love that energy! What's one thing we can do to keep that momentum?";
    }
    if (lower.contains('angry') || lower.contains('mad') || lower.contains('frustrated')) {
      return "That sounds tough. Try labeling the emotion 1–10 and a 60‑second grounding. Want to try now?";
    }
    return "Thanks for sharing. Would you like a breathing exercise, a short reflection, or a playful prompt?";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              child: const Icon(Icons.self_improvement, color: Colors.deepPurple),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Elevate', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('Online', style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Options',
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _messages.length + (_botTyping ? 1 : 0),
              itemBuilder: (context, index) {
                final bool isTypingTile = _botTyping && index == _messages.length;
                if (isTypingTile) {
                  return const _TypingIndicator();
                }
                final ChatMessage message = _messages[index];
                return Align(
                  alignment: message.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _MessageBubble(message: message),
                  ),
                );
              },
            ),
          ),
          _QuickReplies(onSelect: (value) => _handleSend(value)),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: _InputBar(
              controller: _textController,
              onSend: _handleSend,
            ),
          ),
        ],
      ),
    );
  }
}

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

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final bool fromUser = message.fromUser;
    final ColorScheme colors = Theme.of(context).colorScheme;

    final Color bubbleColor = fromUser
        ? colors.primary
        : colors.surfaceContainerHighest;

    final Color textColor = fromUser ? Colors.white : colors.onSurfaceVariant;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Container(
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(fromUser ? 16 : 4),
            bottomRight: Radius.circular(fromUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: textColor, fontSize: 15, height: 1.3),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final int hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final String minute = twoDigits(time.minute);
    final String period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

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
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color dotColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AnimatedDot(controller: _controller, delay: 0, color: dotColor),
            const SizedBox(width: 4),
            _AnimatedDot(controller: _controller, delay: 0.2, color: dotColor),
            const SizedBox(width: 4),
            _AnimatedDot(controller: _controller, delay: 0.4, color: dotColor),
          ],
        ),
      ),
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  const _AnimatedDot({required this.controller, required this.delay, required this.color});

  final AnimationController controller;
  final double delay;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double t = (controller.value + delay) % 1.0;
        final double scale = 0.6 + (t < 0.5 ? t : 1.0 - t) * 0.8;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSend});

  final TextEditingController controller;
  final void Function(String text) onSend;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a message…',
                ),
                onSubmitted: onSend,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: 'Send',
            child: CircleAvatar(
              radius: 22,
              backgroundColor: colors.primary,
              child: IconButton(
                onPressed: () => onSend(controller.text),
                icon: const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickReplies extends StatelessWidget {
  const _QuickReplies({required this.onSelect});

  final void Function(String value) onSelect;

  @override
  Widget build(BuildContext context) {
    final List<String> replies = <String>[
      'I feel stressed',
      'Feeling sad',
      'I am happy today',
      'Feeling angry',
      'Give me an exercise',
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final String label = replies[index];
          return ActionChip(
            label: Text(label),
            onPressed: () => onSelect(label),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: replies.length,
      ),
    );
  }
}
