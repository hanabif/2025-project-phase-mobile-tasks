import 'user_entity.dart';

class ChatEntity {
  final String id;
  final UserEntity user1;
  final UserEntity user2;

  const ChatEntity({
    required this.id,
    required this.user1,
    required this.user2,
  });
}
