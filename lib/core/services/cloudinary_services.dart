import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_talk/core/constants/url.dart';

class CloudinaryServices {
  final String cloudName = 'dtnk3lxej';
  final String uploadPreset = 'Simple-Talk';
  Dio dio = Dio();
  Urls urls = Urls();

  Future<String?> uploadImage(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'upload_preset': uploadPreset,
    });

    try {
      final response = await dio.post(Urls.uploadImage, data: formData);
      final imageUrl = response.data['secure_url'] as String?;
      print('Image uploaded successfully: $imageUrl');
      return imageUrl;
    } catch (e) {
      if (e is DioException) {
        print('Upload failed: ${e.response?.data}');
      } else {
        print('Error: $e');
      }
      return null;
    }
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    return picked != null ? File(picked.path) : null;
  }

  Future<bool> deleteImage(String publicId) async {
    try {
      final response = await dio.post(
        Urls.deleteProfileImage,
        data: {'public_id': publicId},
      );

      if (response.statusCode == 200) {
        print('Gambar berhasil dihapus dari server');
        return true;
      } else {
        print('Gagal menghapus gambar: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error saat menghapus gambar: $e');
      return false;
    }
  }


  String? extractPublicId(String url) {
    final regex = RegExp(r'/upload/(?:v\d+/)?(.+)\.(jpg|jpeg|png|webp)');
    final match = regex.firstMatch(url);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }

}