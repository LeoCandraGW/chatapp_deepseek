import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gpt_app/datas/chat.dart';
import 'package:gpt_app/datas/message.dart';
import 'package:gpt_app/static/Navigation.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>>? chats;
  int? id;

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  Future _loadChat() async {
    final results = await Chat.instance.fetchChat();
    setState(() {
      chats = results;
    });
  }

  Future _createChat() async {
    await Chat.instance.createChat();
  }

  Future _newChat() async {
    final results = await Chat.instance.newChat();
    setState(() {
      id = results;
    });
  }

  Future _deleteChat(int id) async {
    await Chat.instance.deleteChat(id);
    await Message.instance.deleteMessages(id);
    _loadChat();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = chats == null || chats!.isEmpty;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xffffeaa7),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.arrowDown),
                  Padding(padding: const EdgeInsets.all(10)),
                  Text('scrolldown to refresh'),
                ],
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: _loadChat,
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xff55efc4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 4,
                        blurRadius: 0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(child: Text('AI CHAT')),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await _createChat();
                      await _newChat();
                      if (id != null) {
                        Navigator.pushNamed(
                          context,
                          NavigationRoute.ChatPageRoute.name,
                          arguments: id,
                        );
                      }
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff00b894),
                            spreadRadius: 4,
                            blurRadius: 0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(child: Icon(FontAwesomeIcons.plus, color: Color(0xff00b894),)),
                    ),
                  ),
                ),
                if (isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        'Start a new chat',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                else
                  ...chats!.map((chat) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            NavigationRoute.ChatPageRoute.name,
                            arguments: chat['id'] ?? 0,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfffd79a8),
                                spreadRadius: 4,
                                blurRadius: 0,
                                offset: Offset(-2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat['title'] ?? 'No Title',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      chat['createdAt'] ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _deleteChat(chat['id'] ?? 0);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Icon(
                                    FontAwesomeIcons.trash,
                                    color: Color(0xffd63031),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
