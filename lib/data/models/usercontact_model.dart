class UserContactModel {
  final String id;
  final String email;
  final String name;

  UserContactModel ({
    required this.id,
    required this.email,
    required this.name,
  });

  factory UserContactModel.fromJson(Map<String, dynamic> json) {
    return UserContactModel(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
    );
  }
}