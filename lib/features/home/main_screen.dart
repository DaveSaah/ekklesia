import 'package:ekklesia/features/event/event_screen.dart';
import 'package:ekklesia/features/home/home_screen.dart';
import 'package:ekklesia/features/prayer/prayer_screen.dart';
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
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake_outlined),
            activeIcon: Icon(Icons.handshake),
            label: 'Prayer Board',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
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
