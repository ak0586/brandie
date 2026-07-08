import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'smart_post_screen.dart';

/// Loading screen shown while "generating" personalised Smart Posts.
/// Animates 4 checklist steps to a checked green state one-by-one,
/// then auto-navigates to [SmartPostScreen] after a brief final message.
class GeneratingPostsScreen extends StatefulWidget {
  const GeneratingPostsScreen({super.key});

  @override
  State<GeneratingPostsScreen> createState() => _GeneratingPostsScreenState();
}

class _GeneratingPostsScreenState extends State<GeneratingPostsScreen> {
  /// Tracks how many steps have been checked off (0 = none, 4 = all).
  int _checkedCount = 0;

  /// Whether to show the "All set!" final message.
  bool _showAllSet = false;

  late final List<Timer> _timers;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timers = [];
    // Check each step with a 1.2-second gap between steps.
    for (int i = 0; i < MockData.loadingSteps.length; i++) {
      final delay = Duration(milliseconds: 900 + i * 1200);
      _timers.add(Timer(delay, () {
        if (mounted) {
          setState(() => _checkedCount = i + 1);
        }
      }));
    }

    // After all 4 steps: show "All set!" message.
    _timers.add(Timer(const Duration(milliseconds: 6000), () {
      if (mounted) setState(() => _showAllSet = true);
    }));

    // Then navigate to the main Smart Post screen.
    _timers.add(Timer(const Duration(milliseconds: 7500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => const SmartPostScreen(),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    }));
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loadingBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabRow(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  /// The loading screen shares the same AppBar/TabRow as the main screen
  /// so the transition feels seamless (matching the Figma prototype exactly).
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Placeholder left icon (AI assistant icon in dark circle)
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.navBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(
            child: Center(
              child: _OriflameLogoText(),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Camera icon button (top-right)
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.navBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabRow() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _TabItem(label: 'Smart Post', isActive: true),
          _TabItem(label: 'Library', isActive: false),
          _TabItem(label: 'Communities', isActive: false),
          _TabItem(label: 'Share&Win', isActive: false),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Building personalised\nSmart Posts for you!',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          // Checklist steps
          ...List.generate(MockData.loadingSteps.length, (i) {
            return _LoadingStep(
              text: MockData.loadingSteps[i],
              isChecked: _checkedCount > i,
              // Each step animates slightly after the previous
              delay: Duration(milliseconds: i * 1200),
            );
          }),
          const SizedBox(height: AppSpacing.xl),
          // "All set!" message fades in after all steps are done
          AnimatedOpacity(
            opacity: _showAllSet ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 600),
            child: Center(
              child: Text(
                'All set! Get ready to share...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single checklist item that transitions from empty circle to green check.
class _LoadingStep extends StatelessWidget {
  final String text;
  final bool isChecked;
  final Duration delay;

  const _LoadingStep({
    required this.text,
    required this.isChecked,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: isChecked
                ? const Icon(
                    Icons.check_circle,
                    color: AppColors.accent,
                    size: 20,
                    key: ValueKey('checked'),
                  )
                : Container(
                    key: const ValueKey('unchecked'),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.tabInactive,
                        width: 1.5,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isChecked
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
                fontWeight:
                    isChecked ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Oriflame brand name rendered in text (no image asset needed).
class _OriflameLogoText extends StatelessWidget {
  const _OriflameLogoText();

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

/// A simple tab item with green underline when active.
class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;

  const _TabItem({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(
              label,
              style: isActive
                  ? AppTextStyles.tabActive
                  : AppTextStyles.tabInactive,
              textAlign: TextAlign.center,
            ),
          ),
          if (isActive)
            Container(
              height: 2,
              color: AppColors.accent,
            )
          else
            const SizedBox(height: 2),
        ],
      ),
    );
  }
}

