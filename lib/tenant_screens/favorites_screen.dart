// TODO Implement this library.
// favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'room_detail_screen.dart';
import 'models/room.dart';
import 'widgets/room_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Room> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.command),
            onPressed: () {},
          ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.heart, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  const Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap the heart icon to save properties',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
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
                          ), isNew: true, isRecommended: true,
                        );
                      },
                      childCount: favorites.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}