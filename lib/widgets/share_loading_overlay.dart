import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
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
            child: Container(
              color: AppColors.overlayDim,
            ),
          ),
        ),
        // White card in the centre
        Center(
          child: Container(
            width: 220,
            padding: const EdgeInsets.all(AppSpacing.xl),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular progress indicator in green ring style
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.accent),
                    backgroundColor: AppColors.accentDisabled,
                    value: _progressController.value,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Generating your sales link..',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                // Progress bar
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (_, __) => ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progressController.value,
                      backgroundColor: AppColors.accentDisabled,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.accent),
                      minHeight: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

