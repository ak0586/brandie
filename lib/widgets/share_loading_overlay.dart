import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

/// Share loading overlay shown when user taps a Quick Share icon.
/// Shows a circular progress indicator + "Generating your sales link.."
/// text with a linear progress bar over a blurred/dimmed background.
/// Dismisses automatically after [duration] and shows a completion SnackBar.
class ShareLoadingOverlay extends StatefulWidget {
  final String platformName;
  final Duration duration;
  final VoidCallback onComplete;

  const ShareLoadingOverlay({
    super.key,
    required this.platformName,
    this.duration = const Duration(milliseconds: 1800),
    required this.onComplete,
  });

  @override
  State<ShareLoadingOverlay> createState() => _ShareLoadingOverlayState();
}

class _ShareLoadingOverlayState extends State<ShareLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;

  final List<String> _loadingTexts = [
    'Generating your sales link..',
    'Copying the caption to clipboard',
    'Saving the content to your profile',
    'Preparing the content for social media'
  ];

  @override
  void initState() {
    super.initState();
    // Extend duration slightly so we can read all texts comfortably
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..forward();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dimmed blurred background
        Positioned.fill(
          child: GestureDetector(
            // Block taps while loading
            onTap: () {},
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: AppColors.overlayDim,
              ),
            ),
          ),
        ),
        // White card in the centre
        Center(
          child: Container(
            width: 280,
            padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xl, horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _progressController,
              builder: (context, _) {
                // Determine text based on progress
                final progress = _progressController.value;
                int textIndex = (progress * 4).floor();
                if (textIndex > 3) textIndex = 3;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Thick Circular progress indicator (spinning indefinitely)
                    SizedBox(
                      width: 54,
                      height: 54,
                      child: CircularProgressIndicator(
                        strokeWidth: 7,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.accent),
                        backgroundColor: AppColors.accent.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      _loadingTexts[textIndex],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Thick Linear Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.accent),
                        minHeight: 8,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

