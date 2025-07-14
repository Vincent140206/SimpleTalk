class UserContactModel {
  final String id;
  final String email;

  UserContactModel ({
    required this.id,
    required this.email,
  });

  factory UserContactModel.fromJson(Map<String, dynamic> json) {
    return UserContactModel(
      id: json['_id'],
      email: json['email'],
    );
  }
}