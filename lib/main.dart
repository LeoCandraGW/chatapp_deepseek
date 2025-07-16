import 'package:flutter/material.dart';
import 'package:gpt_app/pages/ChatPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_app/pages/HomePage.dart';
import 'package:gpt_app/static/Navigation.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: NavigationRoute.HomePageRoute.name,
      routes: {
        NavigationRoute.HomePageRoute.name: (context) => Homepage(),
        NavigationRoute.ChatPageRoute.name: (context) {
          final id = ModalRoute.of(context)!.settings.arguments as int;
          return ChatPage(id: id);
        },
      },
    );
  }
}
