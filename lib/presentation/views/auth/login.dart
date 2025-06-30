import 'package:flutter/material.dart';

import '../../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _viewModel = LoginViewModel();

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
                onPressed: (){
                  final email = emailController.text;
                  final password = passwordController.text;
                  _viewModel.login(email, password).then((success) {
                    if (success) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login gagal')),
                      );
                    }
                  });
                },
                child: Text('Login')
            )
          ],
        ),
      ),
    );
  }
}