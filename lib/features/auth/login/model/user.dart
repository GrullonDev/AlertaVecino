class User {
  User({required this.email, required this.residency, required this.house});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      residency: json['residency'],
      house: json['house'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'residency': residency, 'house': house};
  }

  final String email;
  final String residency;
  final String house;
}
