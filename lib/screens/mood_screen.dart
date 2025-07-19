import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mood.dart';
import '../providers/mood_provider.dart';
import 'mood_history_screen.dart';
import '../providers/auth_provider.dart'; // Added import for AuthProvider

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? selectedMood;
  int intensity = 3;
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  final List<String> moodTypes = [
    'Happy', 'Sad', 'Angry', 'Anxious', 'Tired', 'Excited', 'Peaceful', 'Stressed', 'Grateful', 'Lonely'
  ];

  final Map<String, IconData> moodIcons = {
    'Happy': Icons.sentiment_very_satisfied,
    'Sad': Icons.sentiment_very_dissatisfied,
    'Angry': Icons.sentiment_dissatisfied,
    'Anxious': Icons.sentiment_neutral,
    'Tired': Icons.bedtime,
    'Excited': Icons.celebration,
    'Peaceful': Icons.spa,
    'Stressed': Icons.psychology,
    'Grateful': Icons.favorite,
    'Lonely': Icons.person_off,
  };

  @override
  void initState() {
    super.initState();
    _loadMoodHistory();
  }

  Future<void> _loadMoodHistory() async {
    // This will be called when the screen loads to show recent moods
  }

  Future<void> _saveMood() async {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a mood first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Store context before async operation
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final moodProvider = Provider.of<MoodProvider>(context, listen: false);
      
      // Check if user is authenticated
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String userId = 'current_user_id';
      
      if (authProvider.isAuthenticated && authProvider.user != null) {
        userId = authProvider.user!.uid;
      } else {
        // Sign in anonymously if not authenticated
        await authProvider.signInAnonymously();
        if (authProvider.user != null) {
          userId = authProvider.user!.uid;
        }
      }

      final mood = Mood(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        date: DateTime.now(),
        moodType: selectedMood!,
        intensity: intensity,
        notes: _notesController.text.trim(),
      );

      debugPrint('MoodScreen: Saving mood: ${mood.moodType} with intensity: ${mood.intensity}');
      await moodProvider.addMood(mood);
      
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Mood saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          selectedMood = null;
          intensity = 3;
          _notesController.clear();
        });
      }
    } catch (e) {
      debugPrint('MoodScreen: Error saving mood: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save mood: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Find the parent Scaffold and open drawer
          final scaffoldState = Scaffold.of(context);
          if (scaffoldState.hasDrawer) {
            scaffoldState.openDrawer();
          }
        },
        backgroundColor: const Color(0xFFEA4C89),
        child: const Icon(Icons.menu, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient header with icon
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24,
                      ),
                      child: const Icon(Icons.emoji_emotions, size: 48, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Log Your Mood',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'How are you feeling today?',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MoodHistoryScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.history, color: Colors.white, size: 24),
                        tooltip: 'View Mood History',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  
                  // Recent Moods Section
                  Consumer<MoodProvider>(
                    builder: (context, moodProvider, child) {
                      final recentMoods = moodProvider.moods.take(3).toList();
                      if (recentMoods.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Moods',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: const Color(0xFFEA4C89),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
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
                                children: recentMoods.map((mood) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFFEA4C89).withOpacity(0.1),
                                    child: Icon(
                                      moodIcons[mood.moodType] ?? Icons.emoji_emotions,
                                      color: const Color(0xFFEA4C89),
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    mood.moodType,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    '${mood.date.day}/${mood.date.month}/${mood.date.year} - Intensity: ${mood.intensity}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEA4C89).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${mood.intensity}/5',
                                      style: const TextStyle(
                                        color: Color(0xFFEA4C89),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )).toList(),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Mood chips
                  Text(
                    'Select Your Mood',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFEA4C89),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 10.0,
                    children: moodTypes.map((mood) => ChoiceChip(
                      avatar: Icon(
                        moodIcons[mood] ?? Icons.emoji_emotions,
                        color: selectedMood == mood ? Colors.white : const Color(0xFFEA4C89),
                        size: 18,
                      ),
                      label: Text(mood),
                      labelStyle: TextStyle(
                        color: selectedMood == mood ? Colors.white : const Color(0xFFEA4C89),
                        fontWeight: FontWeight.w600,
                      ),
                      selected: selectedMood == mood,
                      selectedColor: const Color(0xFFEA4C89),
                      backgroundColor: const Color(0xFFFAD0C4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      onSelected: (selected) => setState(() => selectedMood = mood),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    )).toList(),
                  ),
                  const SizedBox(height: 28),
                  
                  // Intensity slider
                  Container(
                    padding: const EdgeInsets.all(18),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bolt, color: Color(0xFFEA4C89)),
                            const SizedBox(width: 8),
                            Text('Intensity: $intensity',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: const Color(0xFFEA4C89),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: intensity.toDouble(),
                          min: 1,
                          max: 5,
                          divisions: 4,
                          activeColor: const Color(0xFFEA4C89),
                          inactiveColor: const Color(0xFFFAD0C4),
                          onChanged: (value) => setState(() => intensity = value.toInt()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Low', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text('High', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  // Notes field
                  Container(
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
                    child: TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Any notes about your mood? (Optional)',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                        hintText: 'What\'s on your mind?',
                      ),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveMood,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEA4C89),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Save Mood', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}