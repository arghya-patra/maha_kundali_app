import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maha_kundali_app/apiManager/apiData.dart';
import 'package:maha_kundali_app/service/serviceManager.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<dynamic> chatHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChatHistory();
  }

  Future<void> fetchChatHistory() async {
    String url = APIData.login;
    print(url.toString());
    final response = await http.post(Uri.parse(url), body: {
      'action': 'chat-history',
      'authorizationToken': ServiceManager.tokenID,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        chatHistory = data['chat_history'];
        isLoading = false;
      });
    } else {
      // Handle errors here
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat History with Astrologers'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? buildShimmerList()
          : ListView.builder(
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final chat = chatHistory[index];
                return buildChatListItem(chat);
              },
            ),
    );
  }

  Widget buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.white,
            ),
            title: Container(
              width: double.infinity,
              height: 10.0,
              color: Colors.white,
            ),
            subtitle: Container(
              width: double.infinity,
              height: 10.0,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget buildChatListItem(dynamic chat) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(chat['astrologer']),
        ),
        title: Text(
          chat['astrologer_name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text('Date: ${chat['date']}'),
            Text('Duration: ${chat['duration']}'),
            Text('Charges: \$${chat['charges']}'),
          ],
        ),
        trailing: Icon(Icons.chat, color: Colors.blueAccent),
        onTap: () {
          // Navigate to chat screen or chat details screen
        },
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:maha_kundali_app/screens/chats/chatMessageScreen.dart';

// class ChatListScreen extends StatefulWidget {
//   @override
//   _ChatListScreenState createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen>
//     with TickerProviderStateMixin {
//   List<Map<String, dynamic>> chatList = [];
//   bool isLoading = true; // Flag to show shimmer or actual data

//   @override
//   void initState() {
//     super.initState();
//     // Simulate data loading
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         chatList = [
//           {
//             'id': '1',
//             'name': 'Astrologer 1',
//             'image': 'images/astro1.jpg',
//             'lastMessage': 'Hello, how can I help you?',
//             'messageTime': '10:30 AM',
//             'isRead': false,
//           },
//           {
//             'id': '2',
//             'name': 'Astrologer 2',
//             'image': 'images/astro2.jpg',
//             'lastMessage': 'Your horoscope reading is ready.',
//             'messageTime': '09:45 AM',
//             'isRead': true,
//           },
//           {
//             'id': '3',
//             'name': 'Astrologer 2',
//             'image': 'images/astro3.jpg',
//             'lastMessage': 'Your horoscope reading is ready.',
//             'messageTime': '09:45 AM',
//             'isRead': true,
//           },
//           {
//             'id': '4',
//             'name': 'Astrologer 1',
//             'image': 'images/astro1.jpg',
//             'lastMessage': 'Hello, how can I help you?',
//             'messageTime': '10:30 AM',
//             'isRead': false,
//           },
//           {
//             'id': '5',
//             'name': 'Astrologer 2',
//             'image': 'images/astro2.jpg',
//             'lastMessage': 'Your horoscope reading is ready.',
//             'messageTime': '09:45 AM',
//             'isRead': true,
//           },
//           {
//             'id': '6',
//             'name': 'Astrologer 2',
//             'image': 'images/astro3.jpg',
//             'lastMessage': 'Your horoscope reading is ready.',
//             'messageTime': '09:45 AM',
//             'isRead': true,
//           },
//           {
//             'id': '7',
//             'name': 'Astrologer 1',
//             'image': 'images/astro1.jpg',
//             'lastMessage': 'Hello, how can I help you?',
//             'messageTime': '10:30 AM',
//             'isRead': false,
//           },
//           {
//             'id': '8',
//             'name': 'Astrologer 2',
//             'image': 'images/astro2.jpg',
//             'lastMessage': 'Your horoscope reading is ready.',
//             'messageTime': '09:45 AM',
//             'isRead': true,
//           },
//           {
//             'id': '9',
//             'name': 'Astrologer 2',
//             'image': 'images/astro3.jpg',
//             'lastMessage': 'Your horoscope reading is ready.',
//             'messageTime': '09:45 AM',
//             'isRead': true,
//           },
//           {
//             'id': '10',
//             'name': 'Astrologer 1',
//             'image': 'images/astro1.jpg',
//             'lastMessage': 'Hello, how can I help you?',
//             'messageTime': '10:30 AM',
//             'isRead': false,
//           }

//           // Add more chat data as needed
//         ];

//         isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with Astrologers'),
//         backgroundColor: Colors.orange,
//         elevation: 0,
//       ),
//       body: isLoading ? _buildShimmer() : _buildChatList(),
//     );
//   }

//   Widget _buildShimmer() {
//     return ListView.builder(
//       itemCount: 10, // Number of shimmer items
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: ListTile(
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             leading: CircleAvatar(
//               backgroundColor: Colors.grey[300],
//               radius: 30,
//             ),
//             title: Container(
//               color: Colors.grey[300],
//               height: 16,
//               width: 100,
//             ),
//             subtitle: Container(
//               color: Colors.grey[300],
//               height: 14,
//               width: 150,
//             ),
//             trailing: Container(
//               color: Colors.grey[300],
//               height: 14,
//               width: 50,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildChatList() {
//     return ListView.separated(
//       itemCount: chatList.length,
//       separatorBuilder: (context, index) =>
//           Divider(height: 1, color: Colors.grey[300]),
//       itemBuilder: (context, index) {
//         final chat = chatList[index];
//         return ListTile(
//           contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           leading: CircleAvatar(
//             backgroundImage: AssetImage(chat['image']),
//             radius: 30,
//           ),
//           title: Text(
//             chat['name'],
//             style: TextStyle(
//               fontWeight: chat['isRead'] ? FontWeight.normal : FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           subtitle: Text(
//             chat['lastMessage'],
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: chat['isRead'] ? Colors.grey : Colors.black,
//             ),
//           ),
//           trailing: Text(
//             chat['messageTime'],
//             style: TextStyle(color: Colors.grey),
//           ),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatScreen(chatId: chat['id']),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
