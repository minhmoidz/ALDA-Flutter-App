import 'package:flutter/material.dart';

class TaskBox extends StatefulWidget {
  final String taskName;
  final Icon icon;

  const TaskBox({
    Key? key,
    required this.taskName,
    required this.icon,
  }) : super(key: key);

  @override
  State<TaskBox> createState() => _TaskBoxState();
}

class _TaskBoxState extends State<TaskBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          color: Colors.blueAccent, // Màu nền mới
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.icon,
            Text(
              widget.taskName,
              style: TextStyle(
                color: Colors.white, // Màu chữ mới
                fontSize: 18, // Giảm kích thước chữ
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
