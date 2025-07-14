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
  final TextEditingController messageController = TextEditingController();
  final SocketService socketService = SocketService();

  final List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();

    socketService.addPrivateMessageListener((data) {
      if (!mounted) return;

      if (data['from'] == widget.contactId) {
        setState(() {
          messages.add({
            "text": data['message'],
            "isMe": false,
            "timestamp": socketService.formatTimestamp(
              data['timestamp'] ?? DateTime.now().toIso8601String(),
            ),
          });
        });
      }
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    socketService.removePrivateMessageListener(
      (data) {
        if (data['from'] == widget.contactId) {
          setState(() {
            messages.removeWhere((msg) => msg['text'] == data['message']);
          });
        }
      },
    );
    super.dispose();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      socketService.sendPrivateMessage(widget.contactId, text);

      setState(() {
        messages.add({
          "text": text,
          "isMe": true,
          "timestamp": socketService.formatTimestamp(
            DateTime.now().toIso8601String(),
          ),
        });
      });

      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contactName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
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
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Ketik pesan...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (_) => sendMessage(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
