import 'package:flutter/material.dart';
import 'package:simple_talk/core/services/contact_services.dart';
import 'package:simple_talk/presentation/views/profile.dart';
import '../../core/services/shared_preference_service.dart';
import '../../data/models/contact_model.dart';

class ContactScreen extends StatefulWidget {
  final String userId;
  const ContactScreen({required this.userId, super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late Future<List<ContactModel>> futureContacts;
  final ContactServices _contactServices = ContactServices();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    setState(() {
      futureContacts = _contactServices.fetchContacts(widget.userId);
    });
  }

  void _showAddContactDialog() {
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Kontak'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Simpan'),
              onPressed: () async {
                final name = _nameController.text.trim();
                final email = _emailController.text.trim();

                if (name.isEmpty || email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Nama dan email wajib diisi')),
                  );
                  return;
                }

                try {
                  await _contactServices.addContact(
                    widget.userId,
                    name,
                    email,
                  );
                  Navigator.of(context).pop();
                  _loadContacts(); // refresh
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambahkan kontak: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kontak Saya')),
      body: FutureBuilder<List<ContactModel>>(
        future: _contactServices.fetchContacts(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Belum ada kontak'));
          }

          final contacts = snapshot.data!;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                leading: contact.user.photoProfile != null
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(contact.user.photoProfile!),
                  radius: 25,
                )
                    : const CircleAvatar(
                  child: Icon(Icons.person),
                  radius: 25,
                ),
                title: Text(contact.user.name),
                subtitle: Text('ID: ${contact.user.id}\nEmail: ${contact.user.email}'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: {
                      'contactId': contact.user.id,
                      'contactName': contact.user.name,
                      'contactEmail': contact.user.email,
                      'contactProfile': contact.user.photoProfile,
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        child: Icon(Icons.add),
        tooltip: 'Tambah Kontak',
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ElevatedButton(
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
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                }, child: Text('Profile')
            )
          ],
        ),
      ),
    );
  }
}
