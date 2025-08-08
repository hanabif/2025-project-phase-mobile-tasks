import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/chat_message_entity.dart';
import '../repository/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<Failure, ChatMessageEntity>> call({
    required String chatId,
    required String content,
    required String type,
  }) {
    return repository.sendMessage(
      chatId: chatId,
      content: content,
      type: type,
    );
  }
}
