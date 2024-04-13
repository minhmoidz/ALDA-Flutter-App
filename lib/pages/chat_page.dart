import 'package:aldabot/const.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: "Chi", lastName: "Bui Mai");
  final ChatUser _aldaChatBot =
      ChatUser(id: '2', firstName: "ALDA", lastName: "Chat");

  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 166, 126, 1),
        title: const Text(
          'ALDA Chat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
          currentUser: _currentUser,
          messageOptions: const MessageOptions(
              currentUserContainerColor: Color.fromRGBO(0, 166, 126, 1)),
          onSend: (ChatMessage m) {
            getChatResponse(m);
          },
          messages: _messages),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      print(m.text);
    });
    final apiKey = CHAT_BOT_KEY;
    final chatBotID = 155900;
    final message = m.text;
    final externalID = _currentUser.id;
    final firstName = _currentUser.firstName;
    final lastName = _currentUser.lastName;

    final response = await http
        .get(Uri.parse('https://www.personalityforge.com/api/chat/index.php'
            '?apiKey=$apiKey&chatBotID=$chatBotID&message=$message'
            '&externalID=$externalID&firstName=$firstName&lastName=$lastName'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String botReply = 'Failed to response from ALDA bot';
      // Check if the API call was successful
      if (data['success'] == 1) {
        botReply = data['message']['message'];
      }
      setState(() {
        _messages.insert(
            0,
            ChatMessage(
                user: _aldaChatBot, createdAt: DateTime.now(), text: botReply));
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
