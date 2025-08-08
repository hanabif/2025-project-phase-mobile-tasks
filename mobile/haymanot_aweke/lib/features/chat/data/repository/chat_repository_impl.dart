// ignore_for_file: directives_ordering, avoid_print, prefer_const_constructors

import 'package:dartz/dartz.dart';

import '../../../auth/data/datasource/user_local_datasource.dart';
import '../../../auth/data/model/user_model.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repository/chat_repository.dart';

import '../../../../core/error/failure.dart';
import '../datasource/chat_remote_datasource.dart';
import '../model/chat_model.dart';
import '../model/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final UserLocalDatasource userLocalDatasource;
  ChatRepositoryImpl(
    this.userLocalDatasource, {
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ChatEntity>>> getAllChats() async {
    try {
      print('📡 Repository: Fetching all chats...');
      final chats = await remoteDataSource.getAllChats();
      final entities = chats.map((e) => e.toEntity()).toList();
      print('✅ Repository: Got ${entities.length} chats.');
      return Right(entities);
    } catch (e) {
      print('❌ Repository Error in getAllChats: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    return await remoteDataSource.getChatById(chatId);
  }

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getMessagesInChat(
    String chatId,
  ) async {
    try {
      print('📡 Repository: Fetching messages for chat $chatId...');
      final messages = await remoteDataSource.getMessagesForChat(chatId);
      final entities = messages.map((e) => e.toEntity()).toList();
      print('✅ Repository: Got ${entities.length} messages.');
      return Right(entities);
    } catch (e) {
      print('❌ Repository Error in getMessagesInChat: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) async {
    final currentUser = await userLocalDatasource.getCachedUser();
    if (currentUser == null) throw Exception('No logged-in user found');

    final chat = await remoteDataSource.getMessagesForChat(chatId);
    try {
      print('📡 Repository: Sending message to $chatId...');
      final chat = await remoteDataSource.getChatById(chatId);
      final model = ChatMessageModel(
        id: '',
        content: content,
        type: type,
        sender: currentUser.toChatUserModel(),
        chat: chat,
      );

      await remoteDataSource.sendMessage(model);
      print('✅ Repository: Message sent.');
      return Right(model.toEntity());
    } catch (e) {
      print('❌ Repository Error in sendMessage: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Stream<ChatMessageEntity> receiveMessages() {
    try {
      print('📡 Repository: Listening for incoming messages...');
      final stream = remoteDataSource.receiveMessages();
      return stream.map((model) {
        final entity = model.toEntity();
        print('✅ Repository: Received message -> $entity');
        return entity;
      });
    } catch (e) {
      print('❌ Repository Error in receiveMessages: $e');
      return Stream.error(ServerFailure());
    }
  }
}
