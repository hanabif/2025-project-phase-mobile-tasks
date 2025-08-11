import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../injection_container.dart' as di;
import '../../../auth/data/datasource/user_local_datasource.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/user.dart';
import '../model/chat_model.dart';
import '../model/message_model.dart';
import 'package:dio/dio.dart';

abstract class ChatApiService {
  Future<Chat> createChat(String userId);
  Future<List<Chat>> myChats();
  Future<Chat> chatById(String chatId);
  Future<List<MessageModel>> chatMessages(String chatId);
  Future<void> deleteChat(String chatId);
  Future<List<User>> getAllUsers();
}

class ChatApiServiceImpl implements ChatApiService {
  final dio = di.sl<DioClient>();
  final userLocal = di.sl<UserLocalDatasource>(); // <-- add

  static const String baseUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com';

  Future<Options> _authOptions() async {
    final token = await userLocal.getToken();
    print('token found: $token');
    if (token!.isEmpty) {
      print('Missing auth token');
      throw ServerException();
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<Chat> createChat(String userId) async {
    try {
      final options = await _authOptions();
      final res = await dio.post(
        '$baseUrl/api/v3/chats',
        data: {'userId': userId},
        options: options,
      );
      return ChatModel.fromJson(res.data['data']);
    } on DioException catch (e) {
      print('create chat failed: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<List<Chat>> myChats() async {
    try {
      final options = await _authOptions();
      final res = await dio.get('$baseUrl/api/v3/chats', options: options);
      final list = (res.data['data'] as List).cast<Map<String, dynamic>>();
      return list.map(ChatModel.fromJson).toList();
    } on DioException catch (e) {
      print('Fetch my chats failed: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<Chat> chatById(String chatId) async {
    try {
      final options = await _authOptions();
      final url = '${'$baseUrl/api/v3/chats'}/$chatId'; // concat id
      final res = await dio.get(url, options: options);
      return ChatModel.fromJson(res.data['data']);
    } on DioException catch (e) {
      print('Fetch chat failed: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> chatMessages(String chatId) async {
    try {
      final options = await _authOptions();
      final url = '${'$baseUrl/api/v3/chats'}/$chatId/messages'; // concat id
      final res = await dio.get(url, options: options);
      final list = (res.data['data'] as List).cast<Map<String, dynamic>>();
      return list.map(MessageModel.fromJson).toList();
    } on DioException catch (e) {
      print('Fetch messages failed: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    try {
      final options = await _authOptions();
      final url = '${'$baseUrl/api/v3/chats'}/$chatId'; // concat id
      await dio.delete(url, options: options);
    } on DioException catch (e) {
      print('Delete chat failed: ${e.message}');
      throw ServerException();
    }
  }


    @override
  Future<List<User>> getAllUsers() async {
    try {
      final res = await dio.get('$baseUrl/api/v3/chats', options: await _authOptions());
      final data = (res.data['data'] as List).cast<Map<String, dynamic>>();
      return data.map((u) => User(
        id: u['_id'] ?? '',
        name: u['name'] ?? '',
        email: u['email'] ?? '',
      )).toList();
    } on DioException catch (e) {
      print('getAllUsers failed: ${e.message}');
      throw ServerException();
    }
  }
}