import 'package:ekklesia/features/home/splash_screen.dart';
import 'package:ekklesia/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        fontFamily: "Inter",
        primaryColor: AppColors.primary,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
          displayMedium: TextStyle(
            color: AppColors.secondary,
            fontSize: 28,
            fontWeight: FontWeight.w400,
          ),
          displaySmall: TextStyle(
            color: AppColors.secondary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
