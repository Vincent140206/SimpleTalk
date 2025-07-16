import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/url.dart';
import 'dio_client.dart';

class UserServices {
  Urls urls = Urls();
  final dioClient = DioClient();

  Future<void> updatePhotoProfile(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await dioClient.dio.put(
        Urls.updateProfileImage,
        data: {
          'photoProfile': imageUrl,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Foto profil berhasil diperbarui');
      } else {
        print('Respon tidak berhasil: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Gagal update foto profil');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
    } catch (e) {
      print('Error tak terduga: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await dioClient.dio.get(
        Urls.getProfile,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return response.data;
    } catch (e) {
      print('Gagal ambil profil: $e');
      return null;
    }
  }
}