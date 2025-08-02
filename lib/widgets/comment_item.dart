// TODO Implement this library.
// widgets/comment_item.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CommentItem extends StatelessWidget {
  final String comment;
  final bool isOwner;
  final String? ownerReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.isOwner = false,
    this.ownerReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[200],
                child: Icon(
                  isOwner ? Iconsax.building : Iconsax.user,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isOwner ? 'Property Owner' : 'Tenant',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(comment),
          ),
          
          if (ownerReply != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blue[100],
                    child: const Icon(Iconsax.buildings, size: 16, color: Colors.blue),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Owner',
                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(ownerReply!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}