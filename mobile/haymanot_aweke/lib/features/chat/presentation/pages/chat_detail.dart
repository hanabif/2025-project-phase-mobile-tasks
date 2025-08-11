import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart' as di;
import '../../domain/entities/chat_message_entity.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/receiver_bubble.dart';
import '../widgets/sender_bubble.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatId;
  final String userName;
  final String userInitials;
  final String currentUserId;

  const ChatDetailPage({
    Key? key,
    required this.chatId,
    required this.userName,
    required this.userInitials,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();

  late final ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();
    // Get the existing ChatBloc from DI container or context
    chatBloc = di.sl<ChatBloc>();
    // Load chat messages for this chat
    chatBloc.add(LoadMessages(chatId: widget.chatId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: chatBloc,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.userName)),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MessagesLoaded) {
                    final messages = state.messages;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isSender = msg.senderId == widget.currentUserId;

                        if (isSender) {
                          return SenderBubble(
                            name: 'you',
                            text: msg.content,
                            avatarUrl: null,
                          );
                        } else {
                          return ReceiverBubble(text: msg.content);
                        }
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text(state.error));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Type your message...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final text = _messageController.text.trim();
              if (text.isNotEmpty) {
                context.read<ChatBloc>().add(
                  SendMessageEvent(widget.chatId, text),
                );
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
