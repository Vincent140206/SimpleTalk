import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/message_services.dart';
import '../../core/services/socket_services.dart';

class ChatScreen extends StatefulWidget {
  final String contactId;
  final String contactName;
  final String contactEmail;
  final String? contactProfile;

  const ChatScreen({
    super.key,
    required this.contactId,
    required this.contactName,
    required this.contactEmail,
    this.contactProfile,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageService = MessageService();
  final TextEditingController messageController = TextEditingController();
  final SocketService socketService = SocketService();

  late List<Map<String, dynamic>> messages = [];
  late Function(dynamic) messageListener;

  @override
  void initState() {
    super.initState();
    loadMessages();

    messageListener = (data) {
      if (!mounted) return;
      if (data['from'] == widget.contactId) {
        final alreadyExists = messages.any((msg) =>
        msg['text'] == data['message'] && msg['isMe'] == false);
        if (!alreadyExists) {
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
      }
    };

    socketService.addPrivateMessageListener(messageListener);
  }

  Future<void> loadMessages() async {
    try {
      final fetchedMessages = await messageService.fetchMessages(widget.contactId);
      final prefs = await SharedPreferences.getInstance();
      final myUserId = prefs.getString('userId');

      setState(() {
        messages = fetchedMessages.map((msg) {
          return {
            "text": msg['message'],
            "isMe": msg['from'] == myUserId,
            "timestamp": socketService.formatTimestamp(msg['timestamp']),
          };
        }).toList();
      });
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  @override
  void dispose() {
    socketService.removePrivateMessageListener(messageListener);
    messageController.dispose();
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
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                widget.contactProfile ??
                    'https://sukafakta.com/wp-content/uploads/2024/06/Fakta-Unik-Monyet-Si-Cerdas-yang-Tahan-Banting-.webp',
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.contactName),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await messageService.deleteChatHistory(widget.contactId);
                setState(() {
                  messages.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Chat berhasil dihapus")),
                );
              },
              child: const Text('Hapus Chat'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
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
