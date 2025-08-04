// models/message.dart

enum MessageStatus { sent, delivered, read }

class Message {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageStatus? status;
  final bool isSystem;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    DateTime? timestamp,
    this.status,
    this.isSystem = false,
  }) : timestamp = timestamp ?? DateTime.now();

  String get time {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

// Update all usages of User in Message to use the new User model (id, name, email, phone, type, isVerified)
// For sample/demo messages, use dummy email/phone/type values as needed.
