import 'package:flutter/material.dart';

class CustomerSupportChat extends StatefulWidget {
  @override
  _CustomerSupportChatState createState() => _CustomerSupportChatState();
}

class _CustomerSupportChatState extends State<CustomerSupportChat>
    with TickerProviderStateMixin {
  List<Map<String, String>> messages = [];
  List<String> predefinedQuestions = [
    "How can I reset my password?",
    "What is your refund policy?",
    "How can I track my order?",
    "How do I contact customer support?",
    "What payment methods do you accept?",
    // Add more predefined questions here
  ];

  Map<String, String> predefinedAnswers = {
    "How can I reset my password?":
        "To reset your password, go to settings and click on 'Forgot Password'.",
    "What is your refund policy?":
        "Our refund policy is available on our website. You can view it by clicking here.",
    "How can I track my order?":
        "You can track your order in the 'My Orders' section.",
    "How do I contact customer support?":
        "You can contact customer support through the chat or by calling our helpline.",
    "What payment methods do you accept?":
        "We accept credit cards, debit cards, and PayPal.",
    // Add more predefined answers here
  };

  TextEditingController _controller = TextEditingController();
  bool _isTyping = false;
  late AnimationController _typingController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _typingAnimation =
        CurvedAnimation(parent: _typingController, curve: Curves.easeIn);
  }

  void _handleSendMessage(String text) {
    if (text.isEmpty) return;
    setState(() {
      messages.add({"user": text});
      _isTyping = true;
    });
    _controller.clear();
    _typingController.forward();

    Future.delayed(Duration(seconds: 2), () {
      String? response = predefinedAnswers[text];
      setState(() {
        if (response != null) {
          messages.add({"admin": response});
        } else {
          messages.add({
            "admin": "I'm sorry, I didn't understand that. Can you rephrase?"
          });
        }
        _isTyping = false;
        _typingController.reset();
      });
    });
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUserMessage = message.containsKey("user");
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blueAccent : Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          isUserMessage ? message["user"]! : message["admin"]!,
          style: TextStyle(
            color: isUserMessage ? Colors.white : Colors.black87,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return FadeTransition(
      opacity: _typingAnimation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(width: 8.0),
            Text(
              "Admin is typing...",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredefinedQuestions() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.orangeAccent.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Common Questions:",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: predefinedQuestions.map((question) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ActionChip(
                    label: Text(question),
                    backgroundColor: Colors.orangeAccent,
                    onPressed: () => _handleSendMessage(question),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Support"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessage(messages[index]);
              },
            ),
          ),
          _buildPredefinedQuestions(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onSubmitted: _handleSendMessage,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.orange),
                  onPressed: () => _handleSendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _typingController.dispose();
    super.dispose();
  }
}
