import 'package:ekklesia/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: AppColors.background,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to Family of Christ Church!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'We’re thrilled to have you join us. Here’s what you need to know:',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 24),
                _buildGuideItem(
                  icon: Icons.location_on,
                  title: 'Location',
                  description:
                      'We meet everyday at the Sanctuary. Visit us for a time of communion and prayer!',
                ),
                _buildGuideItem(
                  icon: Icons.access_time,
                  title: 'Service Times',
                  description: 'Sunday Service: 07:00 PM - 08:30 PM.',
                ),
                _buildGuideItem(
                  icon: Icons.people,
                  title: 'Meet the Pastoral Team',
                  description:
                      'Our warm and welcoming pastors would love to meet you after the service at the visitor’s lounge.',
                ),
                _buildGuideItem(
                  icon: Icons.local_cafe,
                  title: 'Visitor Fellowship',
                  description:
                      'Join us for refreshments and a brief orientation right after service at the New Visitor’s Lounge.',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewVisitorGuideScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Learn more',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewVisitorGuideScreen extends StatelessWidget {
  const NewVisitorGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: IconThemeData(color: AppColors.icon),
        title: const Text(
          'About Our Church',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Intro Section
          Center(
            child: Column(
              children: [
                Icon(Icons.church, size: 50, color: AppColors.primary),
                const SizedBox(height: 12),
                Text(
                  'Family of Christ Church',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'A place where everyone belongs.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Info Sections
          _buildInfoSection(
            icon: Icons.calendar_month,
            title: 'Date Founded & By Whom',
            description:
                'Family of Christ Church was founded on 12th January 2017 by Brother Gervarse with a simple vision of praying together with fellow believers.',
          ),
          _buildInfoSection(
            icon: Icons.history_edu,
            title: 'How It Started',
            description:
                "It began as a small prayer gathering Brother Gervarse's home with just 6 members. From those humble beginnings, it grew steadily through word of mouth, community outreach, and unwavering faith.",
          ),
          _buildInfoSection(
            icon: Icons.visibility,
            title: 'Our Vision',
            description:
                'To become a global family of believers who model the love of Christ and transform lives through faith, hope, and service.',
          ),
          _buildInfoSection(
            icon: Icons.flag,
            title: 'Our Mission',
            description:
                'To nurture each other, foster authentic relationships, and empower our members to serve their communities and the world through the gospel.',
          ),
          _buildInfoSection(
            icon: Icons.phone_android,
            title: 'Purpose of This App',
            description:
                'This app was created to help members and visitors stay connected, access church resources, sign up for events, submit prayer requests, and grow in faith — anytime, anywhere.',
          ),
          _buildInfoSection(
            icon: Icons.link,
            title: 'Free Resources for Your Faith Growth',
            description:
                'Explore devotionals, sermon archives, worship playlists, and study plans for your spiritual journey.',
            buttonLabel: 'Visit Resources',
            onPressed: () => _launchUrl('https://hesed-server.web.app'),
          ),
          const SizedBox(height: 30),
          Center(
            child: Text(
              'We’re so glad you’re here!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String description,
    String? buttonLabel,
    VoidCallback? onPressed,
  }) {
    return Card(
      color: AppColors.background,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            if (buttonLabel != null && onPressed != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onPressed,
                child: Text(
                  buttonLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
