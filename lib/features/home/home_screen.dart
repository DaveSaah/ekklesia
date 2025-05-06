import 'package:ekklesia/features/home/event_card.dart';
import 'package:ekklesia/features/home/welcome_screen.dart';
import 'package:ekklesia/services/user_service.dart';
import 'package:ekklesia/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userService = UserService();
  late Future<String> _displayName;

  @override
  void initState() {
    super.initState();
    _displayName = userService.getDisplayName(); // Fetch latest event
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Hello, $displayName"),
            FutureBuilder<String>(
              future: _displayName,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      bottom: 8,
                      top: 8,
                    ),
                    child: Text(
                      "Hello, ${snapshot.data}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                } else {
                  return Text("");
                }
              },
            ),
            // Event card
            EventCard(),
            WelcomeScreen(),
          ],
        ),
      ),
    );
  }
}
