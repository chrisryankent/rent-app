// TODO Implement this library.
// favorites_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/property.dart';
import '../widgets/property_card.dart';
import '../tenant_screens/room_detail_screen.dart';
import '../models/user.dart' as app_user;

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final String userId;
  late final FirebaseFirestore firestore;
  late final FirebaseAuth auth;
  List<Property> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      userId = user.uid;
      _fetchFavorites();
    } else {
      userId = '';
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchFavorites() async {
    setState(() => isLoading = true);
    try {
      final favSnap = await firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();
      final propertyIds = favSnap.docs.map((doc) => doc.id).toList();
      if (propertyIds.isEmpty) {
        setState(() {
          favorites = [];
          isLoading = false;
        });
        return;
      }
      final propSnap = await firestore
          .collection('properties')
          .where(FieldPath.documentId, whereIn: propertyIds)
          .get();
      setState(() {
        favorites = propSnap.docs
            .map((doc) => Property.fromFirestore(doc))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        favorites = [];
        isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(Property property) async {
    final favRef = firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(property.id);
    final favDoc = await favRef.get();
    if (favDoc.exists) {
      await favRef.delete();
    } else {
      await favRef.set({'addedAt': FieldValue.serverTimestamp()});
    }
    _fetchFavorites();
  }

  void _navigateToDetail(Property property) async {
    final landlordSnap = await firestore
        .collection('users')
        .doc(property.ownerId)
        .get();
    final landlord = app_user.User.fromFirestore(landlordSnap);
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PropertyDetailScreen(
          property: property,
          onFavorite: () => _toggleFavorite(property),
          isFavorite: true,
          owner: landlord,
        ),
      ),
    );
  }

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
            icon: const Icon(Icons.refresh),
            onPressed: _fetchFavorites,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
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
                        onFavorite: () => _toggleFavorite(property),
                        onTap: () => _navigateToDetail(property),
                        isNew: property.isNew ?? false,
                        isRecommended: property.isRecommended ?? false,
                        isFeatured: property.isFeatured ?? false,
                      );
                    }, childCount: favorites.length),
                  ),
                ),
              ],
            ),
    );
  }
}
