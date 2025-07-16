import 'package:flutter/material.dart';
import 'package:simple_talk/core/services/cloudinary_services.dart';
import 'package:simple_talk/core/services/user_services.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userService = UserServices();
  final cloudinaryService = CloudinaryServices();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final data = await userService.getUserProfile();
    if (mounted) {
      setState(() {
        userData = data;
      });
    }
  }

  Future<void> _handleChangePhoto() async {
    final pickedFile = await cloudinaryService.pickImage();
    if (pickedFile != null) {
      try {
        final uploadedUrl = await cloudinaryService.uploadImage(pickedFile);
        if (uploadedUrl != null) {
          await userService.updatePhotoProfile(uploadedUrl);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto profil berhasil diperbarui')),
          );

          loadUserData(); // Refresh tampilan
        } else {
          throw 'Upload gagal';
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui foto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = userData?['photoProfile'];

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl)
                  : const NetworkImage(
                  'https://cdn0-production-images-kly.akamaized.net/AwEA4f95P32p5tToO6yPl_bmw4w=/800x1066/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/1206778/original/091788000_1460967229-ad159740326pictured-the-v.jpg'),
            ),
            const SizedBox(height: 20),
            Text(
              userData?['name'] ?? 'Nama tidak ditemukan',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(userData?['email'] ?? 'Email tidak ditemukan'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _handleChangePhoto,
              child: const Text('Ganti Foto Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
