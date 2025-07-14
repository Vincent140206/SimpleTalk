import 'package:flutter/material.dart';
import '../../core/services/socket_services.dart';

class ChatScreen extends StatefulWidget {
  final String contactId;
  final String contactName;
  final String contactEmail;

  const ChatScreen({
    super.key,
    required this.contactId,
    required this.contactName,
    required this.contactEmail,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController messageController;
  late final SocketService socketService;
  final List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    socketService = SocketService();

    socketService.socket?.off('PrivateMessage');
    socketService.socket?.on('PrivateMessage', (data) {
      if (!mounted) return;
      print('Private message received: $data');
      setState(() {
        messages.add({
          "text": data['message'],
          "isMe": false,
          "timestamp": socketService.formatTimestamp(
            data['timestamp'] ?? DateTime.now().toIso8601String(),
          ),
        });
      });
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    socketService.socket?.off('PrivateMessage');
    super.dispose();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    socketService.sendPrivateMessage(widget.contactId, text);
    setState(() {
      messages.add({
        "text": text,
        "isMe": true,
        "timestamp": socketService.formatTimestamp(DateTime.now().toIso8601String()),
      });
    });
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contactName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg['isMe'] ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(msg['text']),
                        Text(
                          msg['timestamp'],
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
