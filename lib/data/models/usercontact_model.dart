class UserContactModel {
  final String id;
  final String email;
  final String name;
  final String? photoProfile;

  UserContactModel ({
    required this.id,
    required this.email,
    required this.name,
    this.photoProfile
  });

  factory UserContactModel.fromJson(Map<String, dynamic> json) {
    return UserContactModel(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
      photoProfile: json['photoProfile'] ?? null
    );
  }
}