// TODO Implement this library.
// messages_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_connect/models/user.dart' as app;
import 'chat_screen.dart';
import '../models/property.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _chatThreads = [];

  @override
  void initState() {
    super.initState();
    _fetchChatThreads();
  }

  Future<void> _fetchChatThreads() async {
    setState(() {
      _isLoading = true;
    });
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        _chatThreads = [];
        _isLoading = false;
      });
      return;
    }
    // Example Firestore structure: 'chats' collection, each doc has propertyId, landlordId, lastMessage, lastTime, unread, etc.
    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('tenantId', isEqualTo: currentUser.uid)
        .get();
    final List<Map<String, dynamic>> threads = [];
    for (final doc in snapshot.docs) {
      final data = doc.data();
      // Fetch property and landlord info from database
      final propertySnap = await FirebaseFirestore.instance
          .collection('properties')
          .doc(data['propertyId'])
          .get();
      final landlordSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(data['landlordId'])
          .get();
      if (propertySnap.exists && landlordSnap.exists) {
        threads.add({
          'property': Property.fromFirestore(propertySnap),
          'landlord': app.User(
            id: landlordSnap.id,
            name: landlordSnap['name'],
            email: landlordSnap['email'],
            phone: landlordSnap['phone'],
            type: app.UserType.values.firstWhere(
              (e) => e.name == (landlordSnap['type'] ?? 'owner'),
              orElse: () => app.UserType.owner,
            ),
            isVerified: landlordSnap['isVerified'] ?? false,
          ),
          'lastMessage': data['lastMessage'] ?? '',
          'lastTime': data['lastTime'] ?? '',
          'unread': data['unread'] ?? false,
        });
      }
    }
    setState(() {
      _chatThreads = threads;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_chatThreads.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Messages'),
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.appBarTheme.foregroundColor,
          elevation: theme.appBarTheme.elevation,
          iconTheme: theme.appBarTheme.iconTheme,
          titleTextStyle: theme.appBarTheme.titleTextStyle,
        ),
        body: const Center(child: Text('No messages found.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Messages'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: ListView.builder(
        itemCount: _chatThreads.length,
        itemBuilder: (context, index) {
          final thread = _chatThreads[index];
          final property = thread['property'] as Property;
          final landlord = thread['landlord'] as app.User;
          final isUnread = thread['unread'] as bool;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                property.images != null && property.images!.isNotEmpty
                    ? property.images![0]
                    : 'lib/assets/profile.webp',
              ),
              radius: 28,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    property.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isUnread
                          ? theme.colorScheme.primary
                          : theme.textTheme.bodyLarge?.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (landlord.isVerified)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.verified,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
            subtitle: Text(
              thread['lastMessage'],
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
                  thread['lastTime'],
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
                builder: (context) =>
                    ChatScreen(landlord: landlord, property: property),
              ),
            ),
          );
        },
      ),
    );
  }
}
