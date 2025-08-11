import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

import '../../../../core/usecases/usecases.dart';
import '../entities/chat_entity.dart';
import '../repository/chat_repository.dart';

class CreateChatWithUserUsecase extends UseCase<Chat, String> {
  final ChatRepository repo;
  CreateChatWithUserUsecase(this.repo);
  @override
  Future<Either<Failure, Chat>> call(String userId) => repo.createChatWithUser(userId);
}