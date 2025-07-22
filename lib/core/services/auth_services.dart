import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_talk/core/constants/url.dart';
import 'package:simple_talk/core/services/dio_client.dart';
import 'package:simple_talk/presentation/views/contacts.dart';

import '../../presentation/views/auth/login.dart';

class AuthServices {
  final dioClient = DioClient();
  Urls urls = Urls();

  Future<void> checkLoginStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    if (token != null && userId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ContactScreen(userId: userId)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }


  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        Urls.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('userId', data['user']['id']);
        return response.data;
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }

    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Login Failed';
      print('Login error: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        Urls.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
        }
      );
      return response.data;
    } on DioException catch(e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Login Failed');
      } else {
        throw Exception('Network error');
      }
    }
  }

  Future<void> deleteAccount() async {
    try{
      final response = await dioClient.dio.delete(Urls.deleteAccount);
      print('Akun berhasil dihapus: ${response.data}');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        throw Exception(data['message']);
      } else {
        throw Exception('Gagal menghapus akun');
      }
    }
  }

  Future<void> sendOTP(String email) async {
    try {
      final response = await dioClient.dio.post(
        Urls.sendOTP,
        data: {'email': email},
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to send OTP with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Failed to send OTP';
      print('Send OTP error: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> verifyOTP(String email, String otp) async {
    try {
      final response = await dioClient.dio.post(
        Urls.verifyOTP,
        data: {
          'email': email,
          'otp': otp
        },
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'OTP verification failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ??
          'OTP verification failed';
      print('OTP verification error: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

}