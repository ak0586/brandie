import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/generating_posts_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const BrandieApp());
}

class BrandieApp extends StatelessWidget {
  const BrandieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oriflame Smart Post',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      home: const GeneratingPostsScreen(),
    );
  }
}
