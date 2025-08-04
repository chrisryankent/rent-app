// models/user.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { tenant, owner }

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType type;
  final bool isVerified;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    this.isVerified = false,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      type: UserType.values.firstWhere(
        (e) => e.name == (data['type'] ?? 'tenant'),
        orElse: () => UserType.tenant,
      ),
      isVerified: data['isVerified'] ?? false,
    );
  }
}
