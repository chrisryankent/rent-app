// main_app.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';
import 'models/room.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  bool _showNavBar = true;
  double _lastOffset = 0;
  final ScrollController _scrollController = ScrollController();

  final List<Room> _favorites = [];

  void _toggleFavorite(Room room) {
    setState(() {
      if (_favorites.contains(room)) {
        _favorites.remove(room);
      } else {
        _favorites.add(room);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    if (offset > _lastOffset && offset - _lastOffset > 10 && _showNavBar) {
      setState(() => _showNavBar = false);
    } else if (offset < _lastOffset &&
        _lastOffset - offset > 10 &&
        !_showNavBar) {
      setState(() => _showNavBar = true);
    }
    _lastOffset = offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Widget> pages = [
      HomeScreen(
        scrollController: _scrollController,
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
      ),
      FavoritesScreen(favorites: _favorites),
      MessagesScreen(),
      ProfileScreen(),
    ];
    return Scaffold(
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is UserScrollNotification) {
                _onScroll();
              }
              return false;
            },
            child: pages[_currentIndex] is ScrollView
                ? PrimaryScrollController(
                    controller: _scrollController,
                    child: pages[_currentIndex],
                  )
                : pages[_currentIndex],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: _showNavBar ? 0 : -80,
            child: _CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final ThemeData theme;

  const _CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: (theme.bottomAppBarTheme.color ?? theme.colorScheme.surface).withOpacity(0.95),
      elevation: 8,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavBarIcon(
                  icon: Iconsax.home,
                  activeIcon: Iconsax.home_25,
                  label: 'Home',
                  selected: currentIndex == 0,
                  onTap: () => onTap(0),
                  theme: theme,
                ),
                _NavBarIcon(
                  icon: Iconsax.heart,
                  activeIcon: Iconsax.heart5,
                  label: 'Favorites',
                  selected: currentIndex == 1,
                  onTap: () => onTap(1),
                  theme: theme,
                ),
                _NavBarIcon(
                  icon: Iconsax.message,
                  activeIcon: Iconsax.message5,
                  label: 'Messages',
                  selected: currentIndex == 2,
                  onTap: () => onTap(2),
                  theme: theme,
                ),
                _NavBarIcon(
                  icon: Iconsax.profile,
                  activeIcon: Iconsax.profile,
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
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _NavBarIcon({
    required this.icon,
    required this.activeIcon,
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
                selected ? activeIcon : icon,
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