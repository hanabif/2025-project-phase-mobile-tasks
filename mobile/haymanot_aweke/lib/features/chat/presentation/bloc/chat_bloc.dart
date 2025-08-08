import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecase/get_all_chats.dart';
import '../../domain/usecase/get_chat_byId.dart';
import '../../domain/usecase/get_messages_in_chat.dart';
import '../../domain/usecase/send_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetAllChats getAllChats;
  final GetMessagesInChat getMessagesInChat;
  final SendMessage sendMessage;
  final GetChatById getChatById;

  ChatBloc({
    required this.getAllChats,
    required this.getMessagesInChat,
    required this.sendMessage,
    required this.getChatById,
  }) : super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<RefreshChats>(_onRefreshChats);
    on<SelectChat>(_onSelectChat);
    // on<SearchChats>(_onSearchChats);
    // on<NewMessageReceived>(_onNewMessageReceived);
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      print('[ChatBloc] Loading all chats...');
      final Either<Failure, List<ChatEntity>> result = await getAllChats();
      result.fold(
        (failure) {
          print('[ChatBloc] LoadChats failed: $failure');
          emit(ChatError());
        },
        (chats) {
          print('[ChatBloc] Loaded ${chats.length} chats.');
          emit(ChatLoaded());
        },
      );
    } catch (e) {
      print('[ChatBloc] Exception in LoadChats: $e');
      emit(ChatError());
    }
  }

  Future<void> _onRefreshChats(
    RefreshChats event,
    Emitter<ChatState> emit,
  ) async {
    try {
      print('[ChatBloc] Refreshing chats...');
      final Either<Failure, List<ChatEntity>> result = await getAllChats();
      result.fold(
        (failure) {
          print('[ChatBloc] RefreshChats failed: $failure');
          emit(ChatError());
        },
        (chats) {
          print('[ChatBloc] Refreshed ${chats.length} chats.');
          emit(ChatLoaded());
        },
      );
    } catch (e) {
      print('[ChatBloc] Exception in RefreshChats: $e');
      emit(ChatError());
    }
  }

  Future<void> _onSelectChat(SelectChat event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      print('[ChatBloc] Getting messages in chat ${event.chatId}...');
      final Either<Failure, List<ChatMessageEntity>> result =
          await getMessagesInChat(event.chatId);
      result.fold(
        (failure) {
          print('[ChatBloc] GetMessagesInChat failed: $failure');
          emit(ChatError());
        },
        (messages) {
          print('[ChatBloc] Loaded ${messages.length} messages.');
          emit(
            ChatLoaded(
             
            ),
          );
        },
      );
    } catch (e) {
      print('[ChatBloc] Exception in SelectChat: $e');
      emit(ChatError());
    }
  }

  // Future<void> _onSearchChats(
  //   SearchChats event,
  //   Emitter<ChatState> emit,
  // ) async {
  //   if (state is ChatLoaded) {
  //     final currentChats = (state as ChatLoaded).chats;
  //     final filteredChats =
  //         currentChats
  //             .where(
  //               (chat) =>
  //                   chat.name.toLowerCase().contains(event.query.toLowerCase()),
  //             )
  //             .toList();
  //     print(
  //       '[ChatBloc] Search result: ${filteredChats.length} chats found for "${event.query}".',
  //     );
  //     emit(ChatLoaded(chats: filteredChats));
  //   }
  // }



  // Future<void> _onNewMessageReceived(
  //   NewMessageReceived event,
  //   Emitter<ChatState> emit,
  // ) async {
  //   if (state is ChatLoaded) {
  //     final currentState = state as ChatLoaded;
  //     if (currentState.chatId == event.chatId) {
  //       final newMessage = ChatMessageEntity(
          
  //       );
  //       final updatedMessages = List<ChatMessageEntity>.from(
  //         currentState.messages,
  //       )..add(newMessage);
  //       print('[ChatBloc] New message added to chat ${event.chatId}.');
  //       emit(
  //         ChatLoaded(
            
  //         ),
  //       );
  //     }
  //   }
  // }



}
