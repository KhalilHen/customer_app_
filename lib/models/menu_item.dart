import 'package:decimal/decimal.dart';

class MenuItem {
  final int id;
  final String restaurantId;
  final int categoryId;
  final String name;
  final String? description;
  final String? image;
  final Decimal basePrice;
  final bool isAvailable;
  final bool isActive;
  // final int displayOrder;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.name,
    this.description, // Remove 'required' since it's nullable
    this.image, // Remove 'required' since it's nullable
    required this.basePrice,
    required this.isAvailable,
    required this.isActive,
    // required this.displayOrder,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      restaurantId: json['restaurant_id'] as String,
      categoryId: json['category_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      // Convert to Decimal - assuming the DB stores it as a number
      //  basePrice: json['base_price'] != null 
      //       ? Decimal.parse(json['base_price'].toString())
      //       : Decimal.zero,
      basePrice: Decimal.parse(json['base_price'].toString()),

              isAvailable: json['is_available'] as bool? ?? true,

      isActive: json['is_active'] as bool? ?? true,
      // displayOrder: json['display_order '] as int,
    );
  }
}