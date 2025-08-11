

import 'user.dart';

class Chat {
  final String id;
  final User user1;
  final User user2;

  const Chat({
    required this.id,
    required this.user1,
    required this.user2,
  });

  // factory Chat.fromJson(Map<String, dynamic> json) {
  //   return Chat(
  //     id: json['id'] ?? json['_id'] ?? '', user1: json['user1'], user2: json['user2'],
      
  //   );
  // }
}
