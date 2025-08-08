import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/chat_message_entity.dart';
import '../repository/chat_repository.dart';

class GetMessagesInChat {
  final ChatRepository repository;

  GetMessagesInChat(this.repository);

  Future<Either<Failure, List<ChatMessageEntity>>> call(String chatId) {
    return repository.getMessagesInChat(chatId);
  }
}
