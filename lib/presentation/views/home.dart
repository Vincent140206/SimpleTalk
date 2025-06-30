import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_talk/core/services/shared_preference_service.dart';

import '../viewmodels/auth_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> messages = [
    {"text": "Halo!", "isMe": true},
    {"text": "Hai juga!", "isMe": false},
    {"text": "Lagi ngapain?", "isMe": true},
    {"text": "Ngoding flutter nih", "isMe": false},
  ];
  final TextEditingController messageController = TextEditingController();
  final _viewModel = DeleteViewModel();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  SharedPrefService.clear().then((success) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout berhasil')),
                      );
                      Navigator.pushReplacementNamed(context, '/register');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout gagal')),
                      );
                    }
                  });
                },
                child: Text('Logout'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Konfirmasi'),
                    content: Text('Yakin ingin hapus akun?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final success = await _viewModel.delete();
                          if (success) {
                            Navigator.pushReplacementNamed(context, '/');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Gagal hapus akun")),
                            );
                          }
                        },
                        child: Text('Ya, hapus'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Delete Account'),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return Align(
                          alignment: msg['isMe']
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: msg['isMe']
                                  ? Colors.blue[200]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(msg['text']),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(height: 1),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: 'Ketik pesan...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (messageController.text.trim().isNotEmpty) {
                              setState(() {
                                messages.add({
                                  "text": messageController.text.trim(),
                                  "isMe": true,
                                });
                              });
                              messageController.clear();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
