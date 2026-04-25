import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? username;
  final DateTime? birthDate;
  final String? photoURL;

  UserModel({
    required this.uid,
    required this.email,
    this.username,
    this.birthDate,
    this.photoURL,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid:       data['uid'] ?? '',
      email:     data['email'] ?? '',
      username:  data['displayName'],
      photoURL:  data['photoURL'],
      birthDate: data['birth_date'] != null
          ? (data['birth_date'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid':          uid,
      'email':        email,
      'displayName':  username,
      'photoURL':     photoURL,
      'birth_date':   birthDate != null ? Timestamp.fromDate(birthDate!) : null,
    };
  }
}