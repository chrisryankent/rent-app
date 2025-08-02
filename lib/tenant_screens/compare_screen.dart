// TODO Implement this library
import 'package:flutter/material.dart';
import 'package:rental_connect/models/property.dart';
import '../widgets/property_card.dart';

class CompareScreen extends StatelessWidget {
  final List<Property> properties;
  const CompareScreen({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Compare Properties'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: properties.isEmpty
          ? Center(
              child: Text(
                'No properties to compare',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
            )
          : ListView.separated(
              itemCount: properties.length,
              separatorBuilder: (context, index) => Divider(color: theme.dividerColor),
              itemBuilder: (context, index) {
                final property = properties[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: PropertyCard(
                    property: property,
                    isFavorite: false,
                    onFavorite: () {},
                    onTap: () {},
                    isFeatured: false,
                    isNew: false,
                    isRecommended: false,
                  ),
                );
              },
            ),
    );
  }
}
