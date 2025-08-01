// TODO Implement this library.
// favorites_screen.dart
import 'package:flutter/material.dart';
import 'room_detail_screen.dart';
import 'models/room.dart';
import 'widgets/room_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Room> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_customize),
            onPressed: () {},
          ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: theme.disabledColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No favorites yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap the heart icon to save properties',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final room = favorites[index];
                      return RoomCard(
                        room: room,
                        isFavorite: true,
                        onFavorite: () {},
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomDetailScreen(
                              room: room,
                              onFavorite: () {},
                              isFavorite: true,
                            ),
                          ),
                        ),
                        isNew: true,
                        isRecommended: true,
                      );
                    }, childCount: favorites.length),
                  ),
                ),
              ],
            ),
    );
  }
}
