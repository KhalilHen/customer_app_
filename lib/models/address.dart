
class Address {

  final int  id;
  final String  userId;
  final String   street;
  final String?  state;
  final String  zipCode;
  final String?  country;
  final double  latitude;
  final double  longitude;
  final bool?  isDefault;

  Address ({

    required this.id,
    required this.userId,
    required this.street,
    this.state,
    required this.zipCode,
    this.country,
    required this.latitude,
    required this.longitude,
    this.isDefault,

  });


  factory Address.fromJson(Map<String, dynamic> json) {

return Address(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      street: json['street'] as String? ?? '',
      state:
          json['state'] as String?,

      zipCode:
          json['zipCode'] as String? ??
          json['zip_code'],

      country:
          json['country'] as String?,

      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      isDefault:
          json['isDefault'] as bool? ?? json['is_default'] as bool? ?? false,
    
     );

  }
}
