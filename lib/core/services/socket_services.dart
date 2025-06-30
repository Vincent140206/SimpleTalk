import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(
      'http://10.0.2.2:5000',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
    );

    socket.connect();

    socket.onConnect((_) => print('Connected to server'));
    socket.onDisconnect((_) => print('Disconnected from server'));
  }

  void sendMessage(String message) {
    socket.emit('sendMessage', {'message': message});
  }

  void onMessage(Function(dynamic) callback) {
    socket.on('receiveMessage', callback);
  }

  void dispose() {
    socket.dispose();
  }
  
}