import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/services/auth_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      final authService = AuthServices();
      authService.checkLoginStatus(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthServices();
    Future.microtask(() {
      authService.checkLoginStatus(context);
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
