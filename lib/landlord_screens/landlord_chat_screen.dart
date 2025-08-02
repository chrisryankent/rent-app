import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class LandlordChatScreen extends StatefulWidget {
  final String tenantName;
  final String tenantPhone;
  final String? propertyTitle;
  final String? propertyImage;
  final String? propertyPrice;
  const LandlordChatScreen({
    super.key,
    required this.tenantName,
    required this.tenantPhone,
    this.propertyTitle,
    this.propertyImage,
    this.propertyPrice,
  });

  @override
  State<LandlordChatScreen> createState() => _LandlordChatScreenState();
}

class _LandlordChatScreenState extends State<LandlordChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<_Message> _messages = [];
  bool _isTyping = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  _Message? _recentlyDeleted;
  int? _recentlyDeletedIndex;

  @override
  void initState() {
    super.initState();
    _messages.addAll([
      _Message(
        id: '1',
        content: 'Hi, I am interested in your property.',
        isMe: false,
        isSystem: false,
        time: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      _Message(
        id: '2',
        content: 'Hello! When would you like to view it?',
        isMe: true,
        isSystem: false,
        time: DateTime.now().subtract(const Duration(minutes: 29)),
      ),
      _Message(
        id: '3',
        content: 'Tomorrow at 2pm works for me.',
        isMe: false,
        isSystem: false,
        time: DateTime.now().subtract(const Duration(minutes: 28)),
      ),
      _Message(
        id: '4',
        content: 'Great, see you then!',
        isMe: true,
        isSystem: false,
        time: DateTime.now().subtract(const Duration(minutes: 27)),
      ),
      _Message(
        id: '5',
        content: 'Viewing scheduled for tomorrow at 2pm.',
        isMe: false,
        isSystem: true,
        time: DateTime.now().subtract(const Duration(minutes: 26)),
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
                  Text(
                    widget.tenantName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
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
            onPressed: () => _launchDialer(widget.tenantPhone),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.primary),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.propertyTitle != null)
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
                    child: widget.propertyImage != null
                        ? Image.asset(
                            widget.propertyImage!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.propertyTitle!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (widget.propertyPrice != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.propertyPrice!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
          _buildMessageInput(theme),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    _Message message,
    Animation<double> animation,
    int index,
  ) {
    final theme = Theme.of(context);
    return SizeTransition(
      sizeFactor: animation,
      child: Dismissible(
        key: Key(message.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          _recentlyDeleted = message;
          _recentlyDeletedIndex = _messages.length - 1 - index;
          setState(() {
            _messages.removeAt(_recentlyDeletedIndex!);
          });
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

  Widget _buildMessageBubble(_Message message) {
    final theme = Theme.of(context);
    final isSystem = message.isSystem;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isMe && !isSystem)
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
                left: message.isMe ? 60 : 8,
                right: message.isMe ? 0 : 60,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSystem
                    ? theme.colorScheme.primary.withOpacity(0.05)
                    : message.isMe
                    ? theme.colorScheme.primary.withOpacity(0.15)
                    : theme.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isMe ? 16 : 0),
                  bottomRight: Radius.circular(message.isMe ? 0 : 16),
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
                        _formatTime(message.time),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                          fontSize: 10,
                        ),
                      ),
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
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickReply('Can you send more photos?', theme),
                _buildQuickReply('Is the tenant verified?', theme),
                _buildQuickReply('When do you want to move in?', theme),
                _buildQuickReply('Do you have pets?', theme),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.add, color: theme.colorScheme.primary),
                onPressed: _showAttachmentOptions,
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
            final newMessage = _Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: text,
              isMe: true,
              isSystem: false,
              time: DateTime.now(),
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

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.blue),
                title: const Text('Photo & Video Library'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: const Text('Share Location'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.attach_file, color: Colors.blue),
                title: const Text('Documents'),
                onTap: () => Navigator.pop(context),
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

  void _showMoreOptions() {
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
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule, color: Colors.blue),
                title: const Text('Schedule Viewing'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Clear Chat History'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _messages.clear());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chat history cleared')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Block User'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.report, color: Colors.orange),
                title: const Text('Report User'),
                onTap: () => Navigator.pop(context),
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

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;
    final message = _Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isMe: true,
      isSystem: false,
      time: DateTime.now(),
    );
    setState(() {
      _messages.insert(0, message);
      _messageController.clear();
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.insert(
          0,
          _Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: 'Thanks for your message!',
            isMe: false,
            isSystem: false,
            time: DateTime.now(),
          ),
        );
      });
    });
  }

  void _launchDialer(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await launcher.launchUrl(uri)) {
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not launch dialer')));
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}

class _Message {
  final String id;
  final String content;
  final bool isMe;
  final bool isSystem;
  final DateTime time;
  _Message({
    required this.id,
    required this.content,
    required this.isMe,
    required this.isSystem,
    required this.time,
  });
}