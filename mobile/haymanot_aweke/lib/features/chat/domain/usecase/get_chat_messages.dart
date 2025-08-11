import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/chat_message_entity.dart';
import '../entities/user.dart';
import '../repository/chat_repository.dart';


class GetChatMessagesUsecase extends UseCase<List<Message>, String> {
  final ChatRepository repo;
  GetChatMessagesUsecase(this.repo);
  @override
  Future<Either<Failure, List<Message>>> call(String chatId) => repo.getChatMessages(chatId);
}