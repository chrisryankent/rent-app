import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rental_connect/landlord_screens/landlord_chat_screen.dart';

class LandlordMessagesScreen extends StatelessWidget {
  const LandlordMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<_LandlordMessage> messages = [
      _LandlordMessage(
        id: '1',
        tenantName: 'Alex Morgan',
        isVerified: true,
        content: 'Hi, is the apartment still available?',
        time: '10:30',
        unread: true,
      ),
      _LandlordMessage(
        id: '2',
        tenantName: 'Sarah Johnson',
        isVerified: false,
        content: 'Can I schedule a viewing for tomorrow?',
        time: '09:15',
        unread: false,
      ),
      _LandlordMessage(
        id: '3',
        tenantName: 'Property Management',
        isVerified: true,
        content: 'Tenant has confirmed the appointment.',
        time: 'Yesterday',
        unread: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('lib/assets/rent.webp'),
              radius: 28,
            ),
            title: Row(
              children: [
                Text(
                  message.tenantName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: message.unread
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (message.isVerified)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Iconsax.verify5,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
            subtitle: Text(
              message.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: message.unread
                    ? theme.colorScheme.primary
                    : theme.textTheme.bodyMedium?.color,
              ),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.time,
                  style: TextStyle(
                    color: message.unread
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodySmall?.color,
                    fontSize: 12,
                  ),
                ),
                if (message.unread)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LandlordChatScreen(
                      tenantName: message.tenantName,
                      tenantPhone: '', // TODO: Replace with actual tenant phone if available
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LandlordMessage {
  final String id;
  final String tenantName;
  final bool isVerified;
  final String content;
  final String time;
  final bool unread;
  const _LandlordMessage({
    required this.id,
    required this.tenantName,
    required this.isVerified,
    required this.content,
    required this.time,
    required this.unread,
  });
}
