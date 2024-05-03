import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: VoicePage(),
  ));
}

class VoicePage extends StatefulWidget {
  const VoicePage({Key? key}) : super(key: key);

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  bool _isRecording = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeechToText();
  }

  void _initializeSpeechToText() async {
    bool isAvailable = await _speech.initialize();
    if (!isAvailable) {
      // Xử lý khi Speech to text không khả dụng
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 36, 185, 138),
        title: const Text(
          'ALDA Voice',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Phần hiển thị câu trả lời
          Expanded(
            child: Center(
              child: Text(
                _text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          // Phần chứa biểu tượng mic và nút gửi tin nhắn
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _toggleRecording,
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 100,
                    color: _isRecording ? Colors.red : Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendText,
                  child: Text('Send Text'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleRecording() async {
    if (!_isRecording) {
      await _startRecording();
    } else {
      await _stopRecording();
    }
  }

  Future<void> _startRecording() async {
    if (await _checkPermission()) {
      setState(() {
        _isRecording = true;
        _text = 'Listening...';
      });

      _speech.listen(onResult: (SpeechRecognitionResult result) {
        setState(() {
          _text = result.recognizedWords ?? '';
        });
      });
    }
  }

  Future<void> _stopRecording() async {
    setState(() {
      _isRecording = false;
      _text = 'Processing...';
    });

    _speech.stop();
  }

  Future<bool> _checkPermission() async {
    var microphoneStatus = await Permission.microphone.request();
    return microphoneStatus.isGranted;
  }

  Future<void> _sendText() async {
    if (_text.isNotEmpty) {
      final url = 'http://203.162.88.102:12001/chat/';
      final data = {
        "id_user": 1,
        "id_section": 2,
        "query": _text,
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
            _text = botReply;
          });
          // Đọc văn bản khi nhận được phản hồi
          await flutterTts.speak(botReply);
        } else {
          print('Request failed with status: ${response.statusCode}.');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }
}
