import 'package:flutter/material.dart';

class EmergencySupportScreen extends StatefulWidget {
  const EmergencySupportScreen({super.key});

  @override
  State<EmergencySupportScreen> createState() => _EmergencySupportScreenState();
}

class _EmergencySupportScreenState extends State<EmergencySupportScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  int _currentGroundingStep = 0;

  final List<String> _groundingSteps = [
    'Name 5 things you can see',
    'Name 4 things you can touch',
    'Name 3 things you can hear',
    'Name 2 things you can smell',
    'Name 1 thing you can taste',
  ];

  final List<EmergencyContact> _emergencyContacts = [
    EmergencyContact(
      name: 'National Suicide Prevention Lifeline',
      number: '988',
      description: '24/7 crisis support',
      color: Colors.red,
      icon: Icons.phone_in_talk_rounded,
    ),
    EmergencyContact(
      name: 'Crisis Text Line',
      number: 'Text HOME to 741741',
      description: 'Text-based crisis support',
      color: Colors.blue,
      icon: Icons.sms_rounded,
    ),
    EmergencyContact(
      name: 'Emergency Services',
      number: '911',
      description: 'Immediate emergency help',
      color: Colors.orange,
      icon: Icons.emergency_rounded,
    ),
    EmergencyContact(
      name: 'SAMHSA Helpline',
      number: '1-800-662-HELP',
      description: 'Substance abuse & mental health',
      color: Colors.purple,
      icon: Icons.health_and_safety_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..repeat(reverse: true); // continuous subtle pulse
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startGrounding() {
    setState(() => _currentGroundingStep = 0);
  }

  void _nextGroundingStep() {
    if (_currentGroundingStep < _groundingSteps.length - 1) {
      setState(() => _currentGroundingStep++);
    } else {
      setState(() => _currentGroundingStep = 0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Grounding exercise completed! 🌟'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _callEmergencyContact(EmergencyContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Call ${contact.name}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This will connect you to ${contact.description}'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: contact.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: contact.color.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(contact.icon, color: contact.color),
                  const SizedBox(width: 12),
                  Text(contact.number, style: TextStyle(color: contact.color, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Connecting to ${contact.name}...')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: contact.color),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Emergency Support', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // --- Panic Button Section ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.emergency_rounded, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  const Text('Need Immediate Help?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('You\'re not alone. Help is available 24/7.', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + _pulseController.value,
                        child: GestureDetector(
                          onTap: () => _callEmergencyContact(_emergencyContacts[2]), // emergency 911
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: 20, offset: Offset(0, 8))],
                            ),
                            child: const Icon(Icons.phone_rounded, color: Colors.white, size: 48),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text('Tap to call emergency services'),
                ],
              ),
            ),

            // --- Grounding Exercise Section ---
            _GroundingExerciseSection(
              steps: _groundingSteps,
              currentStep: _currentGroundingStep,
              onStart: _startGrounding,
              onNext: _nextGroundingStep,
            ),

            // --- Emergency Contacts Section ---
            _EmergencyContactsSection(
              contacts: _emergencyContacts,
              onCall: _callEmergencyContact,
            ),

            // --- Calming Tips Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: const [
                    Icon(Icons.favorite_rounded, color: Colors.pink, size: 32),
                    SizedBox(height: 16),
                    Text('Remember', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    SizedBox(height: 16),
                    Text(
                      '• You are not alone\n• This feeling will pass\n• You are stronger than you think\n• Help is always available\n• You matter',
                      style: TextStyle(height: 1.6),
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

// --- Grounding Exercise Widget ---
class _GroundingExerciseSection extends StatelessWidget {
  const _GroundingExerciseSection({
    required this.steps,
    required this.currentStep,
    required this.onStart,
    required this.onNext,
  });

  final List<String> steps;
  final int currentStep;
  final VoidCallback onStart;
  final VoidCallback onNext;

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
          children: [
            Row(
              children: const [Icon(Icons.anchor_rounded, color: Colors.lightBlue), SizedBox(width: 12), Text('Grounding Exercise', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.lightBlue.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text('Step ${currentStep + 1} of ${steps.length}', style: const TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text(steps[currentStep], textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: onStart, child: const Text('Start Over')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(onPressed: onNext, child: const Text('Next Step')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Emergency Contacts Widget ---
class _EmergencyContactsSection extends StatelessWidget {
  const _EmergencyContactsSection({
    required this.contacts,
    required this.onCall,
  });

  final List<EmergencyContact> contacts;
  final void Function(EmergencyContact) onCall;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Emergency Contacts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ...contacts.map((contact) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: contact.color.withOpacity(0.3))),
              leading: CircleAvatar(backgroundColor: contact.color.withOpacity(0.1), child: Icon(contact.icon, color: contact.color)),
              title: Text(contact.name),
              subtitle: Text('${contact.description}\n${contact.number}'),
              trailing: IconButton(onPressed: () => onCall(contact), icon: Icon(Icons.phone_rounded, color: contact.color)),
            ),
          )),
        ],
      ),
    );
  }
}

class EmergencyContact {
  final String name;
  final String number;
  final String description;
  final Color color;
  final IconData icon;

  EmergencyContact({
    required this.name,
    required this.number,
    required this.description,
    required this.color,
    required this.icon,
  });
}
