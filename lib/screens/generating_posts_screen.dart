import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'smart_post_screen.dart';
import '../widgets/smart_post_app_bar.dart';
import '../widgets/smart_post_tab_row.dart';

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
    return const SmartPostAppBar();
  }

  Widget _buildTabRow() {
    return SmartPostTabRow(
      activeIndex: 0,
      onTabSelected: (_) {},
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
                color:
                    isChecked ? AppColors.textPrimary : AppColors.textTertiary,
                fontWeight: isChecked ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
