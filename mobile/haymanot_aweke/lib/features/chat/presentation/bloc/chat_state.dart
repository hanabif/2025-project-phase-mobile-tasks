import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  // final List<ChatEntity> chats;

  // const ChatLoaded(this.chats, {required List<ChatEntity> chat});

  // @override
  // List<Object?> get props => [chats];
}

class ChatError extends ChatState {
  // final String message;

  // const ChatError(this.message);

  // @override
  // List<Object?> get props => [message];
}

class ChatSelected extends ChatState {
  final String chatId;
  final String userName;
  final String userInitials;

  const ChatSelected({
    required this.chatId,
    required this.userName,
    required this.userInitials,
  });

  @override
  List<Object?> get props => [chatId, userName, userInitials];
}
