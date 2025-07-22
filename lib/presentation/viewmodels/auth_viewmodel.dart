import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_talk/core/services/auth_services.dart';

import '../../core/services/shared_preference_service.dart';
import '../../core/services/socket_services.dart';

class LoginViewModel {
  final AuthServices _loginService = AuthServices();
  final SocketService _socketService;
  LoginViewModel(this._socketService);

  Future<bool> login(String email, String password) async {
    try {
      final result = await _loginService.login(email, password);

      final token = result['token'];
      final userId = result['user']['id'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await SocketService().initSocket();

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

class SendOTPViewModel {
  final AuthServices _otpService = AuthServices();

  Future<bool> sendOTP(String email) async {
    try {
      await _otpService.sendOTP(email);
      return true;
    } catch (e) {
      print('Gagal mengirim OTP: $e');
      return false;
    }
  }
}

class VerifyOTPViewModel {
  final AuthServices _otpService = AuthServices();

  Future<bool> verifyOTP(String email, String otp) async {
    try {
      await _otpService.verifyOTP(email, otp);
      return true;
    } catch (e) {
      print('Gagal verifikasi OTP: $e');
      return false;
    }
  }
}