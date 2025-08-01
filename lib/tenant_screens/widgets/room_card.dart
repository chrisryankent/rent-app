// TODO Implement this library.
// room_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;
  final bool isFeatured;

  const RoomCard({
    super.key,
    required this.room,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
    this.isFeatured = false,
    required bool isNew,
    required bool isRecommended,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isFeatured ? 260 : 220, // Fixed height for grid/list
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room image with favorite button
              Stack(
                children: [
                  // Room image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(
                      room.imageUrl,
                      height: isFeatured ? 120 : 90,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Iconsax.heart5 : Iconsax.heart,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: onFavorite,
                    ),
                  ),

                  // Price tag
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\$${room.price}/mo',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Room details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        room.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Iconsax.location,
                            size: 13,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              room.location,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      // Removed features row (sqft, bedrooms, bathrooms) for minimal card
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.star, size: 14, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(
                                room.rating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          Text(
                            room.timeAgo,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
