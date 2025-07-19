import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mood.dart';
import '../providers/mood_provider.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({super.key});

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'This Week', 'This Month', 'Last 3 Months'];

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

  List<Mood> _getFilteredMoods(List<Mood> allMoods) {
    final now = DateTime.now();
    switch (selectedFilter) {
      case 'This Week':
        final weekAgo = now.subtract(const Duration(days: 7));
        return allMoods.where((mood) => mood.date.isAfter(weekAgo)).toList();
      case 'This Month':
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        return allMoods.where((mood) => mood.date.isAfter(monthAgo)).toList();
      case 'Last 3 Months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return allMoods.where((mood) => mood.date.isAfter(threeMonthsAgo)).toList();
      default:
        return allMoods;
    }
  }

  Map<String, int> _getMoodStats(List<Mood> moods) {
    final stats = <String, int>{};
    for (final mood in moods) {
      stats[mood.moodType] = (stats[mood.moodType] ?? 0) + 1;
    }
    return stats;
  }

  double _getAverageIntensity(List<Mood> moods) {
    if (moods.isEmpty) return 0;
    final total = moods.fold(0, (sum, mood) => sum + mood.intensity);
    return total / moods.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97B8B),
        foregroundColor: Colors.white,
        title: const Text('Mood History'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              // Store context before async operation
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              
              final moodProvider = Provider.of<MoodProvider>(context, listen: false);
              final testMoods = [
                Mood(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: 'test_user',
                  date: DateTime.now().subtract(const Duration(days: 1)),
                  moodType: 'Happy',
                  intensity: 4,
                  notes: 'Test mood 1',
                ),
                Mood(
                  id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
                  userId: 'test_user',
                  date: DateTime.now().subtract(const Duration(days: 2)),
                  moodType: 'Sad',
                  intensity: 2,
                  notes: 'Test mood 2',
                ),
              ];
              
              for (final mood in testMoods) {
                await moodProvider.addMood(mood);
              }
              
              if (mounted) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Added test moods')),
                );
              }
            },
            icon: const Icon(Icons.bug_report),
            tooltip: 'Add Test Data',
          ),
        ],
      ),
      body: Consumer<MoodProvider>(
        builder: (context, moodProvider, child) {
          final allMoods = moodProvider.moods;
          final filteredMoods = _getFilteredMoods(allMoods);
          final moodStats = _getMoodStats(filteredMoods);
          final averageIntensity = _getAverageIntensity(filteredMoods);

          debugPrint('MoodHistoryScreen: Total moods: ${allMoods.length}');
          debugPrint('MoodHistoryScreen: Filtered moods: ${filteredMoods.length}');
          debugPrint('MoodHistoryScreen: Mood stats: $moodStats');
          debugPrint('MoodHistoryScreen: Average intensity: $averageIntensity');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter chips
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    children: filters.map((filter) => ChoiceChip(
                      label: Text(filter),
                      selected: selectedFilter == filter,
                      selectedColor: const Color(0xFFEA4C89),
                      backgroundColor: Colors.white,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedFilter = filter;
                          });
                        }
                      },
                    )).toList(),
                  ),
                ),

                // Statistics cards
                if (filteredMoods.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Entries',
                            '${filteredMoods.length}',
                            Icons.assessment,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Avg Intensity',
                            '${averageIntensity.toStringAsFixed(1)}/5',
                            Icons.trending_up,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Mood distribution
                if (moodStats.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mood Distribution',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: const Color(0xFFEA4C89),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...moodStats.entries.map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  moodIcons[entry.key] ?? Icons.emoji_emotions,
                                  color: const Color(0xFFEA4C89),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEA4C89).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${entry.value}',
                                    style: const TextStyle(
                                      color: Color(0xFFEA4C89),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Mood entries list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Recent Entries',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFEA4C89),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                if (filteredMoods.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.emoji_emotions_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No mood entries found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start logging your moods to see your patterns here',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredMoods.length,
                    itemBuilder: (context, index) {
                      final mood = filteredMoods[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
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
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${mood.date.day}/${mood.date.month}/${mood.date.year} at ${mood.date.hour}:${mood.date.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                if (mood.notes != null && mood.notes!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      mood.notes!,
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
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
                            onTap: () {
                              // TODO: Show mood details dialog
                            },
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
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
        children: [
          Icon(icon, color: const Color(0xFFEA4C89), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEA4C89),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 