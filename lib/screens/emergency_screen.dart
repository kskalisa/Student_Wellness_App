import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmergencyScreen extends StatelessWidget {
  EmergencyScreen({super.key});
  final List<EmergencyContact> contacts = [
    EmergencyContact(
      name: 'University Counseling',
      phone: '078-121-8195',
      description: '24/7 mental health support',
    ),
    EmergencyContact(
      name: 'Crisis Hotline',
      phone: '988',
      description: 'National suicide prevention lifeline',
    ),
    // Add more contacts
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: const Color(0xFFF97B8B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFDF6F8),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Animate(
            effects: [
              FadeEffect(duration: 400.ms, curve: Curves.easeIn),
              SlideEffect(duration: 400.ms, begin: const Offset(0, 0.1), end: Offset.zero, curve: Curves.easeOut),
            ],
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              margin: const EdgeInsets.only(bottom: 18),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFEA4C89).withOpacity(0.15),
                  child: const Icon(Icons.emergency, color: Color(0xFFEA4C89), size: 28),
                ),
                title: Text(
                  contact.name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFEA4C89)),
                ),
                subtitle: Text(contact.description),
                trailing: ElevatedButton.icon(
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA4C89),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _showCallDialog(context, contact),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCallDialog(BuildContext context, EmergencyContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call ${contact.name}?'),
        content: Text('Are you sure you want to call ${contact.phone}?'),
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
              _callNumber(contact.phone);
            },
          ),
        ],
      ),
    );
  }

  void _callNumber(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String description;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.description,
  });
}