// !! WIP Still in progress not complete skipped to work on something else

import 'package:decimal/decimal.dart';
import 'package:hf_customer_app/models/cart_item.dart';

class Cart {
  final List<CartItem> items;
  final String? restaurantId;
  final String? restaurantName;

  Cart({
    this.items = const [],
    this.restaurantId,
    this.restaurantName,
  });

  // Check if cart is empty
  bool get isEmpty => items.isEmpty;

  // Get total number of items (sum of all quantities)
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  // Get total price of all items
  Decimal get totalPrice => items.fold(  Decimal.fromInt(0), 
 (sum, item) => sum + item.totalPrice);



  double get totalPriceAsDouble => totalPrice.toDouble();

  // Create a copy with new items - essential for state management
  Cart copyWith({
    List<CartItem>? items,
    String? restaurantId,
    String? restaurantName,
  }) {
    return Cart(
      items: items ?? this.items,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
    );
  }
}
