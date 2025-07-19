import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mood_provider.dart';
import '../../providers/journal_provider.dart';
import '../../providers/meditation_provider.dart';

class ProfileStatisticsScreen extends StatefulWidget {
  const ProfileStatisticsScreen({super.key});

  @override
  State<ProfileStatisticsScreen> createState() => _ProfileStatisticsScreenState();
}

class _ProfileStatisticsScreenState extends State<ProfileStatisticsScreen> {
  String _selectedPeriod = 'This Week';

  final List<String> _periods = ['This Week', 'This Month', 'This Year', 'All Time'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97B8B),
        foregroundColor: Colors.white,
        title: const Text('My Statistics'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time Period',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFEA4C89),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: _periods.map((period) {
                      final isSelected = _selectedPeriod == period;
                      return ChoiceChip(
                        label: Text(period),
                        selected: isSelected,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFFEA4C89),
                          fontWeight: FontWeight.w600,
                        ),
                        selectedColor: const Color(0xFFEA4C89),
                        backgroundColor: const Color(0xFFFAD0C4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedPeriod = period;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Mood Statistics
            _buildStatisticsCard(
              'Mood Journey',
              Icons.emoji_emotions,
              const Color(0xFFFFB347),
              [
                _buildStatItem('Average Mood', '7.2/10', 'Good'),
                _buildStatItem('Mood Entries', '24', 'This week'),
                _buildStatItem('Best Day', 'Wednesday', '8.5/10'),
                _buildStatItem('Lowest Day', 'Monday', '5.2/10'),
              ],
            ),
            const SizedBox(height: 16),

            // Journal Statistics
            _buildStatisticsCard(
              'Journal Activity',
              Icons.book,
              const Color(0xFF7ED957),
              [
                _buildStatItem('Total Entries', '12', 'This month'),
                _buildStatItem('Words Written', '2,847', 'Average 237/entry'),
                _buildStatItem('Longest Entry', '1,234 words', 'March 15'),
                _buildStatItem('Most Active Day', 'Friday', '3 entries'),
              ],
            ),
            const SizedBox(height: 16),

            // Meditation Statistics
            _buildStatisticsCard(
              'Meditation Progress',
              Icons.self_improvement,
              const Color(0xFF6DC8F3),
              [
                _buildStatItem('Total Sessions', '18', 'This month'),
                _buildStatItem('Total Minutes', '324', 'Average 18min/session'),
                _buildStatItem('Longest Session', '45 minutes', 'March 10'),
                _buildStatItem('Current Streak', '7 days', 'Personal best!'),
              ],
            ),
            const SizedBox(height: 16),

            // Wellness Score
            _buildWellnessScoreCard(),
            const SizedBox(height: 20),

            // Progress Charts
            _buildProgressChartCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(String title, IconData icon, Color color, List<Widget> stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.06),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFEA4C89),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stats,
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFFEA4C89),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF97B8B), Color(0xFFFAD0C4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Wellness Score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '8.4/10',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Excellent Progress!',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '+12%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.06),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEA4C89).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Color(0xFFEA4C89),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Weekly Progress',
                style: TextStyle(
                  color: Color(0xFFEA4C89),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Simple progress bars
          _buildProgressBar('Mood Tracking', 0.85, const Color(0xFFFFB347)),
          const SizedBox(height: 12),
          _buildProgressBar('Journal Writing', 0.72, const Color(0xFF7ED957)),
          const SizedBox(height: 12),
          _buildProgressBar('Meditation', 0.68, const Color(0xFF6DC8F3)),
          const SizedBox(height: 12),
          _buildProgressBar('Anonymous Support', 0.45, const Color(0xFFB39DDB)),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 