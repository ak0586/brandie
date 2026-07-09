import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/share_target.dart';

class DummyAppScreen extends StatelessWidget {
  final ShareTarget target;

  const DummyAppScreen({super.key, required this.target});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (target.platform == SharePlatform.snapchat || 
                target.platform == SharePlatform.mail || 
                target.platform == SharePlatform.tiktok)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  target.iconPath,
                  width: 48, // 48 + 16*2 = 80 total size
                  height: 48,
                ),
              )
            else
              Image.asset(
                target.iconPath,
                width: 80,
                height: 80,
              ),
            const SizedBox(height: 24),
            Text(
              'Launched ${target.platformName}',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

