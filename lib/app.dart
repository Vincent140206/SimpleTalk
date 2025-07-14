import 'package:flutter/material.dart';
import 'package:simple_talk/presentation/views/auth/login.dart';
import 'package:simple_talk/presentation/views/auth/register.dart';
import 'package:simple_talk/presentation/views/chat.dart';
import 'package:simple_talk/presentation/views/contacts.dart';
import 'package:simple_talk/presentation/views/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SimpleTalk',
      theme: ThemeData(
        primaryColor: const Color(0xFFE7CCB1),
            fontFamily: 'Roboto'
      ),
      home: RegisterScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
