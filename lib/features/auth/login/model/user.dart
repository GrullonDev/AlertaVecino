class User {
  User({required this.id, required this.email, this.residency, this.house});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      residency: json['residency'] as String?,
      house: json['house'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'residency': residency, 'house': house};
  }

  final String id;
  final String email;
  final String? residency;
  final String? house;

  /// `true` cuando el usuario ya tiene residencia y unidad asignadas.
  bool get hasCompleteProfile =>
      (residency?.trim().isNotEmpty ?? false) &&
      (house?.trim().isNotEmpty ?? false);
}
