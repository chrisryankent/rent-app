// TODO Implement this library.
// models/user.dart
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
}

enum UserType { tenant, landlord }
