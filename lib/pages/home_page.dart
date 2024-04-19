import 'package:flutter/material.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:aldabot/pages/chat_page.dart';

class HomePage extends StatelessWidget {
  final double horizontalPadding = 20;
  final double verticalPadding = 40;
  final double heightSizeBox = 20;

  final List<List<dynamic>> aldaTasks = [
    [
      "Chatting",
      MfgLabs.comment,
      Color.fromARGB(255, 133, 177, 213),
    ], // Sử dụng MfgLabs.comment thay vì Icon
    [
      "Talking",
      MfgLabs.mic,
      Color.fromARGB(255, 102, 162, 104),
    ], // Sử dụng MfgLabs.mic thay vì Icon
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(MfgLabs.menu,
                      size: 36,
                      color: Colors.black54), // Thay đổi màu icon menu
                  Icon(Icons.person,
                      size: 36,
                      color: Colors.black54), // Thay đổi màu icon person
                ],
              ),
            ),

            SizedBox(height: heightSizeBox),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome back",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .black)), // Thay đổi kích thước và font-weight của tiêu đề chào mừng
                  Text("HUNG MANH",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Color.fromARGB(
                              255, 101, 151, 170))), // Thay đổi màu chữ
                ],
              ),
            ),
            SizedBox(height: heightSizeBox),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text("How can ALDA help you ?",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .black87)), // Thay đổi font-size, font-weight và màu chữ
            ),
            SizedBox(height: 30), // Giảm khoảng cách giữa dòng văn bản và lưới
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: aldaTasks[0][2],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          aldaTasks[0][1],
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          aldaTasks[0][0],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: aldaTasks[1][2],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          aldaTasks[1][1],
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          aldaTasks[1][0],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: heightSizeBox), // Thêm khoảng cách dưới cùng
            Expanded(
                child:
                    Container()), // Expanded để đẩy slogan xuống dưới cuối màn hình
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Allow your voice to Heal",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Aweken Your Mind",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: heightSizeBox), // Thêm khoảng cách dưới cùng
          ],
        ),
      ),
    );
  }
}
