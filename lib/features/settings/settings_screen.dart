import 'package:ekklesia/services/user_service.dart';
import 'package:ekklesia/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:ekklesia/features/home/splash_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final userService = UserService();
  late Future<String> _displayName;

  @override
  void initState() {
    super.initState();
    _displayName = userService.getDisplayName();
  }

  Future<void> _signOut() async {
    userService.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primary),
        title: const Text(
          'Settings',
          style: TextStyle(color: AppColors.primary),
        ),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centered avatar and name
            FutureBuilder<String>(
              future: _displayName,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                }
                return Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          snapshot.data!.isNotEmpty
                              ? snapshot.data![0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 36,
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        snapshot.data!,
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
            const Divider(),

            // Settings items
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primary),
              title: const Text(
                'Sign Out',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              onTap: _signOut,
            ),
          ],
        ),
      ),
    );
  }
}
