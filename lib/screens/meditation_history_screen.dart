import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meditation_session.dart';
import '../providers/meditation_provider.dart';

class MeditationHistoryScreen extends StatefulWidget {
  const MeditationHistoryScreen({super.key});

  @override
  State<MeditationHistoryScreen> createState() => _MeditationHistoryScreenState();
}

class _MeditationHistoryScreenState extends State<MeditationHistoryScreen> {
  String selectedFilter = 'All';
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97B8B),
        foregroundColor: Colors.white,
        title: const Text('Meditation History'),
        elevation: 0,
      ),
      body: Consumer<MeditationProvider>(
        builder: (context, meditationProvider, child) {
          final completedSessions = meditationProvider.completedSessions;
          final totalMinutes = meditationProvider.getTotalMinutesCompleted();
          final averageRating = meditationProvider.getAverageRating();
          final mostPopularCategory = meditationProvider.getMostPopularCategory();

          // Filter sessions
          List<MeditationSession> filteredSessions = completedSessions;
          
          if (selectedCategory != 'All') {
            filteredSessions = filteredSessions.where((session) => session.category == selectedCategory).toList();
          }

          if (selectedFilter == 'This Week') {
            final now = DateTime.now();
            final weekStart = now.subtract(Duration(days: now.weekday - 1));
            filteredSessions = filteredSessions.where((session) => 
              session.completedAt != null && 
              session.completedAt!.isAfter(weekStart)
            ).toList();
          } else if (selectedFilter == 'This Month') {
            final now = DateTime.now();
            final monthStart = DateTime(now.year, now.month, 1);
            filteredSessions = filteredSessions.where((session) => 
              session.completedAt != null && 
              session.completedAt!.isAfter(monthStart)
            ).toList();
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistics cards
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Total sessions and minutes
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatCard(
                                  'Total Sessions',
                                  '${completedSessions.length}',
                                  Icons.self_improvement,
                                  const Color(0xFFEA4C89),
                                ),
                                _buildStatCard(
                                  'Total Minutes',
                                  '$totalMinutes',
                                  Icons.timer,
                                  Colors.blue,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatCard(
                                  'Avg Rating',
                                  averageRating > 0 ? averageRating.toStringAsFixed(1) : 'N/A',
                                  Icons.star,
                                  Colors.amber,
                                ),
                                _buildStatCard(
                                  'Top Category',
                                  mostPopularCategory,
                                  Icons.category,
                                  Colors.green,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Category distribution
                      if (completedSessions.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Category Distribution',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFFEA4C89),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ..._buildCategoryDistribution(completedSessions),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),

                // Filters
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter by Time',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFEA4C89),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'This Week', 'This Month'].map((filter) {
                            final isSelected = selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: ChoiceChip(
                                label: Text(filter),
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
                                      selectedFilter = filter;
                                    });
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Text(
                        'Filter by Category',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFEA4C89),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
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
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Sessions list
                if (filteredSessions.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Completed Sessions (${filteredSessions.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFEA4C89),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: filteredSessions.length,
                    itemBuilder: (context, index) {
                      final session = filteredSessions[index];
                      return _buildSessionCard(session, theme);
                    },
                  ),
                ] else ...[
                  // Empty state
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.self_improvement,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No completed sessions found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Complete your first meditation session to see it here',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategoryDistribution(List<MeditationSession> sessions) {
    final categoryCounts = <String, int>{};
    for (final session in sessions) {
      categoryCounts[session.category] = (categoryCounts[session.category] ?? 0) + 1;
    }

    return categoryCounts.entries.map((entry) {
      final percentage = (entry.value / sessions.length * 100).round();
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEA4C89),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: entry.value / sessions.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEA4C89)),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildSessionCard(MeditationSession session, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA4C89).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.self_improvement,
                    color: Color(0xFFEA4C89),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFEA4C89),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA4C89).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    session.category,
                    style: const TextStyle(
                      color: Color(0xFFEA4C89),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.timer_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${session.durationMinutes} min',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (session.rating != null) ...[
                  ...List.generate(5, (index) => Icon(
                    Icons.star,
                    size: 16,
                    color: index < session.rating! ? Colors.amber : Colors.grey[300],
                  )),
                  const SizedBox(width: 8),
                ],
                Text(
                  session.completedAt != null 
                      ? '${session.completedAt!.day}/${session.completedAt!.month}/${session.completedAt!.year}'
                      : '',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 