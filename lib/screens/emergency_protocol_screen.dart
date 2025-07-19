import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmergencyProtocolScreen extends StatelessWidget {
  EmergencyProtocolScreen({super.key});
  final List<Protocol> _protocols = [
    Protocol(
      title: 'Panic Attack',
      steps: [
        'Find a quiet space',
        'Practice deep breathing',
        'Focus on a single object',
        'Use grounding techniques',
      ],
      emergencyNumber: '311',
    ),
    // Add more protocols
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Protocols'),
        backgroundColor: const Color(0xFFF97B8B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFDF6F8),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        itemCount: _protocols.length,
        itemBuilder: (context, index) {
          final protocol = _protocols[index];
          return Animate(
            effects: [
              FadeEffect(duration: 400.ms, curve: Curves.easeIn),
              SlideEffect(duration: 400.ms, begin: const Offset(0, 0.1), end: Offset.zero, curve: Curves.easeOut),
            ],
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              margin: const EdgeInsets.only(bottom: 18),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFEA4C89).withOpacity(0.15),
                  child: const Icon(Icons.health_and_safety, color: Color(0xFFEA4C89), size: 24),
                ),
                title: Text(
                  protocol.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFEA4C89)),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...protocol.steps.map((step) => Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFFEA4C89), size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(step)),
                          ],
                        )),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.phone),
                          label: Text('Call ${protocol.emergencyNumber}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEA4C89),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          ),
                          onPressed: () => _showCallDialog(context, protocol),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCallDialog(BuildContext context, Protocol protocol) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call ${protocol.title} Emergency?'),
        content: Text('Are you sure you want to call ${protocol.emergencyNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.phone),
            label: const Text('Call'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA4C89)),
            onPressed: () {
              Navigator.pop(context);
              launchUrl(Uri.parse('tel:${protocol.emergencyNumber}'));
            },
          ),
        ],
      ),
    );
  }
}

class Protocol {
  final String title;
  final List<String> steps;
  final String emergencyNumber;

  Protocol({
    required this.title,
    required this.steps,
    required this.emergencyNumber,
  });
}