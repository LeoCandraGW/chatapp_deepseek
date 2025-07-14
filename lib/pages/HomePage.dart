import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gpt_app/datas/DataSource.dart';
import 'package:gpt_app/datas/message.dart';
import 'package:gpt_app/pages/components/customTextField.dart';
import 'package:gpt_app/pages/components/messageCard.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController message = TextEditingController();
  List<Map<String, dynamic>>? data;

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }

  Future _loadMessage() async {
    final result = await Message.instance.listMessages();
    setState(() {
      data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: data?.length ?? 0,
              itemBuilder: (context, index) {
                final reversedIndex = (data?.length ?? 0) - 1 - index;
                final messages = data?[reversedIndex];
                return MessageCard(
                  message: messages?['message'] ?? 'no message',
                  role: messages?['role'] ?? 'no role',
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: 30,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  CustomTextField(controller: message),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        _doLogic();
                      },
                      child: Icon(FontAwesomeIcons.paperPlane),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _doLogic() async {
    await Message.instance.insertMessage(message.text, 'user');
    final reply = await getGptReply(message.text);
    message.clear();
    await Message.instance.insertMessage(reply, 'assistant');
    _loadMessage();
  }
}
