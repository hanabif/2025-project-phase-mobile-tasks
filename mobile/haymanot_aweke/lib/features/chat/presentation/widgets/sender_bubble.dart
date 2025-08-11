import 'package:flutter/material.dart';

class SenderBubble extends StatelessWidget {
  final String name;
  final String text;
  // final String time;
  final String? avatarUrl;

  const SenderBubble({
    super.key,
    required this.name,
    required this.text,
    // required this.time,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.pink[200],
              radius: 20,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          margin: const EdgeInsets.only(left: 48),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F8FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text),
        ),
        // if (time.isNotEmpty)
        //   Padding(
        //     padding: const EdgeInsets.only(left: 48, top: 4),
        //     child: Text(
        //       time,
        //       style: const TextStyle(color: Colors.grey, fontSize: 12),
        //     ),
        //   ),
        const SizedBox(height: 14),
      ],
    );
  }
}
