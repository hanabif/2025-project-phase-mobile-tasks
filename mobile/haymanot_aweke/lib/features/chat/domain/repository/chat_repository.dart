import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/chat_model.dart';
import '../entities/chat_entity.dart';
import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getAllChats();
  Future<Either<Failure, List<ChatMessageEntity>>> getMessagesInChat(String chatId);
  Future<ChatModel> getChatById(String chatId);
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String chatId,
    required String content,
    required String type,
  });

  /// This is for receiving real-time messages via socket
  Stream<ChatMessageEntity> receiveMessages();
}
