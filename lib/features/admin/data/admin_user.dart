class AdminUser {
  AdminUser({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.residency,
    this.house,
    required this.status,
    this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
        id: json['id'] as String? ?? '',
        email: json['email'] as String? ?? '',
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        residency: json['residency'] as String?,
        house: json['house'] as String?,
        status: json['status'] as String? ?? 'pending',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );

  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? residency;
  final String? house;
  final String status;
  final DateTime? createdAt;

  String get displayName {
    final parts =
        [firstName, lastName].whereType<String>().where((s) => s.isNotEmpty);
    return parts.isNotEmpty ? parts.join(' ') : email.split('@').first;
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}
