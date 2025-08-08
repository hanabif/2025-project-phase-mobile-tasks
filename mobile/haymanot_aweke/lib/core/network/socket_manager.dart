import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  late IO.Socket socket;

  factory SocketManager() => _instance;

  SocketManager._internal();

  void connect(String token) {
    socket = IO.io('https://g5-flutter-learning-path-be-tvum.onrender.com', {
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {
        'Authorization': 'Bearer $token',
      }
    });

    socket.connect();
  }

  void disconnect() => socket.disconnect();
}
