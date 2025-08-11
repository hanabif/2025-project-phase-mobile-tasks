import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/user.dart';

abstract class ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final Either<Failure,List<Chat>> chats;
  ChatLoaded(this.chats);
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
}

class MessageSentSuccess extends ChatState {}

class ChatCreated extends ChatState {
  final Either<Failure,Chat> chat;
  ChatCreated(this.chat);
}

class TypingState extends ChatState {
  final String chatId;
  final bool isTyping;
  TypingState(this.chatId, this.isTyping);
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}

class UsersLoading extends ChatState {}

class UsersLoaded extends ChatState {
  final Either<Failure, List<User>> users; 
  UsersLoaded(this.users);
}

class ChatCreating extends ChatState {}
