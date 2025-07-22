import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../viewmodels/auth_viewmodel.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String name;
  final String password;

  const OtpScreen({super.key, required this.email, required this.name, required this.password});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _verifyOTPViewModel = VerifyOTPViewModel();
  final _registerViewModel = RegisterViewModel();
  final otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        backgroundColor: const Color(0xFFE7CCB1),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter the OTP sent to your email',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'OTP',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final email = widget.email;
                  final otp = otpController.text;
                  _verifyOTPViewModel.verifyOTP(email, otp).then((success) {
                    if (success) {
                      _registerViewModel.register(widget.name, email, widget.password,
                      ).then((registered) {
                        if (registered) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registration successful!')),
                          );
                          Navigator.pushReplacementNamed(context, '/login');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registration failed!')),
                          );
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid OTP!')),
                      );
                    }
                  });
                },
                child: const Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
