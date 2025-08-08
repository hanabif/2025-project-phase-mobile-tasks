import 'chat_entity.dart';
import 'user_entity.dart';

class ChatMessageEntity {
  final String id;
  final UserEntity sender;
  final ChatEntity chat;
  final String content;
  final String type;

  const ChatMessageEntity({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
  });
}
