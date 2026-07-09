import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Bottom navigation bar for the app.
/// 5 icons: Share/Rocket (active), Search, Home, Chat, Profile.
class SmartPostBottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onItemTap;

  const SmartPostBottomNav({
    super.key,
    required this.activeIndex,
    required this.onItemTap,
  });

  static const _items = [
    _NavItem(assetPath: 'assets/icons/boost.png', label: 'Share'),
    _NavItem(assetPath: 'assets/icons/search.png', label: 'Search'),
    _NavItem(assetPath: 'assets/icons/home.png', label: 'Home'),
    _NavItem(assetPath: 'assets/icons/chat.png', label: 'Chat'),
    _NavItem(assetPath: 'assets/icons/profile.png', label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_items.length, (i) {
        final isActive = i == activeIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onItemTap(i),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _items[i].assetPath,
                  color: isActive ? AppColors.accent : AppColors.textTertiary,
                  width: i == 0 ? 46 : 32,
                  height: i == 0 ? 46 : 32,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _NavItem {
  final String assetPath;
  final String label;

  const _NavItem({
    required this.assetPath,
    required this.label,
  });
}
