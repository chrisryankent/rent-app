// TODO Implement this library
import 'package:flutter/material.dart';
import 'package:rental_connect/tenant_screens/models/room.dart';

class CompareScreen extends StatelessWidget {
  final List<Room> rooms;
  const CompareScreen({super.key, required this.rooms});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Rooms'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: rooms.isEmpty
          ? Center(
              child: Text(
                'No rooms to compare',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
            )
          : ListView.separated(
              itemCount: rooms.length,
              separatorBuilder: (context, index) =>
                  Divider(color: theme.dividerColor),
              itemBuilder: (context, index) {
                final room = rooms[index];
                return Card(
                  color: theme.cardColor,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                        room.images.isNotEmpty
                            ? room.images[0]
                            : 'assets/placeholder.jpg',
                      ),
                      radius: 28,
                    ),
                    title: Text(
                      room.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${room.price} - ${room.location}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.bed,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text('${room.bedrooms} bd'),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.bathtub,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text('${room.bathrooms} ba'),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.square_foot,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text('${room.size} sqft'),
                          ],
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: theme.iconTheme.color,
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
    );
  }
}
