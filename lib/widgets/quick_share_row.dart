import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/smart_post_content.dart';
import '../models/share_target.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';

/// Horizontally scrollable row of platform share icons.
/// Overflows screen width by design (per Figma spec).
/// Uses ListView(scrollDirection: Axis.horizontal) for native feel.
class QuickShareRow extends StatelessWidget {
  final SmartPostContent post;
  final ValueChanged<String> onShareTap; // passes platform name

  const QuickShareRow({
    super.key,
    required this.post,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Quick share to:',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.shareTargets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final target = MockData.shareTargets[i];
                return _ShareIcon(
                  target: target,
                  onTap: () => onShareTap(target.platformName),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Single platform icon button in the Quick Share row.
class _ShareIcon extends StatelessWidget {
  final ShareTarget target;
  final VoidCallback onTap;

  const _ShareIcon({required this.target, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Image.asset(target.iconPath),
      ),
    );
  }
}
