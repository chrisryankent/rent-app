import 'package:flutter/material.dart';

class LandlordBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final VoidCallback onCreate;
  const LandlordBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color:
              (theme.bottomAppBarTheme.color ?? theme.colorScheme.surface).withOpacity(0.95),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: theme.dividerColor.withOpacity(0.18),
              width: 1.2,
            ),
          ),
        ),
        child: SizedBox(
          height: 56,
          child: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            shape: const CircularNotchedRectangle(),
            notchMargin: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavBarIcon(
                  icon: Icons.home,
                  label: 'Home',
                  selected: currentIndex == 0,
                  onTap: () => onTap(0),
                  theme: theme,
                ),
                _NavBarIcon(
                  icon: Icons.message,
                  label: 'Messages',
                  selected: currentIndex == 1,
                  onTap: () => onTap(1),
                  theme: theme,
                ),
                const SizedBox(width: 36),
                _NavBarIcon(
                  icon: Icons.analytics,
                  label: 'Analytics',
                  selected: currentIndex == 2,
                  onTap: () => onTap(2),
                  theme: theme,
                ),
                _NavBarIcon(
                  icon: Icons.person,
                  label: 'Profile',
                  selected: currentIndex == 3,
                  onTap: () => onTap(3),
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;
  const _NavBarIcon({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      splashColor: theme.colorScheme.primary.withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                key: ValueKey(selected),
                size: 18,
                color: selected ? theme.colorScheme.primary : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 1),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 9,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? theme.colorScheme.primary : Colors.grey.shade500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class LandlordFAB extends StatelessWidget {
  final VoidCallback onCreate;
  const LandlordFAB({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      onPressed: onCreate,
      backgroundColor: theme.colorScheme.primary,
      elevation: 8,
      shape: const CircleBorder(),
      tooltip: 'Create Property',
      mini: true,
      child: const Icon(Icons.add, size: 28),
    );
  }
}