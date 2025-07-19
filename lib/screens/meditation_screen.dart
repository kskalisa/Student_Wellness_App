import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meditation_session.dart';
import '../providers/meditation_provider.dart';
import 'meditation_session_screen.dart';
import 'meditation_history_screen.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  String selectedCategory = 'All';

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
      body: Consumer<MeditationProvider>(
        builder: (context, meditationProvider, child) {
          final sessions = meditationProvider.sessions;
          final completedSessions = meditationProvider.completedSessions;
          final totalMinutes = meditationProvider.getTotalMinutesCompleted();
          final averageRating = meditationProvider.getAverageRating();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gradient header with illustration
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
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white24,
                            ),
                            child: const Icon(Icons.self_improvement, size: 32, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Meditation Center',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Find your inner peace',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.play_circle_filled, color: Colors.white, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ready to start your session?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Take a moment to breathe and relax',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFEA4C89),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                if (sessions.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MeditationSessionScreen(session: sessions.first),
                                    ),
                                  );
                                }
                              },
                              child: const Text("Let's Start"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Progress section
                if (completedSessions.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDE8F0),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.trending_up, color: Color(0xFFEA4C89)),
                              const SizedBox(width: 8),
                              Text(
                                'Your Progress',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFFEA4C89),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'You\'ve completed $totalMinutes minutes of meditation!',
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.pinkAccent),
                          ),
                          if (averageRating > 0) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Average Rating: ',
                                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                                ),
                                ...List.generate(5, (index) => Icon(
                                  Icons.star,
                                  size: 16,
                                  color: index < averageRating ? Colors.amber : Colors.grey[300],
                                )),
                                Text(
                                  ' (${averageRating.toStringAsFixed(1)})',
                                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: completedSessions.length / 10, // Progress based on sessions completed
                            backgroundColor: Colors.pink[100],
                            color: const Color(0xFFEA4C89),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${completedSessions.length} Sessions Completed',
                            style: const TextStyle(color: Color(0xFFEA4C89), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
                
                // Categories
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Calm', 'Sleep', 'Relax', 'Focus', 'Breath'].map((category) {
                        final isSelected = selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFFEA4C89),
                              fontWeight: FontWeight.w600,
                            ),
                            selectedColor: const Color(0xFFEA4C89),
                            backgroundColor: const Color(0xFFFAD0C4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  selectedCategory = category;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Sessions header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Meditation Sessions',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFFEA4C89),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MeditationHistoryScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFEA4C89),
                        ),
                        child: const Text('View all'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                
                // Sessions list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedCategory == 'All' 
                        ? sessions.length 
                        : sessions.where((s) => s.category == selectedCategory).length,
                    itemBuilder: (context, index) {
                      final filteredSessions = selectedCategory == 'All' 
                          ? sessions 
                          : sessions.where((s) => s.category == selectedCategory).toList();
                      final session = filteredSessions[index];
                      return MeditationCard(session: session);
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MeditationCard extends StatelessWidget {
  final MeditationSession session;

  const MeditationCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    session.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFEA4C89),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (session.isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('PREMIUM', style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              session.description,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 18, color: Color(0xFFEA4C89)),
                const SizedBox(width: 6),
                Text(
                  '${session.durationMinutes} min',
                  style: const TextStyle(color: Color(0xFFEA4C89), fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeditationSessionScreen(session: session),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA4C89),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Start'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}