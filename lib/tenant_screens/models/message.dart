// models/message.dart
import 'package:flutter/material.dart';
import 'package:rental_connect/tenant_screens/models/room.dart';

enum MessageStatus { sent, delivered, read }

class Message {
  final String id;
  final User sender;
  final String content;
  final DateTime timestamp;
  final bool isSent;
  final MessageStatus? status;
  final bool isSystem;

  var preview;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    DateTime? timestamp,
    this.isSent = false,
    this.status,
    this.isSystem = false, required String preview, required String time, required bool isRead,
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
