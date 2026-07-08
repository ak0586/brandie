import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Horizontal tab row beneath the app bar.
/// Shows 4 tabs: Smart Post (active), Library, Communities, Share&Win.
class SmartPostTabRow extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabSelected;

  const SmartPostTabRow({
    super.key,
    required this.activeIndex,
    required this.onTabSelected,
  });

  static const _tabs = ['Smart Post', 'Library', 'Communities', 'Share&Win'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isActive = i == activeIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      _tabs[i],
                      style: isActive
                          ? AppTextStyles.tabActive
                          : AppTextStyles.tabInactive,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 2,
                    color: isActive ? AppColors.accent : Colors.transparent,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

