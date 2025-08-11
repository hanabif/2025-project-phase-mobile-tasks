import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/usecases/usecase_params.dart';
import '../../../auth/data/datasource/user_local_datasource.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecase/create_chat.dart';
import '../../domain/usecase/get_all_users.dart';
import '../../domain/usecase/get_chat_messages.dart';
import '../../domain/usecase/get_my_chat.dart';
import '../../domain/usecase/send_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMyChatsUsecase getChats;
  final GetChatMessagesUsecase getMessages;
  final SendMessageUsecase sendMessage;
  final CreateChatWithUserUsecase createChat;
  final GetAllUsersUsecase getAllUsers;
  final UserLocalDatasource userLocalDatasource;
  final SharedPreferences sharedPreferences;
  late final StreamSubscription<Message> _messageSubscription;

  List<Message> _messages = [];
  String? _currentChatId;

  ChatBloc(  {
    
    required this.sharedPreferences,
    required this.userLocalDatasource,
    required this.getChats,
    required this.getMessages,
    required this.sendMessage,
    required this.createChat,
    required this.getAllUsers,
    required Stream<Message> messageStream, required Object getAllChats, required Object getMessagesInChat, required Object getChatById, required Object socketService,
  }) : super(ChatLoading()) {
    // Listen to incoming messages
    _messageSubscription = messageStream.listen((message) {
      add(NewMessageReceived(message));
    });

    // Load all users
    on<LoadUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final users = await getAllUsers(NoParams());
        emit(UsersLoaded(users));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    // Create chat with user
    on<CreateChatWithUser>((event, emit) async {
      emit(ChatCreating());
      try {
        final chat = await createChat(event.participantId);
        emit(ChatCreated(chat));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    // Load all chats
    on<LoadChats>((event, emit) async {
      emit(ChatLoading());
      try {
        final chats = await getChats(NoParams());
        emit(ChatLoaded(chats));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    // Load messages
    on<LoadMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        _currentChatId = event.chatId;
        final either = await getMessages(event.chatId);

        either.fold(
          (failure) {
            // handle failure
            emit(ChatError(failure.toString()));
          },
          (messages) {
            // success: messages is List<Message>
            _messages = messages;
            emit(MessagesLoaded(List<Message>.from(messages)));
          },
        );
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    // Send message
    on<SendMessageEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final currentUserId = prefs.getString('USER_ID');

      print('Current User ID: $currentUserId');
      if (currentUserId == null || currentUserId.isEmpty) {
        emit(ChatError('User not authenticated'));
        return;
      }

      try {
        final optimisticMessage = Message(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          chatId: event.chatId,
          content: event.message,
          senderId: currentUserId,
          //createdAt: DateTime.now(),
          type: 'text',
        );

        _messages.add(optimisticMessage);
        emit(MessagesLoaded(List.from(_messages)));

        await sendMessage(SendMessageParams(
          chatId: event.chatId, 
          content: event.message,
          type: 'text',
          ));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    // New message received
    on<NewMessageReceived>((event, emit) {
      if (_currentChatId != null && event.message.chatId == _currentChatId) {
        _messages.insert(0, event.message);
        emit(MessagesLoaded(List.from(_messages)));
      }
    });

    // Typing states
    // on<TypingEvent>((event, emit) {
    //   emit(TypingState(event.chatId, true));
    // });
    // on<StopTypingEvent>((event, emit) {
    //   emit(TypingState(event.chatId, false));
    // });
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    // _typingSubscription.cancel();
    return super.close();
  }
}
