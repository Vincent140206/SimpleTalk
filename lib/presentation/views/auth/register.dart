import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_talk/presentation/viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _viewModel = RegisterViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Center(
              child: Text('Register'),
            ),
            SizedBox(height: 20,),
            Text('Name'),
            TextField(
              controller: nameController,
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
                  final name = nameController.text;
                  final email = emailController.text;
                  final password = passwordController.text;
                  _viewModel.register(name, email, password).then((success) {
                    if(success) {
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Register gagal')),
                      );
                    }
                  });
                },
                child: Text('Regist')
            ),
            SizedBox(height: 100,),
            ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/login');
                }, 
                child: Text('Login')
            )
          ],
        ),
      ),
    );
  }
}
