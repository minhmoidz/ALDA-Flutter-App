import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser _currentUser = ChatUser(
    id: "1",
    firstName: "Minh",
    lastName: "Trantuan",
    profileImage: "https://randomuser.me/api/portraits/men/32.jpg",
  );

  final ChatUser _aldaChatBot = ChatUser(
    id: "2",
    firstName: "Gió",
    lastName: "Nhắn tin",
    profileImage: "https://img.icons8.com/color/96/000000/bot.png",
  );

  List<ChatMessage> _messages = <ChatMessage>[];
  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1DBAEC),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: _aldaChatBot.profileImage ?? "",
                  placeholder: (context, url) => const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.smart_toy, color: Color(0xFF1DBAEC)),
                  ),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.smart_toy, color: Color(0xFF1DBAEC)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nhắn tin cùng Gió',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Show info about the chatbot
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About ALDA Chat'),
                  content: const Text('ALDA Chat is your intelligent assistant.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Typing indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[100],
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: _aldaChatBot.profileImage ?? "",
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.smart_toy, color: Color(0xFF1DBAEC)),
                        ),
                        errorWidget: (context, url, error) => const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.smart_toy, color: Color(0xFF1DBAEC)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SpinKitThreeBounce(
                    color: const Color(0xFF1DBAEC),
                    size: 16,
                  ),
                ],
              ),
            ),

          // Chat messages
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                image: const DecorationImage(
                  image: NetworkImage("https://i.pinimg.com/originals/8f/4c/95/8f4c9513c5a9f4444910f23d38ed2144.jpg"),
                  opacity: 0.1,
                  fit: BoxFit.cover,
                ),
              ),
              child: DashChat(
                currentUser: _currentUser,
                messages: _messages,
                onSend: _handleSendMessage,
                inputOptions: InputOptions(
                  // Fix: Provide a builder function instead of a class type
                  sendButtonBuilder: (onSend) {
                    return CustomSendButton(onPressed: onSend);
                  },
                ),
                messageOptions: MessageOptions(
                  showTime: true,
                  containerColor: const Color(0xFF1DBAEC),
                  textColor: Colors.white,
                  currentUserContainerColor: Colors.white,
                  currentUserTextColor: Colors.black87,
                  showCurrentUserAvatar: true,
                  // Remove boxShadow parameter as it's not available in MessageOptions
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    final url = 'http://203.162.88.102:12001/chat/';
    final data = {
      "id_user": 1,
      "id_section": 2,
      "query": message.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      setState(() {
        _isTyping = false;
      });

      if (response.statusCode == 200) {
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));
        String botReply = 'Failed to get response from ALDA bot';
        print(responseData);
        if (responseData['response'] != null) {
          botReply = responseData['response'];
        }
        setState(() {
          final botMessage = ChatMessage(
            user: _aldaChatBot,
            text: botReply,
            createdAt: DateTime.now(),
          );
          _messages.insert(0, botMessage);
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
        setState(() {
          final botMessage = ChatMessage(
            user: _aldaChatBot,
            text: "Sorry, I'm having trouble connecting right now. Please try again later.",
            createdAt: DateTime.now(),
          );
          _messages.insert(0, botMessage);
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isTyping = false;
        final botMessage = ChatMessage(
          user: _aldaChatBot,
          text: "Sorry, there was an error processing your request. Please check your internet connection and try again.",
          createdAt: DateTime.now(),
        );
        _messages.insert(0, botMessage);
      });
    }
  }
}

// Fix: Create a proper StatelessWidget instead of using a private class
class CustomSendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomSendButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF1DBAEC),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.send_rounded),
        color: Colors.white,
      ),
    );
  }
}