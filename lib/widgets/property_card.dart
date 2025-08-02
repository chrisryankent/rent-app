import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../models/property.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;
  final bool isFeatured;
  final bool isNew;
  final bool isRecommended;

  const PropertyCard({
    super.key,
    required this.property,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
    this.isFeatured = false,
    required this.isNew,
    required this.isRecommended,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isFeatured ? 260 : 220,
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: isFeatured ? 120 : 90,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4)
                            ],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.asset(
                            property.images != null && property.images!.isNotEmpty
                                ? property.images![0]
                                : 'lib/assets/property1.jpg',
                            height: isFeatured ? 120 : 90,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: HeartButton(
                          isFavorite: isFavorite,
                          onPressed: onFavorite,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[700]!.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Text(
                            '${property.rentAmount}/mo',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  property.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.verified, 
                                color: Colors.blue[700], 
                                size: 16
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Iconsax.location,
                                size: 12,
                                color: Theme.of(context).hintColor,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  property.address,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 0.5
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Iconsax.star, 
                                      size: 14, 
                                      color: Colors.amber
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      property.bedrooms?.toString() ?? '-',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Text('bd', style: TextStyle(fontSize: 11)),
                                    const SizedBox(width: 8),
                                    Text(
                                      property.bathrooms?.toString() ?? '-',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Text('ba', style: TextStyle(fontSize: 11)),
                                  ],
                                ),
                                Container(
                                  height: 12,
                                  width: 1,
                                  color: Colors.grey[300],
                                ),
                                Text(
                                  property.timeAgo,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (isFeatured) Positioned(
                top: -1,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[700],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'FEATURED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              if (isNew) Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
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

class HeartButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const HeartButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(HeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.5, end: 1.0), weight: 50),
      ]).animate(_controller),
      child: IconButton(
        icon: Icon(
          widget.isFavorite ? Iconsax.heart5 : Iconsax.heart,
          color: widget.isFavorite ? Colors.red : Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        onPressed: widget.onPressed,
        splashRadius: 20,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}