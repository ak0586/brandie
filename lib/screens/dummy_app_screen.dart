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

