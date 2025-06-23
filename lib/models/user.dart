class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String role;

  final String? phoneNumber;
  // final DateTime created_at
  final bool isActive;
  final bool? isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastSignInAt;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.updatedAt,
    this.lastSignInAt,
    this.phoneNumber,
    this.isEmailVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName:
          json['firstName'] as String? ?? json['first_name'] as String? ?? '',
      lastName:
          json['lastName'] as String? ?? json['last_name'] as String? ?? '',
      role: json['role'] as String,
      phoneNumber:
          json['phoneNumber'] as String? ?? json['phone_number'] as String?,
      // createdAt: json['createdAt'] as DateTime? ?? json['created_at'] as DateTime?,
      createdAt: DateTime.parse(
        json['createdAt'] as String? ?? json['created_at'] as String,
      ),
      updatedAt: json['updatedAt'] != null || json['updated_at'] != null
          ? DateTime.parse(
              json['updatedAt'] as String? ?? json['updated_at'] as String,
            )
          : null,
      lastSignInAt:
          json['lastSignInAt'] != null || json['last_sign_in_at'] != null
          ? DateTime.parse(
              json['lastSignInAt'] as String? ??
                  json['last_sign_in_at'] as String,
            )
          : null,
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      isEmailVerified:
          json['isEmailVerified'] as bool? ??
          json['is_email_verified'] as bool? ??
          false,
    );
  }
}
