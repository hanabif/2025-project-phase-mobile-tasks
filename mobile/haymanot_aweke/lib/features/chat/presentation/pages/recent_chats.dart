import 'dart:math';
import 'package:flutter/material.dart';

class RecentChats extends StatelessWidget {
  const RecentChats({super.key});

  // Generate random colors for initials
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
      return '${names[0][0]}${names[1][0]}';
    } else {
      return names[0][0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final stories = [
      {'name': 'My status', 'hasAdd': true},
      {'name': 'Adil'},
      {'name': 'Marina'},
      {'name': 'Dean'},
      {'name': 'Max'},
    ];

    final chats = [
      {
        'name': 'Alex Linderson',
        'message': 'How are you today?',
        'unread': 3,
        'online': true,
      },
      {
        'name': 'Team Align',
        'message': 'Don’t miss to attend the meeting.',
        'unread': 4,
        'online': true,
      },
      {
        'name': 'John Ahraham',
        'message': 'Hey! Can you join the meeting?',
        'online': false,
      },
      {
        'name': 'Sabila Sayma',
        'message': 'How are you today?',
        'online': false,
      },
      {'name': 'John Borino', 'message': 'Have a good day 🌸', 'online': true},
      {'name': 'Angel Dayna', 'message': 'How are you today?', 'online': false},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top stories bar
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 10,
            ),
            color: const Color(0xFF5796F4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.search, color: Colors.white, size: 28),
                const SizedBox(height: 20),
                SizedBox(
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
              ],
            ),
          ),

          // Chat list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: chats.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final chat = chats[index];
                final initials = getInitials(chat['name']! as String);
                final color = getRandomColor(chat['name']! as String);

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/chatDetail',
                      arguments: {
                        'name': chat['name'] as String,
                        'message': chat['message'] as String,
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
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
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    chat['online'] == true
                                        ? Colors.green
                                        : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat['name']! as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              chat['message']! as String,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "2 min ago",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          if (chat.containsKey('unread'))
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF5A68F2),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                chat['unread'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
