import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'dart:typed_data'; // Thêm import cho Uint8List
import 'dart:ui' show ImageByteFormat; // Cho việc chuyển đổi image
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lấy danh sách camera có sẵn
  final cameras = await availableCameras();
  runApp(MaterialApp(
    home: VoicePage(cameras: cameras),
  ));
}

class VoicePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const VoicePage({Key? key, required this.cameras}) : super(key: key);

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  bool _isRecording = false;
  String _text = '';

  // Camera variables
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isCameraActive = false;
  Timer? _timer;
  bool _isProcessingFrame = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeechToText();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _initializeSpeechToText() async {
    bool isAvailable = await _speech.initialize();
    if (!isAvailable) {
      // Xử lý khi Speech to text không khả dụng
      setState(() {
        _text = 'Speech recognition not available';
      });
    }
  }

  Future<void> _initializeCamera() async {
    // Kiểm tra quyền truy cập camera
    final status = await Permission.camera.request();
    if (status.isGranted && widget.cameras.isNotEmpty) {
      // Sử dụng camera trước nếu có
      final frontCamera = widget.cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => widget.cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      try {
        await _cameraController.initialize();
        setState(() {
          _isCameraInitialized = true;
        });
      } catch (e) {
        print('Error initializing camera: $e');
      }
    } else {
      print('Camera permission denied or no cameras available');
    }
  }

  void _toggleCamera() async {
    if (!_isCameraActive && _isCameraInitialized) {
      // Bắt đầu stream camera
      await _cameraController.startImageStream((CameraImage image) {
        if (!_isProcessingFrame) {
          _processImage(image);
        }
      });

      // Thiết lập timer để gửi dữ liệu định kỳ
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        // Gửi dữ liệu hình ảnh lên Google API
        _sendImageToGoogleAPI();
      });

      setState(() {
        _isCameraActive = true;
      });
    } else if (_isCameraActive) {
      await _cameraController.stopImageStream();
      _timer?.cancel();
      setState(() {
        _isCameraActive = false;
      });
    }
  }

  Future<void> _processImage(CameraImage image) async {
    _isProcessingFrame = true;

    try {
      // Xử lý hình ảnh đơn giản - ghi log thông tin
      print('Processing image: ${image.width}x${image.height}');
      // Thêm logic xử lý hình ảnh tùy nhu cầu
    } catch (e) {
      print('Error processing image: $e');
    }

    _isProcessingFrame = false;
  }

  Future<void> _sendImageToGoogleAPI() async {
    if (!_isCameraActive) return;

    try {
      // Lấy hình ảnh từ camera
      final XFile imageFile = await _cameraController.takePicture();
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Gửi dữ liệu lên Google API
      final url = 'YOUR_GOOGLE_API_ENDPOINT';
      final apiKey = 'YOUR_GOOGLE_API_KEY';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'image': base64Image,
          // Thêm các tham số khác cần thiết cho API
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('API Response: $responseData');
        // Xử lý dữ liệu phản hồi từ API
      } else {
        print('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image to API: $e');
    }
  }

  Future<void> _toggleRecording() async {
    if (!_isRecording) {
      await _startRecording();
    } else {
      await _stopRecording();
    }
  }

  Future<void> _startRecording() async {
    if (await _checkMicrophonePermission()) {
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

  Future<bool> _checkMicrophonePermission() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 36, 185, 138),
        title: const Text(
          'ALDA Voice & Video',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Camera preview
          if (_isCameraInitialized)
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  CameraPreview(_cameraController),
                  if (_isCameraActive)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Text display
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Text(
                  _text,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),

          // Control buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Camera toggle button
                Column(
                  children: [
                    IconButton(
                      onPressed: _isCameraInitialized ? _toggleCamera : null,
                      icon: Icon(
                        _isCameraActive ? Icons.videocam_off : Icons.videocam,
                        size: 50,
                        color: _isCameraActive ? Colors.red : Colors.blue,
                      ),
                    ),
                    Text('Camera'),
                  ],
                ),

                // Microphone button
                Column(
                  children: [
                    IconButton(
                      onPressed: _toggleRecording,
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        size: 50,
                        color: _isRecording ? Colors.red : Colors.blue,
                      ),
                    ),
                    Text('Mic'),
                  ],
                ),

                // Send button
                Column(
                  children: [
                    IconButton(
                      onPressed: _sendText,
                      icon: Icon(
                        Icons.send,
                        size: 50,
                        color: Colors.green,
                      ),
                    ),
                    Text('Send'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}