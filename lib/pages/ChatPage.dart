import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gpt_app/datas/DataSource.dart';
import 'package:gpt_app/datas/chat.dart';
import 'package:gpt_app/datas/message.dart';
import 'package:gpt_app/pages/components/customTextField.dart';
import 'package:gpt_app/pages/components/messageCard.dart';

class ChatPage extends StatefulWidget {
  final int id;
  const ChatPage({super.key, required this.id});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController message = TextEditingController();
  List<Map<String, dynamic>>? data;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }

  Future _loadMessage() async {
    final result = await Message.instance.listMessages(widget.id);
    setState(() {
      data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Title'))),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Color(0xfffdcb6e)),
          ),
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: data?.length ?? 0,
                itemBuilder: (context, index) {
                  final reversedIndex = (data?.length ?? 0) - 1 - index;
                  final messages = data?[reversedIndex];
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: MessageCard(
                      message: messages?['message'] ?? 'no message',
                      role: messages?['role'] ?? 'no role',
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff0984e3), spreadRadius: 4, blurRadius: 0, offset: Offset(0, 2)
                    )
                  ]
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
        ],
      ),
    );
  }

  Future _doLogic() async {
    setState(() {
      isLoading = true;
    });
    if (data == null || data!.isEmpty) {
      await Chat.instance.addTitle(message.text, widget.id);
    }
    await Message.instance.insertMessage(message.text, 'user', widget.id);
    await _loadMessage();
    message.clear();
    final lastMessage = await Message.instance.newMessages();
    final reply = await getGptReply(lastMessage, widget.id);
    await Message.instance.insertMessage(reply, 'assistant', widget.id);
    _loadMessage();
    setState(() {
      isLoading = false;
    });
  }
}
