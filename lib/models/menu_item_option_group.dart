// !! Menu item option groups e.g Toppins, dressings, sizes, etc


class MenuItemOptionGroup {
  final int id;
  final  int menuItemId;

  final String name;
  final String? description;
  final bool isRequired;
  final int minSelections;
  final int maxSelections;

  final bool isActive;

  MenuItemOptionGroup({
    required this.id,
      required this.menuItemId,
    required this.name,
    this.description, 
      required this.isRequired,
      required this.minSelections,
      required this.maxSelections,

    required this.isActive,
  });

  factory MenuItemOptionGroup.fromJson(Map<String, dynamic> json) {
    return MenuItemOptionGroup(
      id: json['id'] as int,

      menuItemId: json['menuItemId'] as int? ?? json['menu_item_id'],

      name: json['name'] as String,

      description: json['description'] as String?,
      isRequired: json['isRequired'] as bool? ?? json['is_required'] as bool,

      minSelections: json['minSelections'] as int? ?? json['min_selections'],

    
    maxSelections:  json['maxSelections'] as int? ?? json['max_selections'],

      isActive: json['isActive'] as bool? ?? json['is_active'] as bool,
    );
  }
}