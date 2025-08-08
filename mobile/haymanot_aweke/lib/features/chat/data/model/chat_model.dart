import '../../domain/entities/chat_entity.dart';
import 'user_model.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required UserModel super.user1,
    required UserModel super.user2,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      user1: UserModel.fromJson(json['user1']),
      user2: UserModel.fromJson(json['user2']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user1': (user1 as UserModel).toJson(),
        'user2': (user2 as UserModel).toJson(),
      };

  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      user1: UserModel.fromEntity(entity.user1),
      user2: UserModel.fromEntity(entity.user2),
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      user1: user1,
      user2: user2,
    );
  }
}
