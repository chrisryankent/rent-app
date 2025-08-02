// property_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/property.dart';
import 'chat_screen.dart';
import '../widgets/filter_chip.dart';
import '../widgets/comment_item.dart';
import '../models/user.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;
  final VoidCallback onFavorite;
  final bool isFavorite;
  final User owner;

  const PropertyDetailScreen({
    super.key,
    required this.property,
    required this.onFavorite,
    required this.isFavorite,
    required this.owner,
  });

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [
    "Is the property available from next month?",
    "Are utilities included in the rent?",
    "What's the parking situation?",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    itemCount: widget.property.images?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        widget.property.images![index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: IconButton(
                      icon: Icon(
                        widget.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
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
                        widget.property.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.property.rentAmount}/mo',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                // Location
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: theme.hintColor),
                    const SizedBox(width: 8),
                    Text(
                      widget.property.address,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
                // Rating and time
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.property.bedrooms ?? '-'} bd, ${widget.property.bathrooms ?? '-'} ba',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.property.timeAgo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
                // Features
                const SizedBox(height: 24),
                Text(
                  'Features',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FeatureChip(
                      icon: Icons.square_foot,
                      text: '${widget.property.squareFootage ?? '-'} sqft',
                    ),
                    FeatureChip(
                      icon: Icons.bed,
                      text: '${widget.property.bedrooms ?? '-'} Bedrooms',
                    ),
                    FeatureChip(
                      icon: Icons.bathtub,
                      text: '${widget.property.bathrooms ?? '-'} Bathrooms',
                    ),
                    if (widget.property.kitchenAppliances != null && widget.property.kitchenAppliances!.isNotEmpty)
                      FeatureChip(
                        icon: Icons.kitchen,
                        text: 'Kitchen Appliances',
                      ),
                    FeatureChip(icon: Icons.wifi, text: 'WiFi Included'),
                  ],
                ),
                // Description
                const SizedBox(height: 24),
                Text(
                  'Description',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.property.description,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                // Map
                const SizedBox(height: 24),
                Text(
                  'Location',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.colorScheme.primary.withOpacity(0.08),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${widget.property.address}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
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
                    Text(
                      'Comments & Questions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('See All')),
                  ],
                ),
                const SizedBox(height: 12),
              ]),
            ),
          ),
          // Comments list
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return CommentItem(
                comment: _comments[index],
                isOwner: index == 1,
                ownerReply: index == 1 ? "Yes, utilities are included" : null,
              );
            }, childCount: _comments.length),
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
                        fillColor: theme.inputDecorationTheme.fillColor,
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
                    backgroundColor: theme.colorScheme.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
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
          icon: const Icon(Icons.message),
          label: const Text('Contact Owner'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(landlord: widget.owner),
            ),
          ),
        ),
      ),
    );
  }
}
