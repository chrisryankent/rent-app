// TODO Implement this library.
// favorites_screen.dart
import 'package:flutter/material.dart';
import '../models/property.dart';
import '../widgets/property_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Property> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                      final property = favorites[index];
                      return PropertyCard(
                        property: property,
                        isFavorite: true,
                        onFavorite: () {},
                        onTap: () {
                          // TODO: Navigate to property detail screen
                        },
                        isNew: true,
                        isRecommended: true,
                        isFeatured: false,
                      );
                    }, childCount: favorites.length),
                  ),
                ),
              ],
            ),
    );
  }
}
