import 'package:dio/dio.dart';
import '../utils/token_storage.dart';

class DioClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:5000/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
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
}
