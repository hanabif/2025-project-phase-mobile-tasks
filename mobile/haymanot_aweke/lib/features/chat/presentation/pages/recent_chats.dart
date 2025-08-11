import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../injection_container.dart' as di;
import '../../domain/entities/chat_entity.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({Key? key}) : super(key: key);

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  String myUserId = '';
  String searchQuery = '';
  bool _isUserIdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      myUserId = prefs.getString('USER_ID') ?? '';
      _isUserIdLoaded = true;
    });
    di.sl<ChatBloc>().add(LoadChats());
  }

  Color getRandomColor(String input) {
    final random = Random(input.hashCode);
    return Color.fromARGB(
      255,
      100 + random.nextInt(155),
      100 + random.nextInt(155),
      100 + random.nextInt(155),
    );
  }

  String getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else {
      return names[0][0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUserIdLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final stories = [
      {'name': 'My status', 'hasAdd': true},
      {'name': 'Adil'},
      {'name': 'Marina'},
      {'name': 'Dean'},
      {'name': 'Max'},
    ];

    return BlocProvider<ChatBloc>.value(
      value: di.sl<ChatBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Custom AppBar with back + combined search bar + icon
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 10,
                right: 10,
                bottom: 10,
              ),
              color: const Color(0xFF5796F4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Container(
                    height: 36,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value.trim().toLowerCase();
                              });
                            },
                          ),
                        ),
                        const Icon(
                          Icons.search,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stories bar
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
                bottom: 10,
              ),
              color: const Color(0xFF5796F4),
              child: SizedBox(
                height: 85,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    final initials = getInitials(story['name'] as String);
                    final color = getRandomColor(story['name'] as String);

                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 26,
                                backgroundColor: color,
                                child: Text(
                                  initials,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            if (story['hasAdd'] == true)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          story['name'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Chat list from Bloc with search filtering and Either handling
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    return state.chats.fold(
                      (failure) =>
                          Center(child: Text('Error: ${failure.toString()}')),
                      (chatList) {
                        final filteredChats =
                            chatList.where((chat) {
                              final otherUser =
                                  chat.user1.id == myUserId
                                      ? chat.user2
                                      : chat.user1;
                              final chatName = otherUser.name.toLowerCase();
                              return chatName.contains(searchQuery);
                            }).toList();

                        if (filteredChats.isEmpty) {
                          return const Center(child: Text("No chats found."));
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          itemCount: filteredChats.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final chat = filteredChats[index];
                            final otherUser =
                                chat.user1.id == myUserId
                                    ? chat.user2
                                    : chat.user1;
                            final chatName = otherUser.name;
                            final initials = getInitials(chatName);
                            final color = getRandomColor(chatName);

                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/chatDetail',
                                  arguments: {
                                    'chatId': chat.id,
                                    'userName': chatName,
                                    'userInitials': initials,
                                    'currentUserId': myUserId,
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: color,
                                    child: Text(
                                      initials,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          chatName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        // Add last message preview here if available
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text(state.error));
                  } else {
                    return const Center(child: Text("Unknown state"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
