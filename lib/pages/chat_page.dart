import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser _currentUser =
      ChatUser(id: "1", firstName: "minh", lastName: "trantuan");
  final ChatUser _aldaChatBot =
      ChatUser(id: "2", firstName: "ALDA", lastName: "Chat");

  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 29, 186, 234),
        title: const Text(
          'ALDA Chat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
        currentUser: _currentUser,
        messages: _messages,
        onSend: _handleSendMessage,
      ),
    );
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
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
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
