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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isUser? Color(0xff0984e3) :Color(0xfffd79a8),
              spreadRadius: 4,blurRadius: 0,offset: isUser? Offset(-2, 2) : Offset(2, 2)
            )
          ]
        ),
        child: Text(
          message,
          style: TextStyle(
            color:  Colors.black,
            fontSize: 16
          ),
        ),
      ),
    );
  }
}
