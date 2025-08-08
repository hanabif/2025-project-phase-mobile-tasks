import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/chat_entity.dart';

import '../repository/chat_repository.dart';

class GetChatById {
  final ChatRepository repository;

  GetChatById(this.repository);

  Future<Object> call(String chatId) async {
    try {
      return await repository.getChatById(chatId);
    } catch (e) {
      print('GetChatById UseCase Error: $e');
      return Left(ServerFailure());
    }
  }
}
