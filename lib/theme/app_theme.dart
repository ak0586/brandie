import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central place for all app-level design tokens.
/// Oriflame palette: dark navy app bar, signature green accent, coral/pink badges.
class AppColors {
  AppColors._();

  /// Oriflame signature green – used for active tabs, checkboxes, buttons.
  static const Color accent = Color(0xFF4CAF82);

  /// Darker shade of green used for filled elements.
  static const Color accentDark = Color(0xFF3A9B6E);

  /// Disabled/greyed-out state.
  static const Color accentDisabled = Color(0xFFB0D9C6);

  ///
  static const Color productIfoBackground = Color(0x29BBBBBB);

  ///
  static const Color captionBackground = Color(0x39313131);

  /// Dark navy for AppBar and BottomNavigationBar backgrounds.
  static const Color navBackground = Color(0xFF1A1A2E);

  /// Deep dark background used behind cards/page content.
  static const Color pageBackground = Color(0xFF0F0F1A);

  /// Standard white card background.
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// Light grey background.
  static const Color surfaceGrey = Color(0xFFF5F5F5);

  /// Pink/coral badge color for "Ready to share".
  static const Color readyBadge = Color(0xFFE91E8C);

  /// Muted grey for inactive tab labels.
  static const Color tabInactive = Color(0xFF9E9E9E);

  /// Black text on white cards.
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Secondary text (subtitles, captions).
  static const Color textSecondary = Color(0xFF555555);

  /// Tertiary/hint text.
  static const Color textTertiary = Color(0xFF888888);

  /// Overlay blur tint.
  static const Color overlayDim = Color(0x88000000);

  /// Product overlay bottom gradient start (transparent).
  static const Color productOverlayStart = Color(0x00000000);

  /// Product overlay bottom gradient end (semi-opaque dark).
  static const Color productOverlayEnd = Color(0xCC000000);

  /// White for text on dark backgrounds.
  static const Color textOnDark = Color(0xFFFFFFFF);

  /// Dot indicator active color.
  static const Color dotActive = Color(0xFF4CAF82);

  /// Dot indicator inactive color.
  static const Color dotInactive = Color(0x66FFFFFF);

  /// Sale/discount badge color.
  static const Color saleBadge = Color(0xFF4CAF82);

  /// Loading screen background – matches the Figma dark screen.
  static const Color loadingBackground = Color(0xFFFFFFFF);
}

class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading1 = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.textTertiary,
  );

  static TextStyle tabActive = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
  );

  static TextStyle tabInactive = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.tabInactive,
  );

  static TextStyle badgeText = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle referralText = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontStyle: FontStyle.italic,
  );

  static TextStyle cardOnDark = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
  );
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  static const double cardRadius = 16.0;
  static const double badgeRadius = 20.0;
  static const double buttonRadius = 12.0;
}
