import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  const CustomTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        minLines: 1,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Type your message...',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
