// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:rental_connect/tenant_screens/models/room.dart';
import 'models/message.dart';

class ChatScreen extends StatefulWidget {
  final User landlord;

  const ChatScreen({super.key, required this.landlord});

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

  @override
  void initState() {
    super.initState();
    // Initialize with sample messages
    _messages.addAll([
      Message(
        id: '1',
        sender: User(id: 'user1', name: 'You', image: ''),
        content: 'Hi, is the apartment still available?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isSent: true,
        status: MessageStatus.read, preview: '', time: '', isRead: true, isSystem: false,
      ),
      Message(
        id: '2',
        sender: widget.landlord,
        content: 'Yes, it is! When would you like to view it?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
        isSent: false, preview: '', time: '', isRead: true,
      ),
      Message(
        id: '3',
        sender: User(id: 'user1', name: 'You', image: ''),
        content: 'Would tomorrow at 2pm work?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        isSent: true,
        status: MessageStatus.delivered, preview: '', time: '', isRead: true,
      ),
      Message(
        id: '4',
        sender: widget.landlord,
        content: 'That works for me. I\'ll send you the address',
        timestamp: DateTime.now().subtract(const Duration(minutes: 22)),
        isSent: false, preview: '', time: '', isRead: false,
      ),
      Message(
        id: '5',
        sender: widget.landlord,
        content: 'Here is the address: 123 Main St, Downtown',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        isSent: false, preview: '', time: '', isRead: true,
      ),
      Message(
        id: '6',
        sender: User(id: 'user1', name: 'You', image: ''),
        content: 'Great! Looking forward to seeing it.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
        isSent: true,
        status: MessageStatus.sent, preview: '', time: '', isRead: false,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.landlord.image),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.landlord.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  _isTyping ? 'Typing...' : 'Online now',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isTyping ? Colors.blue : Colors.green[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.blue),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.blue),
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
              color: Colors.blue[50],
              border: const Border(bottom: BorderSide(color: Colors.black12)),),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/property1.jpg',
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
                      const Text(
                        'Modern Downtown Studio',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$1,250/month',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.blue),
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
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Message message, Animation<double> animation, int index) {
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
                  if (_recentlyDeleted != null && _recentlyDeletedIndex != null) {
                    setState(() {
                      _messages.insert(_recentlyDeletedIndex!, _recentlyDeleted!);
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
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            message.isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSent && !isSystem)
            CircleAvatar(
              backgroundImage: AssetImage(widget.landlord.image),
              radius: 16,
            ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              margin: EdgeInsets.only(
                left: message.isSent ? 60 : 8,
                right: message.isSent ? 0 : 60,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSystem 
                  ? Colors.grey[100]
                  : message.isSent
                    ? Colors.blue[50]
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isSent ? 16 : 0),
                  bottomRight: Radius.circular(message.isSent ? 0 : 16),
                ),
                border: isSystem 
                  ? Border.all(color: Colors.blue[100]!)
                  : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSystem) ...[
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          'Viewing Scheduled',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSystem ? Colors.blue[700] : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        message.time,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (message.isSent && !isSystem) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 12,
                          color: message.status == MessageStatus.read
                              ? Colors.blue
                              : message.status == MessageStatus.delivered
                                ? Colors.green
                                : Colors.grey,
                        ),
                      ]
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

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          // Quick replies
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickReply('Can I see it today?'),
                _buildQuickReply('What\'s the address?'),
                _buildQuickReply('Is it pet friendly?'),
                _buildQuickReply('Available next month?'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: () => _showAttachmentOptions(context),
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                icon: const Icon(Icons.camera_alt, color: Colors.blue),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.mic, color: Colors.blue),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: User(id: 'user1', name: 'You', image: ''),
        content: _messageController.text,
        isSent: true,
        status: MessageStatus.sent, preview: '', time: '', isRead: false,
      );
      
      // Add to the beginning of the list since we're using reverse
      setState(() {
        _messages.insert(0, newMessage);
      });
      
      _messageController.clear();
      
      // Simulate reply after delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.insert(0, Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              sender: widget.landlord,
              content: 'Thanks for your message!',
              isSent: false,
              status: MessageStatus.sent, preview: '', time: '', isRead: false,
            ));
          });
        }
      });
    }
  }

  Widget _buildQuickReply(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            final newMessage = Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              sender: User(id: 'user1', name: 'You', image: ''),
              content: text,
              isSent: true,
              status: MessageStatus.sent, preview: '', time: '', isRead: false,
            );
            
            setState(() {
              _messages.insert(0, newMessage);
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              text,
              style: TextStyle(color: Colors.blue[700]),
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
          content: const Text('Are you sure you want to delete all messages in this chat? This action cannot be undone.'),
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
                    leading: const Icon(Icons.calendar_today, color: Colors.blue),
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
                      sender: User(id: 'system', name: 'System', image: ''),
                      content: 'Viewing scheduled for ${selectedDate.toLocal().toString().split(' ')[0]} at ${selectedTime.format(context)}',
                      isSystem: true, preview: '', time: '', isRead: false,
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
}