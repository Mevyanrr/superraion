class UserModel {
  final String uid;
  final String email;
  final String? username;
  final DateTime? birthDate;

  UserModel({required this.uid, required this.email, this.username, this.birthDate});
}