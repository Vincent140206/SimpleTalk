import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_talk/core/constants/url.dart';

import 'dio_client.dart';

class MessageService {
  final dioClient = DioClient();
  Urls urls = Urls();

  Future<List<Map<String, dynamic>>> fetchMessages(String contactId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    final response = await dioClient.dio.get(
      '${Urls.fetchMessage}/$userId/$contactId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 && response.data['messages'] is List) {
      return List<Map<String, dynamic>>.from(response.data['messages']);
    } else {
      throw Exception('Invalid response format');
    }
  }


  Future<void> deleteChatHistory(String contactId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    final response = await dioClient.dio.delete(
      '${Urls.fetchMessage}/$userId/$contactId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus riwayat pesan');
    }
  }
}