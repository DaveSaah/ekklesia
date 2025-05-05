import 'package:ekklesia/features/event/event_screen.dart';
import 'package:ekklesia/features/home/home_screen.dart';
import 'package:ekklesia/features/prayer/prayer_screen.dart';
import 'package:ekklesia/features/settings/settings_screen.dart';
import 'package:ekklesia/features/volunteer/volunteer_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late Widget _currentScreen;

  @override
  void initState() {
    super.initState();
    _currentScreen = const HomeScreen();
  }

  void _setCurrentScreen(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          _currentScreen = const HomeScreen();
          break;
        case 1:
          _currentScreen = const EventScreen();
          break;
        case 2:
          _currentScreen = const PrayerScreen();
          break;
        case 3:
          _currentScreen = const VolunteerScreen();
          break;
        default:
          _currentScreen = const HomeScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ekklesia",
          style: TextStyle(color: Colors.orangeAccent),
        ),
        elevation: 2,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.orangeAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over_outlined),
            activeIcon: Icon(Icons.record_voice_over),
            label: 'Prayer Board',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.diversity_3_outlined),
            activeIcon: Icon(Icons.diversity_3),
            label: 'Volunteering',
          ),
        ],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 0,
        onTap: _setCurrentScreen,
      ),
    );
  }
}
