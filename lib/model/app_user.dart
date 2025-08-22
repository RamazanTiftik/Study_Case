import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String? uid;
  final String? email;
  final String? fullName;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  AppUser({
    this.uid,
    this.email,
    this.fullName,
    this.createdAt,
    this.lastLogin,
  });

  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] as String?,
      email: data['email'] as String?,
      fullName: data['fullName'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
    );
  }
}
