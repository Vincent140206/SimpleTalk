import 'package:simple_talk/data/models/usercontact_model.dart';

class ContactModel {
  final String id;
  final UserContactModel user;

  ContactModel({
    required this.id,
    required this.user
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['_id'],
      user: UserContactModel.fromJson(json['userId']),
    );
  }
}