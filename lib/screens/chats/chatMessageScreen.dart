import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  ChatScreen({required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> messages = [];
  bool _isLoading = true; // Flag to simulate loading state

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a delay for loading
    setState(() {
      messages.addAll([
        {
          'sender': 'user',
          'text': 'Hi!',
          'time': '10:00 AM',
        },
        {
          'sender': 'astrologer',
          'text': 'Hello! How can I assist you today?',
          'time': '10:01 AM',
        },
        {
          'sender': 'user',
          'text': 'Hi!',
          'time': '10:00 AM',
        },
        {
          'sender': 'astrologer',
          'text': 'Hello! How can I assist you today?',
          'time': '10:01 AM',
        },
        {
          'sender': 'user',
          'text': 'Hi!',
          'time': '10:00 AM',
        },
        {
          'sender': 'astrologer',
          'text': 'Hello! How can I assist you today?',
          'time': '10:01 AM',
        },
        {
          'sender': 'user',
          'text': 'Hi!',
          'time': '10:00 AM',
        },
        {
          'sender': 'astrologer',
          'text': 'Hello! How can I assist you today?',
          'time': '10:01 AM',
        },
        {
          'sender': 'user',
          'text': 'Hi!',
          'time': '10:00 AM',
        },
        {
          'sender': 'astrologer',
          'text': 'Hello! How can I assist you today?',
          'time': '10:01 AM',
        }
        // Add more messages for demonstration
      ]);
      _isLoading = false;
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        final currentTime = TimeOfDay.now().format(context);
        messages.add({
          'sender': 'user',
          'text': _messageController.text,
          'time': currentTime,
        });
        _messageController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        final currentTime = TimeOfDay.now().format(context);
        messages.add({
          'sender': 'user',
          'text': '[Image]',
          'time': currentTime,
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage('images/astro1.jpg'), // Placeholder image
            ),
            SizedBox(width: 8),
            Text('Astrologer Name'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {
              // Implement video call functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      itemCount: 10, // Number of shimmer items
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                          ),
                          title: Container(
                            color: Colors.grey[300],
                            height: 16,
                            width: 100,
                          ),
                          subtitle: Container(
                            color: Colors.grey[300],
                            height: 14,
                            width: 150,
                          ),
                          trailing: Container(
                            color: Colors.grey[300],
                            height: 14,
                            width: 50,
                          ),
                        );
                      },
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Align(
                        alignment: message['sender'] == 'user'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: message['sender'] == 'user'
                                ? Colors.blue
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: message['sender'] == 'user'
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['text'],
                                style: TextStyle(
                                  color: message['sender'] == 'user'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                message['time'],
                                style: TextStyle(
                                  color: message['sender'] == 'user'
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
