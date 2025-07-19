import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_wellness_app/services/auth_service.dart';
import 'package:student_wellness_app/services/database_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService? authService;
  final DatabaseService? databaseService;
  User? _user;

  AuthProvider({required this.authService, required this.databaseService}) {
    initialize();
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<void> initialize() async {
    authService?.user.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signInAnonymously() async {
    try {
      await authService?.signInAnonymously();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await authService?.signOut();
  }
}