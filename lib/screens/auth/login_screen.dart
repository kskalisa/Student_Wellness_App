import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_wellness_app/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Provider.of<AuthProvider>(context, listen: false).signInAnonymously(),
          child: const Text('Login Anonymously'),
        ),
      ),
    );
  }
}