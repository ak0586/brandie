import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Reusable Oriflame logo text widget used across all screens.
class OriflameLogoText extends StatelessWidget {
  const OriflameLogoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ORIFLAME',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'SWEDEN',
          style: GoogleFonts.inter(
            fontSize: 8,
            fontWeight: FontWeight.w400,
            letterSpacing: 4,
            color: AppColors.textSecondary,
          ),
        ),
      ],
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
          _IconWithLabel(
            icon: Icons.auto_awesome,
            label: 'Your Assistant',
            onTap: () {},
          ),
          const Expanded(child: Center(child: OriflameLogoText())),
          _IconWithLabel(
            icon: Icons.camera_alt_outlined,
            label: 'Camera',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _IconWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _IconWithLabel({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.navBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

