import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants/network_config.dart';
import 'package:intl/intl.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket? socket;

  String formatTimestamp(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate).toLocal();
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

  Future<void> initSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null || userId.isEmpty) {
      print("❗ User ID not found, socket tidak diinisialisasi.");
      return;
    }

    final baseUrl = Platform.isAndroid ? emulatorIP : localIP;

    socket = IO.io(
      'http://$baseUrl:5000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) {
      print('✅ Connected to server');
      joinRoom(userId);
    });

    socket!.onDisconnect((_) => print('❌ Disconnected'));

    socket!.on('joinRoomSuccess', (data) {
      print('🎉 Join room success: $data');
    });

    socket!.on('PrivateMessage', (data) {
      print('📩 Private message received: $data');
    });

    socket!.on('receiveMessage', (data) {
      print('📢 Broadcast message: $data');
    });

    socket!.onConnectError((e) => print('⚠️ Connect error: $e'));
    socket!.onError((e) => print('❌ Socket error: $e'));

    socket!.connect();
  }

  void joinRoom(String userId) {
    if (_isSocketReady) {
      socket!.emit('joinRoom', {'userId': userId});
    }
  }

  void sendPrivateMessage(String toUserId, String message) {
    if (_isSocketReady) {
      socket!.emit('PrivateMessage', {'to': toUserId, 'message': message});
    }
  }

  void sendBroadcastMessage(String message) {
    if (_isSocketReady) {
      socket!.emit('sendMessage', {'message': message});
    }
  }

  void leaveRoom(String roomId) {
    if (_isSocketReady) socket!.emit('leaveRoom', roomId);
  }

  void getRoomInfo(String roomId) {
    if (_isSocketReady) socket!.emit('getRoomInfo', roomId);
  }

  void disconnect() {
    socket?.disconnect();
  }

  void dispose() {
    socket?.dispose();
    socket = null;
  }

  bool get _isSocketReady => socket != null && socket!.connected;
}
