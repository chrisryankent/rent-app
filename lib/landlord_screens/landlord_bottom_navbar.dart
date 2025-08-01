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
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: theme.bottomAppBarTheme.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: currentIndex == 0 ? theme.primaryColor : Colors.grey,
            ),
            onPressed: () => onTap(0),
            tooltip: 'Home',
          ),
          IconButton(
            icon: Icon(
              Icons.message,
              color: currentIndex == 1 ? theme.primaryColor : Colors.grey,
            ),
            onPressed: () => onTap(1),
            tooltip: 'Messages',
          ),
          const SizedBox(width: 40), // space for FAB
          IconButton(
            icon: Icon(
              Icons.person,
              color: currentIndex == 2 ? theme.primaryColor : Colors.grey,
            ),
            onPressed: () => onTap(2),
            tooltip: 'Profile',
          ),
        ],
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
      backgroundColor: theme.primaryColor,
      child: const Icon(Icons.add, size: 32),
      elevation: 6,
      shape: const CircleBorder(),
      tooltip: 'Create Property',
    );
  }
}
