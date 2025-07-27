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

  final ScrollController scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];
  String? myUserId;

  @override
  void initState() {
    super.initState();
    initializeChat();
  }

  Future<void> initializeChat() async {
    final prefs = await SharedPreferences.getInstance();
    myUserId = prefs.getString('userId');

    await loadMessages();

    socketService.addPrivateMessageListener(_onMessageReceived);
  }

  Future<void> loadMessages() async {
    try {
      final fetchedMessages = await messageService.fetchMessages(
          widget.contactId);

      setState(() {
        messages = fetchedMessages.map((msg) {
          return {
            "text": msg['message'],
            "isMe": msg['from'] == myUserId,
            "timestamp": socketService.formatTimestamp(msg['timestamp']),
          };
        }).toList();
      });

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  void _onMessageReceived(dynamic data) {
    if (!mounted) return;
    if (data['from'] == widget.contactId) {
      final formattedTime = socketService.formatTimestamp(
          data['timestamp'] ?? DateTime.now().toIso8601String());
      final alreadyExists = messages.any((msg) =>
      msg['text'] == data['message'] &&
          msg['timestamp'] == formattedTime &&
          msg['isMe'] == false);

      if (!alreadyExists) {
        setState(() {
          messages.add({
            "text": data['message'],
            "isMe": false,
            "timestamp": formattedTime,
          });
        });

        // Scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }
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

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    socketService.removePrivateMessageListener(_onMessageReceived);
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
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
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
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
                        const SizedBox(height: 4),
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
          const Divider(height: 1),
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
