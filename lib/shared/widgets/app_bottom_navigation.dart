import 'package:expenzia/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onAddPressed;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.primary,
      elevation: 0,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 68,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavigationItem(
              icon: Icons.home_outlined,
              label: AppStrings.home,
              index: 0,
              currentIndex: currentIndex,
              onTap: onDestinationSelected,
            ),
            _NavigationItem(
              icon: Icons.history,
              label: AppStrings.transactions,
              index: 1,
              currentIndex: currentIndex,
              onTap: onDestinationSelected,
            ),
            const SizedBox(width: 64),
            _NavigationItem(
              icon: Icons.account_balance_wallet_outlined,
              label: AppStrings.credit,
              index: 2,
              currentIndex: currentIndex,
              onTap: onDestinationSelected,
            ),
            _NavigationItem(
              icon: Icons.person_outline,
              label: AppStrings.profile,
              index: 3,
              currentIndex: currentIndex,
              onTap: onDestinationSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;

    return IconButton(
      tooltip: label,
      onPressed: () => onTap(index),
      icon: Icon(
        icon,
        size: AppDimensions.iconSize,
        color: isSelected ? Colors.white : Colors.white54,
      ),
    );
  }
}
