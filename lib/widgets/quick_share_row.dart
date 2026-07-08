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
        width: 36,
        height: 36,
        child: _platformIcon(target.platform, target.variant),
      ),
    );
  }

  Widget _platformIcon(SharePlatform platform, ShareVariant variant) {
    switch (platform) {
      case SharePlatform.instagram:
        // Instagram Feed = standard gradient; Story = slightly lighter
        return _GradientCircleIcon(
          gradient: variant == ShareVariant.feed
              ? const LinearGradient(
                  colors: [
                    Color(0xFFF58529),
                    Color(0xFFDD2A7B),
                    Color(0xFF8134AF),
                    Color(0xFF515BD4),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFF9CE34),
                    Color(0xFFEE2A7B),
                    Color(0xFF6228D7),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
          icon: Icons.camera_alt,
        );

      case SharePlatform.facebook:
        return _SolidCircleIcon(
          color: variant == ShareVariant.feed
              ? const Color(0xFF1877F2)
              : const Color(0xFF3B5998),
          icon: Icons.facebook,
        );

      case SharePlatform.messenger:
        return _GradientCircleIcon(
          gradient: const LinearGradient(
            colors: [Color(0xFF0095FF), Color(0xFFA334FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          icon: Icons.message_rounded,
        );

      case SharePlatform.tiktok:
        return _SolidCircleIcon(
          color: Colors.black,
          icon: Icons.music_video,
        );

      case SharePlatform.whatsapp:
        return _SolidCircleIcon(
          color: const Color(0xFF25D366),
          icon: Icons.chat,
        );

      case SharePlatform.telegram:
        return _SolidCircleIcon(
          color: const Color(0xFF229ED9),
          icon: Icons.send,
        );

      case SharePlatform.mail:
        return _SolidCircleIcon(
          color: const Color(0xFF78909C),
          icon: Icons.mail_outline,
        );

      case SharePlatform.snapchat:
        return _SolidCircleIcon(
          color: const Color(0xFFFFFC00),
          icon: Icons.catching_pokemon,
          iconColor: Colors.black,
        );
    }
  }
}

class _SolidCircleIcon extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;

  const _SolidCircleIcon({
    required this.color,
    required this.icon,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 18),
    );
  }
}

class _GradientCircleIcon extends StatelessWidget {
  final LinearGradient gradient;
  final IconData icon;

  const _GradientCircleIcon({
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}

