import 'package:simple_talk/core/services/auth_services.dart';
import 'package:simple_talk/core/services/shared_preference_service.dart';

class LoginViewModel {
  final AuthServices _loginService = AuthServices();

  Future<bool> login(String email, String password) async {
    try{
      final result = await _loginService.login(email, password);
      final token = result['token'];
      print('Login Sukses, Token: $token');

      await SharedPrefService.setToken(token);
      return true;
    } catch (e) {
      print('Login gagal: $e');
      return false;
    }
  }
}

class RegisterViewModel {
  final AuthServices _registerService = AuthServices();

  Future<bool> register(String name, String email, String password) async {
    try{
      final result = await _registerService.register(name, email, password);
      final msg = result['message'];
      print('Register Berhasil $msg');
      return true;
    } catch (e) {
      print('Register gagal: $e');
      return false;
    }
  }
}

class DeleteViewModel {
  final AuthServices _deleteService =  AuthServices();

  Future<bool> delete() async {
    try {
      await _deleteService.deleteAccount();
      await SharedPrefService.clear();
      return true;
    } catch (e) {
      print('Gagal hapus akun: $e');
      return false;
    }
  }
}