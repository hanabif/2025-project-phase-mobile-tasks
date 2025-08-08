import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../util/token_storage.dart';

class SocketService {
  late IO.Socket socket;

  void connect() {
    final token = TokenStorage().token;

    if (token == null) {
      print('⚠️ No token found. Cannot connect to socket.');
      return;
    }

    socket = IO.io(
      'https://g5-flutter-learning-path-be-tvum.onrender.com',

      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    socket.onConnect((_) {
      print('✅ Socket connected');
    });

    socket.onDisconnect((_) {
      print('❌ Socket disconnected');
    });

    socket.onConnectError((err) {
      print('⚠️ Connect Error: $err');
    });

    socket.onError((err) {
      print('🔥 Socket Error: $err');
    });

    socket.connect(); // 👈 don't forget this
  }

  void disconnect() {
    socket.disconnect();
  }
}
