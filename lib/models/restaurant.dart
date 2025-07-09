import 'package:hf_customer_app/enum/restaurant_verify_enum.dart';

class Restaurant {
  final String id;
  final String name;
  final String? description;
  final String? restaurantBanner;
  final String? restaurantPreviewBanner;
  final String? restaurantLogo;
  final String phoneNumber;
  final double? rating;
  final int reviewCount;
  final bool isActive;
  final bool featured;
  final RestaurantVerification verified;
  Restaurant({
    required this.id,
    required this.name,
    this.description,
    this.restaurantBanner,
    this.restaurantPreviewBanner,
    this.restaurantLogo,
    required this.phoneNumber,
    this.rating,
    required this.reviewCount,
    required this.isActive,
    required this.featured,
    required this.verified,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      restaurantBanner:
          json['restaurant_banner'] as String? ??
          json['restaurant_banner'] as String? ??
          '',

      restaurantPreviewBanner:
          json['restaurant_preview_banner'] as String? ??
          json['restaurant_preview_banner'],

      restaurantLogo:
          json['restaurant_logo'] as String? ?? json['restaurant_logo'],

      phoneNumber: json['phoneNumber'] as String? ?? json['phone_number'] ?? '',
      rating: json['rating'] as double?,
      reviewCount:
          json['reviewCount'] as int? ?? json['review_count'] as int? ?? 0,

      isActive:
          json['isActive'] as bool? ?? json['is_active'] as bool? ?? false,
      featured: json['featured'] as bool? ?? false,
      // verified: RestaurantVerification(json['verified']),
      verified: RestaurantVerification.fromJson(json['verified']),
    );
  }
}
