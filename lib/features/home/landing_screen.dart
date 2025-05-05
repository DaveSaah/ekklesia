import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ekklesia/features/auth/login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _textController;
  late Animation<double> _fadeAnimation;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    );

    _textController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> landingData = [
    {
      'image': 'assets/images/church_welcome.jpg',
      'title': 'Welcome to Family of Christ Church!',
      'verse':
          '"I was glad when they said unto me, Let us go into the house of the Lord." - Psalm 122:1',
    },
    {
      'image': 'assets/images/church_welcome.jpg',
      'title': 'A Place for Everyone',
      'verse':
          '"For where two or three gather in my name, there am I with them." - Matthew 18:20',
    },
    {
      'image': 'assets/images/church_welcome.jpg',
      'title': 'Grow Your Faith with Us',
      'verse':
          '"Your word is a lamp for my feet, a light on my path." - Psalm 119:105',
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _textController.reset();
      _textController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: landingData.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final item = landingData[index];
              return Stack(
                children: [
                  Image.asset(
                    item['image']!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black.withValues(alpha: 128)),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['title']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              item['verse']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: landingData.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 10,
                  activeDotColor: Theme.of(context).primaryColor,
                  dotColor: Colors.white54,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == landingData.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                _currentPage == landingData.length - 1 ? 'Get Started' : 'Next',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
