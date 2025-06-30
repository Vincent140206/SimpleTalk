import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/shared_preference_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefService.init();
  runApp(const MyApp());
}