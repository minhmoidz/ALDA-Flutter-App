import 'package:aldabot/pages/chat_page.dart';
import 'package:aldabot/util/task_box.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/mfg_labs_icons.dart';

class HomePage extends StatelessWidget {
  // padding constant
  final double horizontalPadding = 20;
  final double verticalPadding = 40;
  final double heightSizeBox = 20;
  final double iconSize = 36;

  // List of tasks
  final List aldaTasks = [
    // [ taskName, icon]
    [
      "Chatting",
      Icon(
        MfgLabs.comment,
        size: 60,
        color: Colors.white,
      )
    ],
    [
      "Talking",
      Icon(
        MfgLabs.mic,
        size: 60,
        color: Colors.white,
      )
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(207, 240, 229, 1),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                // custom app bar
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      MfgLabs.menu,
                      size: 36,
                      color: Color.fromRGBO(5, 7, 15, 1),
                    ),
                    Icon(
                      Icons.person,
                      size: 36,
                      color: Color.fromRGBO(5, 7, 15, 1),
                    )
                  ],
                ),
              ),
              SizedBox(height: heightSizeBox),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // Welcome title
                    Text("Welcome back"),
                    Text(
                      "HUNG MANH",
                      style: TextStyle(fontSize: 35),
                    )
                  ],
                ),
              ),
              SizedBox(height: heightSizeBox),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text("How can ALDA help you ?",
                    style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 300),
              Expanded(
                child: GridView.builder(
                  itemCount: aldaTasks.length,
                  padding: EdgeInsets.all(25),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(0, 134, 89, 1),
                            padding:
                                EdgeInsets.symmetric(horizontal: 30), // Padding
                            shape: RoundedRectangleBorder(
                              // Shape
                              borderRadius: BorderRadius.circular(30),
                            )),
                        child: TaskBox(
                          taskName: aldaTasks[index][0],
                          icon: aldaTasks[index][1],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChatPage()));
                        });
                  },
                ),
              )
            ],
          ),
        ));
  }
}
