import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _dailyReminders = true;
  bool _weeklyReports = false;
  bool _anonymousMode = false;
  String _language = 'English';
  String _theme = 'System';

  final List<String> _languages = ['English', 'French', 'Kinyarwanda'];
  final List<String> _themes = ['Light', 'Dark', 'System'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97B8B),
        foregroundColor: Colors.white,
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Preferences
            _buildSectionCard(
              'App Preferences',
              Icons.settings,
              [
                _buildSwitchTile(
                  'Dark Mode',
                  'Use dark theme',
                  Icons.dark_mode,
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Switch(
                        value: themeProvider.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          themeProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                        },
                        activeColor: const Color(0xFFEA4C89),
                      );
                    },
                  ),
                ),
                _buildDropdownTile(
                  'Language',
                  'Choose your language',
                  Icons.language,
                  _language,
                  _languages,
                  (value) => setState(() => _language = value!),
                ),
                _buildDropdownTile(
                  'Theme',
                  'Choose your theme',
                  Icons.palette,
                  _theme,
                  _themes,
                  (value) => setState(() => _theme = value!),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Notifications
            _buildSectionCard(
              'Notifications',
              Icons.notifications,
              [
                _buildSwitchTile(
                  'Enable Notifications',
                  'Receive push notifications',
                  Icons.notifications_active,
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) => setState(() => _notificationsEnabled = value),
                    activeColor: const Color(0xFFEA4C89),
                  ),
                ),
                _buildSwitchTile(
                  'Daily Reminders',
                  'Remind me to log my mood',
                  Icons.schedule,
                  Switch(
                    value: _dailyReminders,
                    onChanged: (value) => setState(() => _dailyReminders = value),
                    activeColor: const Color(0xFFEA4C89),
                  ),
                ),
                _buildSwitchTile(
                  'Weekly Reports',
                  'Send weekly wellness summary',
                  Icons.assessment,
                  Switch(
                    value: _weeklyReports,
                    onChanged: (value) => setState(() => _weeklyReports = value),
                    activeColor: const Color(0xFFEA4C89),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Privacy & Security
            _buildSectionCard(
              'Privacy & Security',
              Icons.security,
              [
                _buildSwitchTile(
                  'Anonymous Mode',
                  'Hide personal information',
                  Icons.visibility_off,
                  Switch(
                    value: _anonymousMode,
                    onChanged: (value) => setState(() => _anonymousMode = value),
                    activeColor: const Color(0xFFEA4C89),
                  ),
                ),
                _buildListTile(
                  'Data Export',
                  'Export your wellness data',
                  Icons.download,
                  () => _exportData(),
                ),
                _buildListTile(
                  'Privacy Policy',
                  'Read our privacy policy',
                  Icons.privacy_tip,
                  () => _showPrivacyPolicy(),
                ),
                _buildListTile(
                  'Terms of Service',
                  'Read our terms of service',
                  Icons.description,
                  () => _showTermsOfService(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Account
            _buildSectionCard(
              'Account',
              Icons.account_circle,
              [
                _buildListTile(
                  'Change Password',
                  'Update your password',
                  Icons.lock,
                  () => _changePassword(),
                ),
                _buildListTile(
                  'Delete Account',
                  'Permanently delete your account',
                  Icons.delete_forever,
                  () => _deleteAccount(),
                  isDestructive: true,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Support
            _buildSectionCard(
              'Support',
              Icons.help,
              [
                _buildListTile(
                  'Help Center',
                  'Get help and support',
                  Icons.help_center,
                  () => _openHelpCenter(),
                ),
                _buildListTile(
                  'Contact Us',
                  'Send us a message',
                  Icons.email,
                  () => _contactUs(),
                ),
                _buildListTile(
                  'Rate App',
                  'Rate us on app store',
                  Icons.star,
                  () => _rateApp(),
                ),
                _buildListTile(
                  'About',
                  'App version and info',
                  Icons.info,
                  () => _showAbout(),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA4C89).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFFEA4C89), size: 24),
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
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, Widget switchWidget) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFEA4C89).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFFEA4C89), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: switchWidget,
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, IconData icon, String value, List<String> options, Function(String?) onChanged) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFEA4C89).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFFEA4C89), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        items: options.map((option) => DropdownMenuItem(
          value: option,
          child: Text(option),
        )).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive 
              ? Colors.red.withValues(alpha: 0.1)
              : const Color(0xFFEA4C89).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon, 
          color: isDestructive ? Colors.red : const Color(0xFFEA4C89), 
          size: 20
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Your wellness data will be exported as a JSON file. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data export started...')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Your privacy is important to us. We collect only the data necessary to provide you with wellness support. Your personal information is never shared with third parties.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using this app, you agree to our terms of service. This app is designed for educational and wellness purposes only.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password change feature coming soon...')),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action cannot be undone. All your data will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion feature coming soon...')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help center coming soon...')),
    );
  }

  void _contactUs() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact feature coming soon...')),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rating feature coming soon...')),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Student Wellness'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('A comprehensive wellness app designed for students to track their mental health, practice meditation, and connect with peers anonymously.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
} 