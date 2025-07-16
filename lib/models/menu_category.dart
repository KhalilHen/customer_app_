class MenuCategory {
  final int id;
  final String restaurantId;
  final String name;
  final String? description;
  final int displayOrder;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MenuCategory({
    required this.id,
    required this.restaurantId,
    required this.name,
     this.description,
    required this.displayOrder,
    required this.isActive,
     this.createdAt,
     this.updatedAt,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {

return MenuCategory(
      id: json['id'] as int,
      restaurantId: json['restaurant_id'] as String,
      name: json['name'] as String,
      description:
          json['description'] as String?,

      displayOrder:
          json['display_order'] as int,
          // json['zip_code'],

      isActive:
          json['is_active'] as bool,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString())
          : (json['createdAt'] != null 
              ? DateTime.tryParse(json['createdAt'].toString())
              : null),
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString())
          : (json['updatedAt'] != null 
              ? DateTime.tryParse(json['updatedAt'].toString())
              : null),
      );

  }
}

