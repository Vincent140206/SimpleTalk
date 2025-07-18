import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_talk/core/services/cloudinary_services.dart';

import '../constants/url.dart';
import 'dio_client.dart';

class UserServices {
  Urls urls = Urls();
  final dioClient = DioClient();
  CloudinaryServices cloudinaryServices = CloudinaryServices();

  Future<void> updatePhotoProfile(String newImageUrl, String? oldImageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await dioClient.dio.put(
        Urls.updateProfileImage,
        data: {
          'photoProfile': newImageUrl,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Foto profil berhasil diperbarui');

        if (oldImageUrl != null) {
          final publicId = cloudinaryServices.extractPublicId(oldImageUrl);
          if (publicId != null) {
            final success = await cloudinaryServices.deleteImage(publicId);
            if (success) {
              print('Foto lama berhasil dihapus');
            } else {
              print('Gagal menghapus foto lama');
            }
          } else {
            print('Gagal ekstrak public ID dari URL lama');
          }
        }
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