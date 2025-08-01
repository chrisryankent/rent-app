// main_app.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

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

  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoritesScreen(favorites: []),
    const MessagesScreen(),
    const ProfileScreen(),
  ];

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
            child: _pages[_currentIndex] is ScrollView
                ? PrimaryScrollController(
                    controller: _scrollController,
                    child: _pages[_currentIndex],
                  )
                : _pages[_currentIndex],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: _showNavBar ? 0 : -80,
            child: Material(
              color:
                  theme.bottomNavigationBarTheme.backgroundColor ??
                  theme.cardColor,
              elevation: 8,
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedItemColor: theme.colorScheme.primary,
                unselectedItemColor: theme.unselectedWidgetColor,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _currentIndex == 0
                            ? theme.colorScheme.primary.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _currentIndex == 0
                            ? Icons.home_filled
                            : Icons.home_outlined,
                        size: 26,
                      ),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _currentIndex == 1
                            ? theme.colorScheme.primary.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _currentIndex == 1
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 26,
                      ),
                    ),
                    label: 'Favorites',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _currentIndex == 2
                            ? theme.colorScheme.primary.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _currentIndex == 2
                            ? Icons.chat_bubble
                            : Icons.chat_bubble_outline,
                        size: 26,
                      ),
                    ),
                    label: 'Messages',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _currentIndex == 3
                            ? theme.colorScheme.primary.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _currentIndex == 3
                            ? Icons.person
                            : Icons.person_outline,
                        size: 26,
                      ),
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
