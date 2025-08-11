import '../../domain/entities/chat_message_entity.dart';


abstract class ChatEvent {}

// Chats
class LoadChats extends ChatEvent {}

// Messages
class LoadMessages extends ChatEvent {
  final String chatId;
  LoadMessages({required this.chatId});
}

// Send message
class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String message;
  SendMessageEvent(this.chatId, this.message);
}

// Create chat
class CreateChatWithUser extends ChatEvent {
  final String participantId;
  CreateChatWithUser(this.participantId);
}

// Incoming message
class NewMessageReceived extends ChatEvent {
  final Message message;
  NewMessageReceived(this.message);
}

// Typing
class TypingEvent extends ChatEvent {
  final String chatId;
  TypingEvent(this.chatId);
}
class StopTypingEvent extends ChatEvent {
  final String chatId;
  StopTypingEvent(this.chatId);
}

// Users
class LoadUsers extends ChatEvent {}
