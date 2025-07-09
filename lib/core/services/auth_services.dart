import 'package:dio/dio.dart';
import 'package:simple_talk/core/constants/url.dart';
import 'package:simple_talk/core/services/dio_client.dart';

class AuthServices {
  final dioClient = DioClient();
  Urls urls = Urls();

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