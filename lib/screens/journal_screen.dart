import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/journal_entry.dart';
import '../providers/journal_provider.dart';
import '../providers/auth_provider.dart';
import 'journal_history_screen.dart';
import 'edit_journal_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
  }

  Future<void> _loadJournalEntries() async {
    // This will be called when the screen loads to show recent entries
  }

  Future<void> _saveEntry() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title for your journal entry'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something in your journal entry'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if user is authenticated
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String userId = 'current_user_id'; // Default fallback
      
      if (authProvider.isAuthenticated && authProvider.user != null) {
        userId = authProvider.user!.uid;
        debugPrint('JournalScreen: User is authenticated with ID: $userId');
      } else {
        debugPrint('JournalScreen: User not authenticated, using fallback ID: $userId');
        // Try to sign in anonymously if not authenticated
        try {
          await authProvider.signInAnonymously();
          userId = authProvider.user?.uid ?? userId;
          debugPrint('JournalScreen: Signed in anonymously, new userId: $userId');
        } catch (e) {
          debugPrint('JournalScreen: Failed to sign in anonymously: $e');
        }
      }

      final entry = JournalEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        date: DateTime.now(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );

      debugPrint('JournalScreen: Saving journal entry: ${entry.title}');
      
      // Store context before async operation
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);
      final journalProvider = Provider.of<JournalProvider>(context, listen: false);
      
      await journalProvider.addEntry(entry);

      // Show success message
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: const Text('Journal entry saved successfully!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View All',
              textColor: Colors.white,
              onPressed: () {
                navigator.push(
                  MaterialPageRoute(
                    builder: (context) => const JournalHistoryScreen(),
                  ),
                );
              },
            ),
          ),
        );
      }

      // Reset form
      if (mounted) {
        setState(() {
          _titleController.clear();
          _contentController.clear();
          _showForm = false;
        });
      }
    } catch (e) {
      debugPrint('JournalScreen: Error saving journal entry: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save journal entry: $e'),
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
      body: Column(
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
                    child: const Icon(Icons.book, size: 48, color: Colors.white),
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
                            'Journal',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Write your thoughts and reflect on your day.',
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
                            builder: (context) => const JournalHistoryScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.history, color: Colors.white, size: 24),
                      tooltip: 'View Journal History',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Recent Entries Section
                  Consumer<JournalProvider>(
                    builder: (context, journalProvider, child) {
                      final recentEntries = journalProvider.entries.take(3).toList();
                      if (recentEntries.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Entries',
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
                                children: recentEntries.map((entry) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFFEA4C89).withOpacity(0.1),
                                    child: const Icon(
                                      Icons.article,
                                      color: Color(0xFFEA4C89),
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    entry.title,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        entry.content,
                                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditJournalScreen(entry: entry),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit, color: Color(0xFFEA4C89), size: 20),
                                    tooltip: 'Edit Entry',
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

                  // New Entry Button
                  if (!_showForm)
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showForm = true;
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Write New Entry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA4C89),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                  // Journal Form
                  if (_showForm) ...[
                    const SizedBox(height: 16),
                    Text(
                      'New Journal Entry',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFEA4C89),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title field
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
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Give your entry a title...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Content field
                    Expanded(
                      child: Container(
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
                          controller: _contentController,
                          decoration: const InputDecoration(
                            labelText: 'Write your thoughts...',
                            hintText: 'How was your day? What\'s on your mind?',
                            border: InputBorder.none,
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.all(18),
                          ),
                          maxLines: null,
                          expands: true,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _titleController.clear();
                                _contentController.clear();
                                _showForm = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFEA4C89),
                              side: const BorderSide(color: Color(0xFFEA4C89)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveEntry,
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
                                : const Text('Save Entry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}