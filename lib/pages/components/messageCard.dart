import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String message;
  final String role;
  const MessageCard({super.key, required this.message, required this.role});

  @override
  Widget build(BuildContext context) {
    bool isUser = role == 'user';

    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
            fontSize: 16
          ),
        ),
      ),
    );
  }
}
