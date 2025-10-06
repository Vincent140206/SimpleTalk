import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

import '../constants/url.dart';

typedef MessageCallback = void Function(Map<String, dynamic> data);

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  static const baseUrl = "https://pg-vincent.bccdev.id";
  Urls urls = Urls();
  SocketService._internal();

  IO.Socket? socket;
  final List<MessageCallback> _privateMessageListeners = [];

  bool get isConnected => socket != null && socket!.connected;

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

    if (userId == null || userId.isEmpty) return;

    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setPath('/socket.io')
          .disableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) {
      print('Connected');
      joinRoom(userId);
    });

    socket!.on('PrivateMessage', (data) {
      print('Private message received: $data');
      for (var listener in _privateMessageListeners) {
        listener(data);
      }
    });

    socket!.onDisconnect((_) => print('Disconnected'));
    socket!.onConnectError((e) => print('Connect error: $e'));
    socket!.onError((e) => print('Socket error: $e'));
    socket!.connect();
  }

  void addPrivateMessageListener(MessageCallback callback) {
    _privateMessageListeners.add(callback);
  }

  void removePrivateMessageListener(MessageCallback callback) {
    _privateMessageListeners.remove(callback);
  }

  void joinRoom(String userId) {
    if (isConnected) {
      socket!.emit('joinRoom', {'userId': userId});
    }
  }

  void sendPrivateMessage(String toUserId, String message) {
    if (isConnected) {
      socket!.emit('PrivateMessage', {'to': toUserId, 'message': message});
    }
  }

  void dispose() {
    socket?.dispose();
    socket = null;
    _privateMessageListeners.clear();
  }
}
