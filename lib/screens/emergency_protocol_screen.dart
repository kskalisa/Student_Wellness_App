import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      emergencyNumber: '911',
    ),
    // Add more protocols
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      body: Column(
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF97B8B), Color(0xFFFAD0C4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.health_and_safety, color: Colors.white, size: 40),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Protocols',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Follow these steps in an emergency.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              itemCount: _protocols.length,
              itemBuilder: (context, index) {
                final protocol = _protocols[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                    title: Text(
                      protocol.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFEA4C89)),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...protocol.steps.map((step) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text('• $step'),
                            )),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.phone),
                              label: Text('Call ${protocol.emergencyNumber}'),
                              onPressed: () => launchUrl(
                                  Uri.parse('tel:${protocol.emergencyNumber}')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEA4C89),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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