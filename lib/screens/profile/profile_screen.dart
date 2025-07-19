import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'edit_profile_screen.dart';
import 'profile_statistics_screen.dart';
import 'settings_screen.dart';
import 'wellness_goals_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Get user data from provider or use defaults
        final profile = userProvider.profile;
        final String avatarUrl = profile?.avatarUrl ?? '';
        final String displayName = profile?.displayName ?? 'Student';
        final String university = profile?.university ?? 'AUCA';
        final List<String> interests = profile?.interests ?? ['Wellness', 'Mental Health'];

        return Scaffold(
          backgroundColor: const Color(0xFFFDF6F8),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gradient header with avatar
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
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 54,
                            backgroundColor: const Color(0xFFFAD0C4),
                            backgroundImage: avatarUrl.isNotEmpty 
                                ? (avatarUrl.startsWith('http') 
                                    ? NetworkImage(avatarUrl) 
                                    : FileImage(File(avatarUrl)) as ImageProvider)
                                : null,
                            child: avatarUrl.isEmpty
                                ? const Icon(Icons.person, size: 54, color: Colors.white)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFFEA4C89),
                              child: IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        displayName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.school, size: 18, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            university,
                            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Interests
                      Text(
                        'Interests',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFEA4C89),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: interests.map((interest) => Chip(
                          label: Text(interest),
                          labelStyle: const TextStyle(color: Color(0xFFEA4C89), fontWeight: FontWeight.w600),
                          backgroundColor: const Color(0xFFFAD0C4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        )).toList(),
                      ),
                      const SizedBox(height: 32),
                      
                      // Profile Actions Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _buildActionCard(
                            context,
                            'Statistics',
                            Icons.analytics,
                            const Color(0xFFFFB347),
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfileStatisticsScreen()),
                            ),
                          ),
                          _buildActionCard(
                            context,
                            'Goals',
                            Icons.flag,
                            const Color(0xFF7ED957),
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const WellnessGoalsScreen()),
                            ),
                          ),
                          _buildActionCard(
                            context,
                            'Settings',
                            Icons.settings,
                            const Color(0xFF6DC8F3),
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingsScreen()),
                            ),
                          ),
                          _buildActionCard(
                            context,
                            'Edit Profile',
                            Icons.edit,
                            const Color(0xFFB39DDB),
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFEA4C89),
                            side: const BorderSide(color: Color(0xFFEA4C89)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () {
                            // TODO: Implement logout logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Logout pressed (implement logic)')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: color,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}