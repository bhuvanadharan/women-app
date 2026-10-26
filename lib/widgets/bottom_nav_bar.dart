import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum SafeHerTab { home, tracking, history, profile }

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.current,
    required this.onSelect,
  });

  final SafeHerTab current;
  final ValueChanged<SafeHerTab> onSelect;

  static const _items = [
    (
      tab: SafeHerTab.home,
      label: 'Home',
      icon: Icons.home_rounded,
      outlineIcon: Icons.home_outlined,
    ),
    (
      tab: SafeHerTab.tracking,
      label: 'Tracking',
      icon: Icons.explore_rounded,
      outlineIcon: Icons.explore_outlined,
    ),
    (
      tab: SafeHerTab.history,
      label: 'History',
      icon: Icons.history_rounded,
      outlineIcon: Icons.history_rounded,
    ),
    (
      tab: SafeHerTab.profile,
      label: 'Profile',
      icon: Icons.person_rounded,
      outlineIcon: Icons.person_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        border: Border.all(color: AppColors.neutral200),
        borderRadius: BorderRadius.circular(AppRadius.r12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120E302A),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          for (final item in _items)
            Expanded(
              child: _NavItem(
                item: item,
                active: item.tab == current,
                onSelect: onSelect,
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.active,
    required this.onSelect,
  });

  final ({SafeHerTab tab, String label, IconData icon, IconData outlineIcon})
  item;
  final bool active;
  final ValueChanged<SafeHerTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onSelect(item.tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.r5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                active ? item.icon : item.outlineIcon,
                key: ValueKey(active),
                color: active ? AppColors.primary : AppColors.navInactive,
                size: 21,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.b5.copyWith(
                color: active ? AppColors.primary : AppColors.navInactive,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
