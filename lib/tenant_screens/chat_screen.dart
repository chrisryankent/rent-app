// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:rental_connect/models/user.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../models/message.dart';
import '../models/property.dart';

class ChatScreen extends StatefulWidget {
  final User landlord;
  final Property property;

  const ChatScreen({super.key, required this.landlord, required this.property});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  bool _isTyping = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  Message? _recentlyDeleted;
  int? _recentlyDeletedIndex;
  final String _currentUserId = 'user1';

  @override
  void initState() {
    super.initState();
    // Initialize with sample messages
    _messages.addAll([
      Message(
        id: '1',
        senderId: _currentUserId,
        content: 'Hi, is the apartment still available?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        status: MessageStatus.read,
        isSystem: false,
      ),
      Message(
        id: '2',
        senderId: widget.landlord.id,
        content: 'Yes, it is! When would you like to view it?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
        isSystem: false,
      ),
      Message(
        id: '3',
        senderId: _currentUserId,
        content: 'Would tomorrow at 2pm work?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        status: MessageStatus.delivered,
        isSystem: false,
      ),
      Message(
        id: '4',
        senderId: widget.landlord.id,
        content: 'That works for me. I\'ll send you the address',
        timestamp: DateTime.now().subtract(const Duration(minutes: 22)),
        isSystem: false,
      ),
      Message(
        id: '5',
        senderId: widget.landlord.id,
        content: 'Here is the address: 123 Main St, Downtown',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        isSystem: false,
      ),
      Message(
        id: '6',
        senderId: _currentUserId,
        content: 'Great! Looking forward to seeing it.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
        status: MessageStatus.sent,
        isSystem: false,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('lib/assets/rent.webp'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.landlord.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.landlord.isVerified)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.verified,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    _isTyping ? 'Typing...' : 'Online now',
                    style: TextStyle(
                      fontSize: 12,
                      color: _isTyping
                          ? theme.colorScheme.primary
                          : Colors.green[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: theme.colorScheme.primary),
            onPressed: () => _launchDialer(widget.landlord.phone),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.primary),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Property preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.08),
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.property.images != null &&
                            widget.property.images!.isNotEmpty
                        ? widget.property.images![0]
                        : 'lib/assets/property1.jpg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.property.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${widget.property.rentAmount}/mo',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Chat messages
          Expanded(
            child: AnimatedList(
              key: _listKey,
              reverse: true,
              padding: const EdgeInsets.all(16),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) {
                final message = _messages.reversed.toList()[index];
                return _buildMessageItem(message, animation, index);
              },
            ),
          ),
          // Input area
          _buildMessageInput(theme),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    Message message,
    Animation<double> animation,
    int index,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: Dismissible(
        key: Key(message.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          // Save the deleted message and its index
          _recentlyDeleted = message;
          _recentlyDeletedIndex = _messages.length - 1 - index;

          // Remove from list
          setState(() {
            _messages.removeAt(_recentlyDeletedIndex!);
          });

          // Show undo snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Message deleted'),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  if (_recentlyDeleted != null &&
                      _recentlyDeletedIndex != null) {
                    setState(() {
                      _messages.insert(
                        _recentlyDeletedIndex!,
                        _recentlyDeleted!,
                      );
                    });
                    _recentlyDeleted = null;
                    _recentlyDeletedIndex = null;
                  }
                },
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: _buildMessageBubble(message),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isSystem = message.isSystem;
    final theme = Theme.of(context);
    final isSent = message.senderId == _currentUserId;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isSent
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isSent && !isSystem)
            const CircleAvatar(
              backgroundImage: AssetImage('lib/assets/rent.webp'),
              radius: 16,
            ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              margin: EdgeInsets.only(
                left: isSent ? 60 : 8,
                right: isSent ? 0 : 60,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSystem
                    ? theme.colorScheme.primary.withOpacity(0.05)
                    : isSent
                    ? theme.colorScheme.primary.withOpacity(0.15)
                    : theme.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isSent ? 16 : 0),
                  bottomRight: Radius.circular(isSent ? 0 : 16),
                ),
                border: isSystem
                    ? Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSystem) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Viewing Scheduled',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message.content,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isSystem ? theme.colorScheme.primary : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        message.time,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                          fontSize: 10,
                        ),
                      ),
                      if (isSent && !isSystem) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 12,
                          color: message.status == MessageStatus.read
                              ? theme.colorScheme.primary
                              : message.status == MessageStatus.delivered
                              ? Colors.green
                              : theme.disabledColor,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          // Quick replies
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickReply('Can I see it today?', theme),
                _buildQuickReply('What\'s the address?', theme),
                _buildQuickReply('Is it pet friendly?', theme),
                _buildQuickReply('Available next month?', theme),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.add, color: theme.colorScheme.primary),
                onPressed: () => _showAttachmentOptions(context),
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (value) {
                    // Simulate typing indicator
                    if (value.isNotEmpty && !_isTyping) {
                      setState(() => _isTyping = true);
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) setState(() => _isTyping = false);
                      });
                    } else if (value.isEmpty && _isTyping) {
                      setState(() => _isTyping = false);
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.camera_alt, color: theme.colorScheme.primary),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.mic, color: theme.colorScheme.primary),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.send, color: theme.colorScheme.primary),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReply(String text, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            final newMessage = Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              senderId: _currentUserId,
              content: text,
              status: MessageStatus.sent,
              isSystem: false,
            );
            setState(() {
              _messages.insert(0, newMessage);
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility, color: Colors.blue),
                title: const Text('View Property Details'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to property details
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule, color: Colors.blue),
                title: const Text('Schedule Viewing'),
                onTap: () {
                  Navigator.pop(context);
                  _scheduleViewing(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Clear Chat History'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmClearChat(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Block User'),
                onTap: () {
                  Navigator.pop(context);
                  // Block user logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.report, color: Colors.orange),
                title: const Text('Report User'),
                onTap: () {
                  Navigator.pop(context);
                  // Report user logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.clear, color: Colors.grey),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmClearChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Chat History'),
          content: const Text(
            'Are you sure you want to delete all messages in this chat? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _messages.clear());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat history cleared')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete All'),
            ),
          ],
        );
      },
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.blue),
                title: const Text('Photo & Video Library'),
                onTap: () {
                  Navigator.pop(context);
                  // Open gallery
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  // Open camera
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: const Text('Share Location'),
                onTap: () {
                  Navigator.pop(context);
                  // Share location
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_file, color: Colors.blue),
                title: const Text('Documents'),
                onTap: () {
                  Navigator.pop(context);
                  // Open documents
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.grey),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _scheduleViewing(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
        TimeOfDay selectedTime = const TimeOfDay(hour: 14, minute: 0);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Schedule Viewing'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                    ),
                    title: const Text('Select Date'),
                    trailing: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(color: Colors.blue),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.blue),
                    title: const Text('Select Time'),
                    trailing: Text(
                      selectedTime.format(context),
                      style: const TextStyle(color: Colors.blue),
                    ),
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null && picked != selectedTime) {
                        setState(() => selectedTime = picked);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Send schedule request
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Viewing scheduled successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Add system message to chat
                    final systemMessage = Message(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      senderId: 'system',
                      content:
                          'Viewing scheduled for ${selectedDate.toLocal().toString().split(' ')[0]} at ${selectedTime.format(context)}',
                      isSystem: true,
                    );

                    setState(() {
                      _messages.insert(0, systemMessage);
                    });
                  },
                  child: const Text('Schedule'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId,
      content: content,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    setState(() {
      _messages.insert(0, message);
      _messageController.clear();
    });

    // Simulate receiving a reply
    Future.delayed(const Duration(seconds: 1), () {
      final reply = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: widget.landlord.id,
        content: 'Thank you for your message! I will get back to you soon.',
        timestamp: DateTime.now().add(const Duration(seconds: 1)),
      );

      setState(() {
        _messages.insert(0, reply);
      });
    });
  }

  void _launchDialer(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await launcher.launchUrl(uri)) {
      // success
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not launch dialer')));
    }
  }
}
