// room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'models/room.dart';
import 'chat_screen.dart';
import 'widgets/filter_chip.dart';
import 'widgets/comment_item.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;
  final VoidCallback onFavorite;
  final bool isFavorite;

  const RoomDetailScreen({
    super.key,
    required this.room,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [
    "Is the room available from next month?",
    "Are utilities included in the rent?",
    "What's the parking situation?",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    itemCount: widget.room.images.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        widget.room.images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: IconButton(
                      icon: Icon(
                        widget.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                        color: widget.isFavorite ? Colors.red : Colors.white,
                        size: 28,
                      ),
                      onPressed: widget.onFavorite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Property title and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.room.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '\$${widget.room.price}/mo',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                
                // Location
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Iconsax.location, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      widget.room.location,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                
                // Rating and time
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Iconsax.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.room.rating} (${widget.room.reviews} reviews)',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.room.timeAgo,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                
                // Features
                const SizedBox(height: 24),
                const Text(
                  'Features',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FeatureChip(icon: Iconsax.user_square, text: '${widget.room.size} sqft'),
                    FeatureChip(icon: Iconsax.battery_disable, text: '${widget.room.bedrooms} Bedrooms'),
                    FeatureChip(icon: Iconsax.gallery, text: '${widget.room.bathrooms} Bathrooms'),
                    FeatureChip(icon: Iconsax.car, text: widget.room.parking ? 'Parking' : 'No Parking'),
                    FeatureChip(icon: Iconsax.pet, text: widget.room.petFriendly ? 'Pet Friendly' : 'No Pets'),
                    FeatureChip(icon: Iconsax.wifi, text: 'WiFi Included'),
                  ],
                ),
                
                // Description
                const SizedBox(height: 24),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.room.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                
                // Map
                const SizedBox(height: 24),
                const Text(
                  'Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.blue[50],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.map, size: 48, color: Colors.blue),
                        const SizedBox(height: 16),
                        Text(
                          '${widget.room.distance} miles from city center',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Comments
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Comments & Questions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ]),
            ),
          ),
          
          // Comments list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return CommentItem(
                  comment: _comments[index],
                  isOwner: index == 1,
                  ownerReply: index == 1 ? "Yes, utilities are included" : null,
                );
              },
              childCount: _comments.length,
            ),
          ),
          
          // Add comment
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Ask a question...',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(Iconsax.send1, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Fixed contact button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          icon: const Icon(Iconsax.message),
          label: const Text('Contact Landlord'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(landlord: widget.room.landlord),
            ),
          ),
        ),
      ),
    );
  }
}