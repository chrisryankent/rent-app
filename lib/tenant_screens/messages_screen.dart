// TODO Implement this library.
// messages_screen.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rental_connect/tenant_screens/models/user.dart';
import 'chat_screen.dart';
import 'models/message.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Message> messages = [
      Message(
        id: '1',
        sender: User(
          id: '1',
          name: 'Alex Morgan',
          email: 'alex@example.com',
          phone: '1234567890',
          type: UserType.landlord,
          isVerified: true,
        ),
        content: 'Hi, is the apartment still available?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isSent: false,
        status: MessageStatus.sent,
        isSystem: false,
      ),
      Message(
        id: '2',
        sender: User(
          id: '2',
          name: 'Property Management',
          email: 'pm@example.com',
          phone: '2345678901',
          type: UserType.landlord,
          isVerified: true,
        ),
        content: 'Your viewing has been confirmed for tomorrow',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isSent: false,
        status: MessageStatus.read,
        isSystem: false,
      ),
      Message(
        id: '3',
        sender: User(
          id: '3',
          name: 'Sarah Johnson',
          email: 'sarah@example.com',
          phone: '3456789012',
          type: UserType.landlord,
          isVerified: false,
        ),
        content: 'I can show you the property today at 4pm',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isSent: false,
        status: MessageStatus.delivered,
        isSystem: false,
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
          final isUnread = !message.isSent;
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('lib/assets/rent.webp'),
              radius: 28,
            ),
            title: Row(
              children: [
                Text(
                  message.sender.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isUnread
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (message.sender.isVerified)
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
                color: isUnread
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
                    color: isUnread
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodySmall?.color,
                    fontSize: 12,
                  ),
                ),
                if (isUnread)
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
                builder: (context) => ChatScreen(landlord: message.sender),
              ),
            ),
          );
        },
      ),
    );
  }
}
