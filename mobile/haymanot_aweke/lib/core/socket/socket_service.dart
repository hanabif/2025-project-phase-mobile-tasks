import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../features/chat/data/model/message_model.dart';


abstract class SocketService {
  Future<void> connect(String token);
  Future<void> disconnect();
  Stream<MessageModel> subscribeMessages(String chatId);
  Future<void> sendMessage(MessageModel message);
}
class SocketServiceImpl implements SocketService {
  void Function(Map<String, dynamic>)? onTyping;
  void Function(Map<String, dynamic>)? onStopTyping;
  static const String serverUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com';
  IO.Socket? _socket;
  final _controllers = <String, StreamController<MessageModel>>{};

  // Callbacks
  void Function(MessageModel)? onMessageReceived;
  void Function(MessageModel)? onMessageDelivered;
  void Function(String)? onMessageError;
  void Function()? onConnected;
  void Function()? onDisconnected;

  Future<void> connect(String token) async {
  if (token.isEmpty) throw Exception('No token provided');

  _socket = IO.io(
    serverUrl,
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .setExtraHeaders({'Authorization': 'Bearer $token'})
        .build(),
  );

  // Now _socket is not null, so you can safely set event listeners
  _socket!.on('userTyping', (data) {
    if (onTyping != null) {
      onTyping!(Map<String, dynamic>.from(data));
    }
  });
  _socket!.on('userStoppedTyping', (data) {
    if (onStopTyping != null) {
      onStopTyping!(Map<String, dynamic>.from(data));
    }
  });

  _socket!.onConnect((_) {
    onConnected?.call();
    print('WebSocket connected');
  });

  _socket!.onDisconnect((_) {
    onDisconnected?.call();
    print('WebSocket disconnected');
  });

  _socket!.on('message:received', (data) {
  try {
    final msg = MessageModel.fromJson(Map<String, dynamic>.from(data));
    onMessageReceived?.call(msg);
  } catch (e) {
    print('Error parsing message: $e');
    print('Raw data: $data');
  }
});

  _socket!.on('message:delivered', (data) {
    try {
      final msg = MessageModel.fromJson(Map<String, dynamic>.from(data));
      onMessageDelivered?.call(msg);
    } catch (e) {
      print('parse error delivered: $e');
    }
  });

  _socket!.on('message:error', (data) {
    final error = (data is Map && data['error'] != null)
        ? data['error'].toString()
        : 'Unknown error';
    onMessageError?.call(error);
  });
}

  @override
  Stream<MessageModel> subscribeMessages(String chatId) {
    print('[ChatSocketService] subscribeMessages called for chatId: $chatId');
    _controllers.putIfAbsent(chatId, () => StreamController<MessageModel>.broadcast());
    _socket?.emit('chat:join', {'chatId': chatId});
    print('[ChatSocketService] chat:join emitted for chatId: $chatId');
    return _controllers[chatId]!.stream;
  }

  Future<void> sendMessage(MessageModel message)async {
    if (_socket?.connected == true) {
      _socket!.emit('message:send', message.toJson());
    } else {
      onMessageError?.call('Socket not connected');
    }
  }

  void joinChat(String chatId) {
    if (_socket?.connected == true) {
      _socket!.emit('chat:join', {'chatId': chatId});
    }
  }

  Future<void> disconnect() async{
    _socket?.disconnect();
    _socket = null;
  }

  bool get isConnected => _socket?.connected ?? false;

  void emitTyping(String chatId) {
    if (_socket?.connected == true) {
      _socket!.emit('typing', {'chatId': chatId});
    }
  }

  void emitStopTyping(String chatId) {
    if (_socket?.connected == true) {
      _socket!.emit('stopTyping', {'chatId': chatId});
    }
  }
}
