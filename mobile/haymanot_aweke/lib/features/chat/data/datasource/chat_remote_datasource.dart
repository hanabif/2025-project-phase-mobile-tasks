// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/chat_message_model.dart';
import '../model/chat_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getAllChats();
  Future<List<ChatMessageModel>> getMessagesForChat(String chatId);
  Future<ChatModel> getChatById(String chatId);

  Future<void> sendMessage(ChatMessageModel message);
  Stream<ChatMessageModel> receiveMessages(); // from socket
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final IO.Socket socket;
  final Dio dio = Dio();

  ChatRemoteDataSourceImpl({required this.client, required this.socket});

  final String baseUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com';

  @override
  Future<List<ChatModel>> getAllChats() async {
    try {
      print('Fetching all chats...');
      final response = await client.get(Uri.parse('$baseUrl/api/v3/chats'));
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body)['data'] as List;
        final chats = decoded.map((json) => ChatModel.fromJson(json)).toList();
        print('Fetched ${chats.length} chats.');
        return chats;
      } else {
        print('Failed to load chats with status code: ${response.statusCode}');
        throw Exception('Failed to load chats');
      }
    } catch (e) {
      print('Error in getAllChats: $e');
      rethrow;
    }
  }

  @override
  Future<List<ChatMessageModel>> getMessagesForChat(String chatId) async {
    try {
      print('Fetching messages for chatId: $chatId...');
      final response = await client.get(
        Uri.parse('$baseUrl/api/v3/chats/$chatId/messages'),
      );
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body)['data'] as List;
        final messages =
            decoded.map((json) => ChatMessageModel.fromJson(json)).toList();
        print('Fetched ${messages.length} messages.');
        return messages;
      } else {
        print(
          'Failed to load messages with status code: ${response.statusCode}',
        );
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      print('Error in getMessagesForChat: $e');
      rethrow;
    }
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    try {
      final response = await dio.get( '$baseUrl/api/v3/chats/$chatId');
      return ChatModel.fromJson(response.data['data']);
    } catch (e) {
      print('❌ Failed to fetch chat: $e');
      rethrow;
    }
  }

  @override
  Future<void> sendMessage(ChatMessageModel message) async {
    try {
      final jsonMessage = message.toJson();
      print('Sending message: $jsonMessage');
      socket.emit('send_message', jsonMessage);
      print('Message emitted to socket.');
    } catch (e) {
      print('Error in sendMessage: $e');
      rethrow;
    }
  }

  @override
  Stream<ChatMessageModel> receiveMessages() {
    final controller = StreamController<ChatMessageModel>();

    try {
      print('Listening to receive_message socket event...');
      socket.on('receive_message', (data) {
        try {
          print('Received raw socket data: $data');
          final message = ChatMessageModel.fromJson(data);
          controller.add(message);
          print('Message added to stream: $message');
        } catch (e) {
          print('Error parsing received message: $e');
        }
      });
    } catch (e) {
      print('Error in receiveMessages setup: $e');
      controller.addError(e);
    }

    return controller.stream;
  }
}
