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
    _NavItem(icon: Icons.share, label: 'Share'),
    _NavItem(icon: Icons.search, label: 'Search'),
    _NavItem(icon: Icons.home_outlined, label: 'Home'),
    _NavItem(icon: Icons.chat_bubble_outline, label: 'Chat'),
    _NavItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final isActive = i == activeIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onItemTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _items[i].icon,
                    color:
                        isActive ? AppColors.accent : AppColors.textTertiary,
                    size: 24,
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

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

