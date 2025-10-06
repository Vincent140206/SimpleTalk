import 'dart:io';
import 'package:dio/dio.dart';
import '../constants/network_config.dart';
import '../utils/token_storage.dart';

class DioClient {
  final Dio dio;

  DioClient._internal(this.dio);

  factory DioClient() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://pg-vincent.bccdev.id',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
    ))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ));

    return DioClient._internal(dio);
  }
}
