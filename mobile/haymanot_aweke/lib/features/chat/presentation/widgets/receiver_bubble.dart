import 'package:flutter/material.dart';

class ReceiverBubble extends StatelessWidget {
  final String text;
  // final String time;
  final String? avatarUrl;

  const ReceiverBubble({
    super.key,
    required this.text,
    // required this.time,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('You', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.purple[200],
              radius: 20,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null ? const Icon(Icons.person) : null,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          margin: const EdgeInsets.only(left: 80),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF5A68F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 4),
        //   child: Text(
        //     time,
        //     style: const TextStyle(color: Colors.grey, fontSize: 12),
        //   ),
        // ),
        const SizedBox(height: 14),
      ],
    );
  }
}
