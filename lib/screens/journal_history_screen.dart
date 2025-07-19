import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/journal_entry.dart';
import '../providers/journal_provider.dart';
import 'edit_journal_screen.dart';

class JournalHistoryScreen extends StatefulWidget {
  const JournalHistoryScreen({super.key});

  @override
  State<JournalHistoryScreen> createState() => _JournalHistoryScreenState();
}

class _JournalHistoryScreenState extends State<JournalHistoryScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'This Week', 'This Month', 'Last 3 Months'];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  List<JournalEntry> _getFilteredEntries(List<JournalEntry> allEntries) {
    final now = DateTime.now();
    switch (selectedFilter) {
      case 'This Week':
        final weekAgo = now.subtract(const Duration(days: 7));
        return allEntries.where((entry) => entry.date.isAfter(weekAgo)).toList();
      case 'This Month':
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        return allEntries.where((entry) => entry.date.isAfter(monthAgo)).toList();
      case 'Last 3 Months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return allEntries.where((entry) => entry.date.isAfter(threeMonthsAgo)).toList();
      default:
        return allEntries;
    }
  }

  List<JournalEntry> _getSearchResults(List<JournalEntry> entries) {
    if (_searchController.text.isEmpty) return entries;
    return entries.where((entry) => 
      entry.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
      entry.content.toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97B8B),
        foregroundColor: Colors.white,
        title: const Text('Journal History'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              // Add test journal entries for debugging
              final journalProvider = Provider.of<JournalProvider>(context, listen: false);
              final testEntries = [
                JournalEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: 'test_user',
                  date: DateTime.now().subtract(const Duration(days: 1)),
                  title: 'My First Journal Entry',
                  content: 'Today was a great day! I learned a lot and felt productive.',
                ),
                JournalEntry(
                  id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
                  userId: 'test_user',
                  date: DateTime.now().subtract(const Duration(days: 2)),
                  title: 'Reflections on Learning',
                  content: 'I\'ve been thinking about my progress and what I want to achieve next.',
                ),
              ];
              
              for (final entry in testEntries) {
                await journalProvider.addEntry(entry);
              }
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added test journal entries')),
                );
              }
            },
            icon: const Icon(Icons.bug_report),
            tooltip: 'Add Test Data',
          ),
        ],
      ),
      body: Consumer<JournalProvider>(
        builder: (context, journalProvider, child) {
          final allEntries = journalProvider.entries;
          final filteredEntries = _getFilteredEntries(allEntries);
          final searchResults = _getSearchResults(filteredEntries);

          debugPrint('JournalHistoryScreen: Total entries: ${allEntries.length}');
          debugPrint('JournalHistoryScreen: Filtered entries: ${filteredEntries.length}');
          debugPrint('JournalHistoryScreen: Search results: ${searchResults.length}');

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _isSearching = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search journal entries...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFEA4C89)),
                    suffixIcon: _isSearching
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Color(0xFFEA4C89)),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _isSearching = false;
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),

              // Filter chips
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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

              const SizedBox(height: 16),

              // Statistics card
              if (filteredEntries.isNotEmpty)
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.article, color: const Color(0xFFEA4C89), size: 24),
                              const SizedBox(height: 8),
                              Text(
                                '${filteredEntries.length}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEA4C89),
                                ),
                              ),
                              Text(
                                'Entries',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.calendar_today, color: const Color(0xFFEA4C89), size: 24),
                              const SizedBox(height: 8),
                              Text(
                                filteredEntries.isNotEmpty 
                                    ? '${filteredEntries.first.date.day}/${filteredEntries.first.date.month}/${filteredEntries.first.date.year}'
                                    : 'No entries',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEA4C89),
                                ),
                              ),
                              Text(
                                'Latest',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Journal entries list
              Expanded(
                child: searchResults.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _isSearching ? 'No entries found' : 'No journal entries yet',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isSearching 
                                    ? 'Try adjusting your search terms'
                                    : 'Start writing to see your entries here',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final entry = searchResults[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withOpacity(0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ExpansionTile(
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
                                ),
                                subtitle: Text(
                                  '${entry.date.day}/${entry.date.month}/${entry.date.year} at ${entry.date.hour}:${entry.date.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry.content,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            height: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => EditJournalScreen(entry: entry),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.edit, size: 16),
                                              label: const Text('Edit'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: const Color(0xFFEA4C89),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            TextButton.icon(
                                              onPressed: () async {
                                                // Show delete confirmation
                                                final confirmed = await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text('Delete Entry'),
                                                    content: const Text('Are you sure you want to delete this journal entry?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context, false),
                                                        child: const Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context, true),
                                                        style: TextButton.styleFrom(
                                                          foregroundColor: Colors.red,
                                                        ),
                                                        child: const Text('Delete'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                
                                                if (confirmed == true) {
                                                  try {
                                                    // Store context before async operation
                                                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                                                    
                                                    await Provider.of<JournalProvider>(context, listen: false).deleteEntry(entry.id);
                                                    if (mounted) {
                                                      scaffoldMessenger.showSnackBar(
                                                        const SnackBar(
                                                          content: Text('Journal entry deleted successfully!'),
                                                          backgroundColor: Colors.green,
                                                        ),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    debugPrint('JournalHistoryScreen: Error deleting journal entry: $e');
                                                    if (mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Failed to delete journal entry: $e'),
                                                          backgroundColor: Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                }
                                              },
                                              icon: const Icon(Icons.delete, size: 16),
                                              label: const Text('Delete'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 