import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WellnessGoal {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime targetDate;
  final int progress;
  final bool isCompleted;

  WellnessGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.targetDate,
    this.progress = 0,
    this.isCompleted = false,
  });
}

class WellnessGoalsScreen extends StatefulWidget {
  const WellnessGoalsScreen({super.key});

  @override
  State<WellnessGoalsScreen> createState() => _WellnessGoalsScreenState();
}

class _WellnessGoalsScreenState extends State<WellnessGoalsScreen> {
  final List<WellnessGoal> _goals = [
    WellnessGoal(
      id: '1',
      title: 'Practice Daily Meditation',
      description: 'Meditate for at least 10 minutes every day',
      category: 'Mindfulness',
      targetDate: DateTime.now().add(const Duration(days: 30)),
      progress: 70,
    ),
    WellnessGoal(
      id: '2',
      title: 'Improve Sleep Quality',
      description: 'Get 8 hours of sleep and maintain a consistent sleep schedule',
      category: 'Health',
      targetDate: DateTime.now().add(const Duration(days: 21)),
      progress: 45,
    ),
    WellnessGoal(
      id: '3',
      title: 'Reduce Stress Levels',
      description: 'Practice stress management techniques and maintain mood above 7/10',
      category: 'Mental Health',
      targetDate: DateTime.now().add(const Duration(days: 60)),
      progress: 60,
    ),
    WellnessGoal(
      id: '4',
      title: 'Build Social Connections',
      description: 'Participate in anonymous support chats and help others',
      category: 'Social',
      targetDate: DateTime.now().add(const Duration(days: 45)),
      progress: 30,
    ),
  ];

  final List<String> _categories = [
    'Mindfulness',
    'Health',
    'Mental Health',
    'Social',
    'Academic',
    'Personal',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97B8B),
        foregroundColor: Colors.white,
        title: const Text('Wellness Goals'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddGoalDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with progress overview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF97B8B), Color(0xFFFAD0C4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          Icons.flag,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Your Wellness Journey',
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
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Overall Progress',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_calculateOverallProgress()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Active Goals',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_goals.where((goal) => !goal.isCompleted).length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
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
            const SizedBox(height: 20),

            // Goals List
            Text(
              'Your Goals',
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFFEA4C89),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ..._goals.map((goal) => _buildGoalCard(goal)).toList(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(WellnessGoal goal) {
    final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;
    final progressColor = _getProgressColor(goal.progress);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(goal.category).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCategoryIcon(goal.category),
                        color: _getCategoryColor(goal.category),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            goal.category,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editGoal(goal);
                        } else if (value == 'delete') {
                          _deleteGoal(goal);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  goal.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${goal.progress}%',
                          style: TextStyle(
                            color: progressColor,
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
                        widthFactor: goal.progress / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: progressColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Goal Info
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      daysLeft > 0 ? '$daysLeft days left' : 'Overdue',
                      style: TextStyle(
                        color: daysLeft > 0 ? Colors.grey[600] : Colors.red,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    if (goal.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _updateProgress(goal),
                    icon: const Icon(Icons.update),
                    label: const Text('Update Progress'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEA4C89),
                      side: const BorderSide(color: Color(0xFFEA4C89)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _completeGoal(goal),
                    icon: const Icon(Icons.check),
                    label: const Text('Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEA4C89),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(int progress) {
    if (progress >= 80) return Colors.green;
    if (progress >= 60) return Colors.orange;
    if (progress >= 40) return Colors.yellow[700]!;
    return Colors.red;
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Mindfulness': return Colors.blue;
      case 'Health': return Colors.green;
      case 'Mental Health': return Colors.purple;
      case 'Social': return Colors.orange;
      case 'Academic': return Colors.red;
      case 'Personal': return Colors.teal;
      default: return const Color(0xFFEA4C89);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Mindfulness': return Icons.self_improvement;
      case 'Health': return Icons.favorite;
      case 'Mental Health': return Icons.psychology;
      case 'Social': return Icons.people;
      case 'Academic': return Icons.school;
      case 'Personal': return Icons.person;
      default: return Icons.flag;
    }
  }

  int _calculateOverallProgress() {
    if (_goals.isEmpty) return 0;
    final totalProgress = _goals.fold(0, (sum, goal) => sum + goal.progress);
    return (totalProgress / _goals.length).round();
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Goal'),
        content: const Text('Goal creation feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Goal creation feature coming soon...')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editGoal(WellnessGoal goal) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Goal editing feature coming soon...')),
    );
  }

  void _deleteGoal(WellnessGoal goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal'),
        content: Text('Are you sure you want to delete "${goal.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _goals.removeWhere((g) => g.id == goal.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Goal deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _updateProgress(WellnessGoal goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Progress'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current progress: ${goal.progress}%'),
            const SizedBox(height: 16),
            Slider(
              value: goal.progress.toDouble(),
              min: 0,
              max: 100,
              divisions: 20,
              onChanged: (value) {
                setState(() {
                  final index = _goals.indexWhere((g) => g.id == goal.id);
                  if (index != -1) {
                    _goals[index] = WellnessGoal(
                      id: goal.id,
                      title: goal.title,
                      description: goal.description,
                      category: goal.category,
                      targetDate: goal.targetDate,
                      progress: value.round(),
                      isCompleted: goal.isCompleted,
                    );
                  }
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Progress updated')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _completeGoal(WellnessGoal goal) {
    setState(() {
      final index = _goals.indexWhere((g) => g.id == goal.id);
      if (index != -1) {
        _goals[index] = WellnessGoal(
          id: goal.id,
          title: goal.title,
          description: goal.description,
          category: goal.category,
          targetDate: goal.targetDate,
          progress: 100,
          isCompleted: true,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Congratulations! You completed "${goal.title}"')),
    );
  }
} 