import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/socket/socket_service.dart';
import '../../../auth/data/datasource/user_local_datasource.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/chat_repository.dart';
import '../datasource/chat_api_service.dart';
import '../model/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApiService api;
  final SocketService socket;
  final UserLocalDatasource userLocalDatasource;

  ChatRepositoryImpl({
    required this.userLocalDatasource,
    required this.api,
    required this.socket,
  });

  @override
  Future<Either<Failure, Chat>> createChatWithUser(String userId) async {
    try {
      final c = await api.createChat(userId);
      return Right(c);
    } on ServerException catch (e) {
      print(e.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> getMyChats() async {
    try {
      final list = await api.myChats();
      return Right(list);
    } on ServerException catch (e) {
      print(e.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Chat>> getChatById(String chatId) async {
    try {
      final c = await api.chatById(chatId);
      return Right(c);
    } on ServerException catch (e) {
      print(e.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId) async {
    try {
      final list = await api.chatMessages(chatId);
      return Right(list);
    } on ServerException catch (e) {
      print(e.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteChat(String chatId) async {
    try {
      await api.deleteChat(chatId);
      return const Right(null);
    } on ServerException catch (e) {
      print(e.toString());
      return Left(ServerFailure());
    }
  }

  // Socket connect: no token needed, SocketService reads it internally
  @override
  Future<void> connectSocket() => socket.connect();

  @override
  Future<void> disconnectSocket() async {
    try {
      socket.disconnect();
    } catch (e) {
      print('Socket disconnection error: $e');
      rethrow;
    }
  }

  @override
  Stream<Message> subscribeMessages(String chatId) {
    return socket.subscribeMessages(chatId);
  }

  // @override
  // Future<Either<Failure, void>> sendMessage({
  //   required String chatId,
  //   required String content,
  //   String type = 'text',
  // }) async {
  //   try {
  //     await socket.sendMessage(
  //       MessageModel(
  //         id: '', // or generate ID if necessary
  //         chatId: chatId,
  //         senderId:
  //             '', // consider getting current user ID here or from local datasource
  //         content: content,
  //         type: type,
  //       ),
  //     );
  //     return const Right(null);
  //   } catch (e) {
  //     print('Error sending message: $e');
  //     return Left(ServerFailure());
  //   }
  // }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      final list = await api.getAllUsers();
      return Right(list);
    } on ServerException catch (e) {
      print(e.toString());
      return Left(ServerFailure());
    }
  }
}
