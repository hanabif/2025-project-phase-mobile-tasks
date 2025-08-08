import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChats extends ChatEvent {
  const LoadChats();
}

class RefreshChats extends ChatEvent {
  const RefreshChats();
}

class SelectChat extends ChatEvent {
  final String chatId;
  final String userName;
  final String userInitials;

  const SelectChat({
    required this.chatId,
    required this.userName,
    required this.userInitials,
  });

  @override
  List<Object?> get props => [chatId, userName, userInitials];
}

class SearchChats extends ChatEvent {
  final String query;

  const SearchChats(this.query);

  @override
  List<Object?> get props => [query];
}

class NewMessageReceived extends ChatEvent {
  final String id;
  final String message;
  final String senderId;
  final DateTime timestamp;

  const NewMessageReceived({
    required this.id,
    required this.message,
    required this.senderId,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, message, senderId, timestamp];
}
