import 'package:dio/dio.dart';
import 'package:simple_talk/core/services/dio_client.dart';

class AuthServices {
  final dioClient = DioClient();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try{
      final response = await dioClient.dio.post(
        'api/auth/login',
        data: {
          'email': email,
          'password': password
        },
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

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        'api/auth/register',
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
      final response = await dioClient.dio.delete('api/auth/delete');
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
}