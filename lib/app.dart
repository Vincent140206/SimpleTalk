import 'package:flutter/material.dart';
import 'package:simple_talk/presentation/views/auth/login.dart';
import 'package:simple_talk/presentation/views/auth/register.dart';
import 'package:simple_talk/presentation/views/chat.dart';
import 'package:simple_talk/presentation/views/contacts.dart';
import 'package:simple_talk/presentation/views/home.dart';
import 'package:simple_talk/presentation/views/splashscreen.dart';

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
      home: SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ChatScreen(
              contactId: args['contactId'],
              contactName: args['contactName'],
              contactEmail: args['contactEmail'],
              contactProfile: args['contactProfile'],
            ),
          );
        }
        return null;
      },
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
