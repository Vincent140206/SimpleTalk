import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_talk/presentation/views/auth/register.dart';
import 'package:simple_talk/presentation/views/contacts.dart';

import '../../../core/services/socket_services.dart';
import '../../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _viewModel = LoginViewModel(SocketService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Center(
                child: Text('Login')
            ),
            SizedBox(height: 20,),
            Text('Email'),
            TextField(
              controller: emailController,
            ),
            SizedBox(height: 20,),
            Text('Password'),
            TextField(
              controller: passwordController,
            ),
            SizedBox(height: 50,),
            ElevatedButton(
                onPressed: () async {
                  final email = emailController.text;
                  final password = passwordController.text;
                  _viewModel.login(email, password).then((success) async {
                    if (success) {
                      final prefs = await SharedPreferences.getInstance();
                      final userId = prefs.getString('userId');
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context) => ContactScreen(userId: userId!)
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login gagal')),
                      );
                    }
                  });
                },
                child: Text('Login')
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
            }, 
                child: Text('Register')
            )
          ],
        ),
      ),
    );
  }
}