import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/anonymous_chat.dart';
import '../providers/anonymous_chat_provider.dart';
import '../providers/auth_provider.dart';

class AnonymousChatScreen extends StatefulWidget {
  const AnonymousChatScreen({super.key});

  @override
  State<AnonymousChatScreen> createState() => _AnonymousChatScreenState();
}

class _AnonymousChatScreenState extends State<AnonymousChatScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final TextEditingController _topicController = TextEditingController();

  final List<String> _predefinedTopics = [
    'Academic Stress',
    'Social Anxiety',
    'Mental Health Support',
    'Study Tips',
    'Loneliness',
    'Career Advice',
    'Relationship Issues',
    'General Support',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnonymousUser();
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _initializeAnonymousUser() async {
    final provider = Provider.of<AnonymousChatProvider>(context, listen: false);
    await provider.initializeAnonymousUser();
    await provider.loadAvailableChats();
    await provider.loadMyChats();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97B8B),
        foregroundColor: Colors.white,
        title: const Text('Anonymous Support Chat'),
        elevation: 0,
        actions: [
          Consumer<AnonymousChatProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with anonymous user info
          Consumer<AnonymousChatProvider>(
            builder: (context, provider, child) {
              if (provider.currentAnonymousUser != null) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEA4C89).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.psychology,
                          color: Color(0xFFEA4C89),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Anonymous Support',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: const Color(0xFFEA4C89),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'You are: ${provider.currentAnonymousUser!.displayName}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Anonymous',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: TabController(
                length: 3,
                vsync: this,
                initialIndex: _currentIndex,
              ),
              labelColor: const Color(0xFFEA4C89),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFFEA4C89),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: const [
                Tab(text: 'Available Chats'),
                Tab(text: 'My Chats'),
                Tab(text: 'Create Chat'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildAvailableChatsTab(),
                _buildMyChatsTab(),
                _buildCreateChatTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableChatsTab() {
    return Consumer<AnonymousChatProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.availableChats.isEmpty) {
          return _buildEmptyState(
            'No Available Chats',
            'There are no active support chats available right now.',
            Icons.chat_bubble_outline,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.availableChats.length,
          itemBuilder: (context, index) {
            final chat = provider.availableChats[index];
            return _buildChatCard(chat, false);
          },
        );
      },
    );
  }

  Widget _buildMyChatsTab() {
    return Consumer<AnonymousChatProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.myChats.isEmpty) {
          return _buildEmptyState(
            'No Active Chats',
            'You haven\'t joined any support chats yet.',
            Icons.chat_bubble_outline,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.myChats.length,
          itemBuilder: (context, index) {
            final chat = provider.myChats[index];
            return _buildChatCard(chat, true);
          },
        );
      },
    );
  }

  Widget _buildCreateChatTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEA4C89).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFFEA4C89),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create New Chat',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFFEA4C89),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Start a new anonymous support conversation',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
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
          const SizedBox(height: 24),

          // Predefined Topics
          Text(
            'Popular Topics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFFEA4C89),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _predefinedTopics.map((topic) {
              return ActionChip(
                label: Text(topic),
                onPressed: () => _createChat(topic),
                backgroundColor: const Color(0xFFFAD0C4),
                labelStyle: const TextStyle(
                  color: Color(0xFFEA4C89),
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Custom Topic
          Text(
            'Custom Topic',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFFEA4C89),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
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
            child: TextField(
              controller: _topicController,
              decoration: const InputDecoration(
                hintText: 'Enter your support topic...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _topicController.text.trim().isNotEmpty
                  ? () => _createChat(_topicController.text.trim())
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEA4C89),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Create Chat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatCard(AnonymousChat chat, bool isMyChat) {
    final theme = Theme.of(context);
    final participantCount = chat.participantIds.length;
    final timeAgo = _getTimeAgo(chat.lastActivity ?? chat.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEA4C89).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.chat_bubble_outline,
            color: Color(0xFFEA4C89),
            size: 24,
          ),
        ),
        title: Text(
          chat.topic,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '$participantCount participants',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: isMyChat
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'leave') {
                    _leaveChat(chat.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'leave',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Leave Chat'),
                      ],
                    ),
                  ),
                ],
              )
            : null,
        onTap: () => _joinChat(chat.id),
      ),
    );
  }

  Widget _buildEmptyState(String title, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEA4C89),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _createChat(String topic) async {
    final provider = Provider.of<AnonymousChatProvider>(context, listen: false);
    await provider.createChat(topic);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chat "$topic" created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _topicController.clear();
    }
  }

  Future<void> _joinChat(String chatId) async {
    final provider = Provider.of<AnonymousChatProvider>(context, listen: false);
    await provider.joinChat(chatId);
    
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnonymousChatRoomScreen(chatId: chatId),
        ),
      );
    }
  }

  Future<void> _leaveChat(String chatId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Chat'),
        content: const Text('Are you sure you want to leave this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = Provider.of<AnonymousChatProvider>(context, listen: false);
      await provider.leaveChat(chatId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You left the chat'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

// Chat Room Screen
class AnonymousChatRoomScreen extends StatefulWidget {
  final String chatId;

  const AnonymousChatRoomScreen({super.key, required this.chatId});

  @override
  State<AnonymousChatRoomScreen> createState() => _AnonymousChatRoomScreenState();
}

class _AnonymousChatRoomScreenState extends State<AnonymousChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadChatMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChatMessages() async {
    final provider = Provider.of<AnonymousChatProvider>(context, listen: false);
    await provider.loadChatMessages(widget.chatId);
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final provider = Provider.of<AnonymousChatProvider>(context, listen: false);
    await provider.sendMessage(_messageController.text.trim());
    _messageController.clear();
    
    // Scroll to bottom
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnonymousChatProvider>(
      builder: (context, provider, child) {
        final chat = provider.currentChat;
        
        return Scaffold(
          backgroundColor: const Color(0xFFFDF6F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF97B8B),
            foregroundColor: Colors.white,
            title: Text(chat?.topic ?? 'Anonymous Chat'),
            elevation: 0,
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'report') {
                    // Handle report
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'report',
                    child: Row(
                      children: [
                        Icon(Icons.report, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Report Chat'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Messages
              Expanded(
                child: provider.currentChatMessages.isEmpty
                    ? _buildEmptyChat()
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.currentChatMessages.length,
                        itemBuilder: (context, index) {
                          final message = provider.currentChatMessages[index];
                          final isMyMessage = message.senderId == provider.currentAnonymousUser?.anonymousId;
                          return _buildMessageBubble(message, isMyMessage);
                        },
                      ),
              ),

              // Message Input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type your message...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA4C89),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEA4C89),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to start the conversation!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(AnonymousChatMessage message, bool isMyMessage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMyMessage) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEA4C89).withOpacity(0.1),
              child: Text(
                message.senderId.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEA4C89),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMyMessage ? const Color(0xFFEA4C89) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isMyMessage ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTimeAgo(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: isMyMessage ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMyMessage) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green.withOpacity(0.1),
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.green,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
} 