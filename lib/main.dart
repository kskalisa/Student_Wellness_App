import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_wellness_app/theme/app_theme.dart';
import 'firebase_options.dart';

// Providers
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/mood_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/meditation_provider.dart';
import 'providers/anonymous_chat_provider.dart';
import 'providers/user_provider.dart';

// Services
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/local_storage_service.dart';
import 'services/moderation_service.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/mood_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/emergency_protocol_screen.dart';
import 'screens/anonymous_chat_screen.dart';


class MainTabScaffold extends StatefulWidget {
  const MainTabScaffold({super.key});

  @override
  State<MainTabScaffold> createState() => _MainTabScaffoldState();
}

class _MainTabScaffoldState extends State<MainTabScaffold> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final List<Widget> _screens = [
    const HomeScreen(),
    const MoodScreen(),
    const JournalScreen(),
    MeditationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToDrawerScreen(Widget screen) {
    Navigator.of(context).pop(); // Close the drawer
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _screens[_selectedIndex],
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDF6F8), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF97B8B), Color(0xFFFAD0C4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person, color: Color(0xFFEA4C89), size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Student Wellness',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your wellness companion',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Main Menu Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        'MAIN MENU',
                        style: TextStyle(
                          color: Color(0xFFEA4C89),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEA4C89).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.person, color: Color(0xFFEA4C89)),
                            ),
                            title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w600)),
                            onTap: () => _navigateToDrawerScreen(const ProfileScreen()),
                          ),
                          const Divider(height: 1, indent: 56, endIndent: 16),

                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEA4C89).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.psychology, color: Color(0xFFEA4C89)),
                            ),
                            title: const Text('Anonymous Support', style: TextStyle(fontWeight: FontWeight.w600)),
                            onTap: () => _navigateToDrawerScreen(const AnonymousChatScreen()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Emergency Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        'EMERGENCY',
                        style: TextStyle(
                          color: Color(0xFFEA4C89),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEA4C89).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.emergency, color: Color(0xFFEA4C89)),
                            ),
                            title: const Text('Emergency', style: TextStyle(fontWeight: FontWeight.w600)),
                            onTap: () => _navigateToDrawerScreen(EmergencyScreen()),
                          ),
                          const Divider(height: 1, indent: 56, endIndent: 16),
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEA4C89).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.health_and_safety, color: Color(0xFFEA4C89)),
                            ),
                            title: const Text('Emergency Protocols', style: TextStyle(fontWeight: FontWeight.w600)),
                            onTap: () => _navigateToDrawerScreen(EmergencyProtocolScreen()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFEA4C89),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Meditate',
          ),
        ],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              // Theme Provider
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) => ThemeProvider(snapshot.data!),
              ),

              // Services
              Provider<AuthService>(create: (_) => AuthService()),
              Provider<DatabaseService>(create: (_) => FirebaseDatabaseService()),
              Provider<LocalStorageService>(
                create: (_) => LocalStorageService(snapshot.data!),
              ),
              Provider<ModerationService>(create: (_) => ModerationService()),

              // Auth Provider
              ChangeNotifierProxyProvider<AuthService, AuthProvider>(
                create: (context) => AuthProvider(
                  authService: Provider.of<AuthService>(context, listen: false),
                  databaseService: Provider.of<DatabaseService>(context, listen: false),
                ),
                update: (context, authService, previous) => AuthProvider(
                  authService: authService,
                  databaseService: Provider.of<DatabaseService>(context, listen: false),
                ),
              ),

              // User Provider
              ChangeNotifierProxyProvider2<AuthProvider, DatabaseService, UserProvider>(
                create: (context) => UserProvider(
                  databaseService: Provider.of<DatabaseService>(context, listen: false),
                  localStorage: Provider.of<LocalStorageService>(context, listen: false),
                ),
                update: (context, auth, databaseService, previous) => UserProvider(
                  databaseService: databaseService,
                  localStorage: Provider.of<LocalStorageService>(context, listen: false),
                )..updateUserId(auth.user?.uid),
              ),

              // Mood Provider
              ChangeNotifierProxyProvider2<AuthProvider, DatabaseService, MoodProvider>(
                create: (context) => MoodProvider(
                  Provider.of<DatabaseService>(context, listen: false),
                ),
                update: (context, auth, databaseService, previous) {
                  final moodProvider = previous ?? MoodProvider(databaseService);
                  moodProvider.updateUserId(auth.user?.uid);
                  return moodProvider;
                },
              ),

              // Journal Provider
              ChangeNotifierProxyProvider2<AuthProvider, DatabaseService, JournalProvider>(
                create: (context) => JournalProvider(
                  Provider.of<DatabaseService>(context, listen: false),
                ),
                update: (context, auth, databaseService, previous) {
                  final journalProvider = previous ?? JournalProvider(databaseService);
                  journalProvider.updateUserId(auth.user?.uid);
                  return journalProvider;
                },
              ),



              // Meditation Provider
              ChangeNotifierProxyProvider2<AuthProvider, DatabaseService, MeditationProvider>(
                create: (context) => MeditationProvider(
                  Provider.of<DatabaseService>(context, listen: false),
                ),
                update: (context, auth, databaseService, previous) {
                  final meditationProvider = previous ?? MeditationProvider(databaseService);
                  meditationProvider.updateUserId(auth.user?.uid);
                  return meditationProvider;
                },
              ),

              // Anonymous Chat Provider
              ChangeNotifierProxyProvider2<DatabaseService, ModerationService, AnonymousChatProvider>(
                create: (context) => AnonymousChatProvider(
                  Provider.of<DatabaseService>(context, listen: false),
                  Provider.of<ModerationService>(context, listen: false),
                ),
                update: (context, databaseService, moderationService, previous) {
                  return previous ?? AnonymousChatProvider(databaseService, moderationService);
                },
              ),

            ],
            child: const MyApp(),
          );
        }
        return const MaterialApp(home: CircularProgressIndicator());
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Student Wellness',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const MainTabScaffold(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/mood': (context) => const MoodScreen(),
        '/journal': (context) => const JournalScreen(),
        '/meditation': (context) =>  MeditationScreen(),
        '/emergency': (context) =>  EmergencyScreen(),
        '/profile': (context) => const ProfileScreen(),

      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return authProvider.isAuthenticated ? const HomeScreen() : const LoginScreen();
  }
}