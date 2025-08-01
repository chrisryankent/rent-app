// TODO Implement this library.
// messages_screen.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rental_connect/tenant_screens/models/room.dart';
import 'chat_screen.dart';
import 'models/message.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Message> messages = [
      Message(
        sender: User(
          name: 'Alex Morgan',
          image: 'assets/user1.jpg',
          isVerified: true,
          id: '',
        ),
        preview: 'Hi, is the apartment still available?',
        time: '10:30 AM',
        isRead: false,
        isSystem: false,
        status: MessageStatus.sent,
        id: '',
        content: '',
      ),
      Message(
        sender: User(
          name: 'Property Management',
          image: 'assets/user2.jpg',
          isVerified: true,
          id: '',
        ),
        preview: 'Your viewing has been confirmed for tomorrow',
        time: 'Yesterday',
        isRead: true,
        isSystem: false,
        status: MessageStatus.read,
        id: '',
        content: '',
      ),
      Message(
        sender: User(
          name: 'Sarah Johnson',
          image: 'assets/user3.jpg',
          isVerified: false,
          id: '',
        ),
        preview: 'I can show you the property today at 4pm',
        time: 'Wed',
        isRead: true,
        isSystem: false,
        status: MessageStatus.delivered,
        id: '',
        content: '',
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
            leading: CircleAvatar(
              backgroundImage: AssetImage(message.sender.image),
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
              message.preview ?? '',
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
