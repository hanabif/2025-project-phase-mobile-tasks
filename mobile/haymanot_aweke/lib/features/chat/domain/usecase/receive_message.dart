import '../entities/chat_message_entity.dart';
import '../repository/chat_repository.dart';

class ReceiveMessages {
  final ChatRepository repository;

  ReceiveMessages(this.repository);

  Stream<ChatMessageEntity> call() {
    return repository.receiveMessages();
  }
}
