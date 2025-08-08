import 'package:flutter/material.dart';

class ChatDetailPage extends StatelessWidget {
  const ChatDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.pink[200],
                    radius: 22,
                    child: const Icon(Icons.thumb_up, color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sabila Sayma',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '8 members, 5 online',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.call, size: 24),
                  const SizedBox(width: 16),
                  const Icon(Icons.videocam, size: 24),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Messages area
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Message 1
                  _buildSenderBubble(
                    name: 'Annei Ellison',
                    text: 'Have a great working week!!',
                    time: '09:25 AM',
                  ),

                  _buildSenderBubble(
                    name: 'Annei Ellison',
                    text: 'This is my new 3d design',
                    time: '',
                  ),

                  _buildImageMessage(
                    imageUrl:
                        'https://via.placeholder.com/200x140.png?text=3D+Design',
                    time: '09:25 AM',
                  ),

                  _buildReceiverBubble(
                    text: 'You did your job well!',
                    time: '09:25 AM',
                  ),

                  _buildSenderVoiceMessage(
                    name: 'Annei Ellison',
                    duration: '00:16',
                    time: '09:25 AM',
                  ),

                  _buildReceiverBubble(
                    text: 'You did your job well!',
                    time: '09:25 AM',
                  ),
                ],
              ),
            ),

            // Bottom Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_file, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Write your message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Icon(Icons.mic_none, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sender text bubble
  Widget _buildSenderBubble({
    required String name,
    required String text,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.pink[200],
              radius: 20,
              child: const Icon(Icons.thumb_up),
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
        if (time.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 48, top: 4),
            child: Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        const SizedBox(height: 14),
      ],
    );
  }

  // Receiver text bubble
  Widget _buildReceiverBubble({required String text, required String time}) {
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
              child: const Icon(Icons.person),
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
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  // Image message
  Widget _buildImageMessage({required String imageUrl, required String time}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 48, top: 8),
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 48, top: 4),
          child: Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  // Voice message
  Widget _buildSenderVoiceMessage({
    required String name,
    required String duration,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.pink[200],
              radius: 20,
              child: const Icon(Icons.thumb_up),
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
          child: Row(
            children: [
              const Icon(Icons.play_arrow, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 20,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://i.imgur.com/O5p3W8F.png',
                      ), // placeholder waveform
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(duration, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 48, top: 4),
          child: Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
