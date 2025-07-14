import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_talk/data/models/contact_model.dart';
import '../constants/url.dart';
import 'dio_client.dart';

class ContactServices {
  final dioClient = DioClient();
  Urls urls = Urls();

  Future<List<ContactModel>> fetchContacts(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await dioClient.dio.get(
        '${Urls.getContacts}/$userId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      print('Response: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final List data = response.data['contacts'] ?? [];
        return data.map((json) => ContactModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil kontak');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil kontak: $e');
    }
  }

  Future<void> addContact(String userId, String name, String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await dioClient.dio.post(
          Urls.addContacts,
          data: {
            "userId": userId,
            "username": name,
            "email": email
          },
          options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              }
          )
      );
      if (response.statusCode == 200) {
        print('Kontak berhasil ditambahkan');
      } else if (response.statusCode == 400) {
        print('Kontak sudah ada');
      }

      if (response.statusCode != 200) {
        throw Exception('Gagal menyimpan kontak');
      }

      if (response.statusCode == 400) {
        throw Exception('Kontak sudah ada');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menambahkan kontak: $e');
    }
  }

}
