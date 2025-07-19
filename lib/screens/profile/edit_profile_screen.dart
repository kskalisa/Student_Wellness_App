import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_profile.dart';
import '../../providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  UserProfile? _profile;
  final List<String> _universities = ['AUCA', 'ULK', 'MOK', 'Other'];
  final List<String> _interestOptions = [
    'Anxiety',
    'Depression',
    'Stress',
    'Sleep',
    'Relationships'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  void _loadProfile() {
    final userProvider = context.read<UserProvider>();
    if (userProvider.profile != null) {
      setState(() {
        _profile = UserProfile(
          userId: userProvider.profile!.userId,
          displayName: userProvider.profile!.displayName,
          avatarUrl: userProvider.profile!.avatarUrl,
          university: userProvider.profile!.university,
          interests: List<String>.from(userProvider.profile!.interests),
        );
      });
    } else {
      // Create a default profile if none exists
      setState(() {
        _profile = UserProfile(
          userId: 'default_user',
          displayName: 'Student',
          university: 'AUCA',
          interests: [],
        );
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null && _profile != null) {
        setState(() => _profile!.avatarUrl = image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDF6F8),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF97B8B),
          foregroundColor: Colors.white,
          title: const Text('Edit Profile'),
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF97B8B),
        foregroundColor: Colors.white,
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 54,
                      backgroundColor: const Color(0xFFFAD0C4),
                      backgroundImage: _profile!.avatarUrl != null
                          ? FileImage(File(_profile!.avatarUrl!))
                          : null,
                      child: _profile!.avatarUrl == null
                          ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Edit Profile',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Update your information and interests.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Display Name
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        initialValue: _profile!.displayName,
                        decoration: const InputDecoration(
                          labelText: 'Display Name',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => _profile!.displayName = value!,
                      ),
                    ),
                    const SizedBox(height: 18),
                    // University Dropdown
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _profile!.university,
                        items: _universities
                            .map((uni) => DropdownMenuItem(
                          value: uni,
                          child: Text(uni),
                        ))
                            .toList(),
                        onChanged: (value) => setState(() => _profile!.university = value!),
                        decoration: const InputDecoration(
                          labelText: 'University',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Interests Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interests',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFEA4C89),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children: _interestOptions.map((interest) {
                              return FilterChip(
                                label: Text(interest),
                                labelStyle: TextStyle(
                                  color: _profile!.interests.contains(interest)
                                      ? Colors.white
                                      : const Color(0xFFEA4C89),
                                  fontWeight: FontWeight.w600,
                                ),
                                selected: _profile!.interests.contains(interest),
                                selectedColor: const Color(0xFFEA4C89),
                                backgroundColor: const Color(0xFFFAD0C4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _profile!.interests.add(interest);
                                    } else {
                                      _profile!.interests.remove(interest);
                                    }
                                  });
                                },
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA4C89),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Save Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate() && _profile != null) {
      try {
        _formKey.currentState!.save();
        context.read<UserProvider>().updateProfile(_profile!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    }
  }
}