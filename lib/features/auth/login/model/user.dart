class User {
  User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.residency,
    this.house,
    this.role,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      residency: json['residency'] as String?,
      house: json['house'] as String?,
      role: json['role'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'residency': residency,
        'house': house,
        'role': role,
        'createdAt': createdAt?.toIso8601String(),
      };

  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? residency;
  final String? house;
  final String? role;
  final DateTime? createdAt;

  String get displayName {
    final parts = [firstName, lastName].whereType<String>().where((s) => s.isNotEmpty);
    return parts.isNotEmpty ? parts.join(' ') : email.split('@').first;
  }

  bool get hasCompleteProfile =>
      (residency?.trim().isNotEmpty ?? false) &&
      (house?.trim().isNotEmpty ?? false);
}
