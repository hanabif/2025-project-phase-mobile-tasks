import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../features/chat/data/model/message_model.dart';

class SocketService {
  late IO.Socket socket;

   final Map<String, StreamController<MessageModel>> _messageControllers = {};

  Future<void> connect() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('AUTH_TOKEN');

    if (token == null) {
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
    final completer = Completer<void>();
    socket.onConnect((_) {
      print('Socket connected');
      completer.complete();
    });

    socket.onDisconnect((_) {
      print(' Socket disconnected');
    });

    socket.onConnectError((err) {
      print(' Connect Error: $err');
      if (!completer.isCompleted) completer.completeError(err);
    });

    socket.onError((err) {
      print('Socket Error: $err');
    });

    socket.connect();
    return completer.future;
  }

  void disconnect() {
    socket.disconnect();
  }
   Stream<MessageModel> subscribeMessages(String chatId) {
    if (!_messageControllers.containsKey(chatId)) {
      _messageControllers[chatId] = StreamController<MessageModel>.broadcast();

      // Tell socket to join chat room
      socket.emit('chat:join', {'chatId': chatId});

      // Listen for messages for this chatId
      socket.on('message:received', (data) {
        try {
          final message = MessageModel.fromJson(Map<String, dynamic>.from(data));
          if (message.chatId == chatId) {
            _messageControllers[chatId]!.add(message);
          }
        } catch (e) {
          print('Error parsing message: $e');
        }
      });
    }

    return _messageControllers[chatId]!.stream;
  }
}
