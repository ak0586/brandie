import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Reusable Oriflame logo text widget used across all screens.
class OriflameLogoText extends StatelessWidget {
  const OriflameLogoText({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'ORIFLAME',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  thickness: 0.5,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'SWEDEN',
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  thickness: 0.5,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Top app bar for the Smart Post screen.
/// Layout: [AI icon + "Your Assistant"] [ORIFLAME SWEDEN] [Camera icon + "Camera"]
class SmartPostAppBar extends StatelessWidget {
  const SmartPostAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _IconWithLabel(
                assetPath: 'assets/icons/AI_assistant.png',
                label: 'Your Assistant',
                onTap: () {},
              ),
            ),
          ),
          const OriflameLogoText(),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _IconWithLabel(
                assetPath: 'assets/icons/camera.png',
                label: 'Camera',
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconWithLabel extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onTap;

  const _IconWithLabel({
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 76,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(assetPath),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 9,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
