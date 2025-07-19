import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/meditation_session.dart';
import '../providers/meditation_provider.dart';

class MeditationSessionScreen extends StatefulWidget {
  final MeditationSession session;

  const MeditationSessionScreen({super.key, required this.session});

  @override
  State<MeditationSessionScreen> createState() => _MeditationSessionScreenState();
}

class _MeditationSessionScreenState extends State<MeditationSessionScreen> {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isPlaying = false;
  bool _isCompleted = false;
  int? _userRating;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.session.durationMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null) return;
    
    setState(() {
      _isPlaying = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _completeSession();
          timer.cancel();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      // Timer is paused
    });
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _remainingSeconds = widget.session.durationMinutes * 60;
    });
  }

  Future<void> _completeSession() async {
    setState(() {
      _isCompleted = true;
      _isPlaying = false;
    });

    try {
      await Provider.of<MeditationProvider>(context, listen: false)
          .completeSession(widget.session.id, rating: _userRating);
    } catch (e) {
      debugPrint('Error completing meditation session: $e');
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Your Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How was your meditation session?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _userRating = index + 1;
                    });
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.star,
                    color: _userRating != null && _userRating! > index
                        ? Colors.amber
                        : Colors.grey,
                    size: 32,
                  ),
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = 1 - (_remainingSeconds / (widget.session.durationMinutes * 60));
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97B8B),
        foregroundColor: Colors.white,
        title: Text(widget.session.title),
        elevation: 0,
        actions: [
          if (_isCompleted)
            IconButton(
              onPressed: _showRatingDialog,
              icon: const Icon(Icons.star),
              tooltip: 'Rate Session',
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            width: double.infinity,
            height: 8,
            color: Colors.grey[200],
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEA4C89)),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Session info
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Timer display
                        Text(
                          _formatTime(_remainingSeconds),
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: const Color(0xFFEA4C89),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Session title
                        Text(
                          widget.session.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFFEA4C89),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        
                        // Session description
                        Text(
                          widget.session.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        
                        // Category chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEA4C89).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.session.category,
                            style: const TextStyle(
                              color: Color(0xFFEA4C89),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Control buttons
                  if (!_isCompleted) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Stop button
                        IconButton(
                          onPressed: _stopTimer,
                          icon: const Icon(Icons.stop_circle, size: 48),
                          color: Colors.red,
                        ),
                        
                        // Play/Pause button
                        IconButton(
                          onPressed: _isPlaying ? _pauseTimer : _resumeTimer,
                          icon: Icon(
                            _isPlaying ? Icons.pause_circle : Icons.play_circle,
                            size: 64,
                          ),
                          color: const Color(0xFFEA4C89),
                        ),
                        
                        // Skip button (for testing)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _remainingSeconds = 0;
                            });
                            _completeSession();
                          },
                          icon: const Icon(Icons.skip_next, size: 48),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ] else ...[
                    // Completion message
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Session Completed!',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Great job! You\'ve completed your meditation session.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.home),
                      label: const Text('Back to Meditation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEA4C89),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
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
} 