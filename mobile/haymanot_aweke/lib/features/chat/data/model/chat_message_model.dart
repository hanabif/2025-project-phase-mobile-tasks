import '../../domain/entities/chat_message_entity.dart';
import 'chat_model.dart';
import 'user_model.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required UserModel super.sender,
    required ChatModel super.chat,
    required super.content,
    required super.type,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['_id'],
      sender: UserModel.fromJson(json['sender']),
      chat: ChatModel.fromJson(json['chat']),
      content: json['content'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'sender': (sender as UserModel).toJson(),
    'chat': (chat as ChatModel).toJson(),
    'content': content,
    'type': type,
  };
  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      sender: sender,
      chat: chat,
      content: content,
      type: type,
    );
  }
}
