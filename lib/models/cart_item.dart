// !! WIP Still in progress not complete skipped to work on something else


import 'package:decimal/decimal.dart';

class CartItem {
  final int id;
  final String name;
  final Decimal basePrice; // MenuItem.basePrice

  final int quantity;
  final String restaurantId;
  final Map<int, List<int>> selectedOptions;
  final Decimal optionsPrice;

  CartItem({
    required this.id,
    required this.name,
    required this.basePrice,
    required this.quantity,
    required this.restaurantId,
    this.selectedOptions = const {},
    Decimal? optionsPrice,
  }) : optionsPrice = optionsPrice ?? Decimal.fromInt(0);

  // Create a copy with updated quantity - this is important for immutability
  CartItem copyWith({
    int? id,
    String? name,
    Decimal? basePrice,
    int? quantity,
    String? restaurantId,
    String? restaurantName,
    Map<int, List<int>>? selectedOptions,
    Decimal? optionsPrice,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      basePrice: basePrice ?? this.basePrice,
      quantity: quantity ?? this.quantity,
      restaurantId: restaurantId ?? this.restaurantId,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      optionsPrice: optionsPrice ?? this.optionsPrice,
    );
  }

  // Calculate total price for this item (price * quantity)

  Decimal get totalPrice =>
      (basePrice + optionsPrice) * Decimal.fromInt(quantity);

  double get totalPriceAsDouble => totalPrice.toDouble();
  double get basePriceAsDouble => basePrice.toDouble();
  double get optionsPriceAsDouble => optionsPrice.toDouble();

  String get configurationKey {
    // Sort the selected options to ensure consistent key generation
    final sortedOptions = Map<int, List<int>>.from(selectedOptions);
    sortedOptions.forEach((groupId, optionIds) {
      optionIds.sort(); // Ensure consistent ordering
    });
    return '$id-${sortedOptions.toString()}';
  }

  // Check if this cart item has the same configuration as another
  bool hasSameConfiguration(CartItem other) {
    return id == other.id && _mapsEqual(selectedOptions, other.selectedOptions);
  }

  // Helper method to compare option maps deeply
  bool _mapsEqual(Map<int, List<int>> map1, Map<int, List<int>> map2) {
    if (map1.length != map2.length) return false;

    for (final entry in map1.entries) {
      final otherList = map2[entry.key];
      if (otherList == null) return false;

      // Sort both lists for comparison
      final list1 = List<int>.from(entry.value)..sort();
      final list2 = List<int>.from(otherList)..sort();

      if (list1.length != list2.length) return false;
      for (int i = 0; i < list1.length; i++) {
        if (list1[i] != list2[i]) return false;
      }
    }
    return true;
  }
}
