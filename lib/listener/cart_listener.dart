import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hf_customer_app/models/cart.dart';
import 'package:hf_customer_app/models/cart_item.dart';
import 'package:hf_customer_app/models/menu_item.dart';
import 'package:hf_customer_app/models/menu_item_option_group.dart';
import 'package:hf_customer_app/models/menu_item_options.dart';

final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Cart> {
  CartNotifier() : super(Cart());

  // Add item to cart with sophisticated option handling
  bool addItem(CartItem item) {
    // Validate that we can add this item (restaurant restriction)
    if (!_canAddItemFromRestaurant(item.restaurantId)) {
      return false; // Different restaurant - reject
    }

    // If cart is empty, this becomes the first item and sets the restaurant
    if (state.isEmpty) {
      state = Cart(
        items: [item],
        restaurantId: item.restaurantId,
        restaurantName: _getRestaurantName(item.restaurantId),
      );
      return true;
    }

    // Look for existing item with identical configuration
    final existingItemIndex = state.items.indexWhere(
      (cartItem) => cartItem.hasSameConfiguration(item)
    );

    if (existingItemIndex != -1) {
      // Found identical item - combine quantities
      final existingItem = state.items[existingItemIndex];
      final updatedItems = List<CartItem>.from(state.items);
      
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
      
      state = state.copyWith(items: updatedItems);
    } else {
      // New configuration - add as separate item
      state = state.copyWith(items: [...state.items, item]);
    }
    
    return true;
  }

  // Update quantity for specific item configuration
  void updateQuantity(String configurationKey, int newQuantity) {
    if (newQuantity <= 0) {
      removeItemByConfigurationKey(configurationKey);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.configurationKey == configurationKey) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  // Remove specific item configuration
  void removeItemByConfigurationKey(String configurationKey) {
    final updatedItems = state.items
        .where((item) => item.configurationKey != configurationKey)
        .toList();
    
    if (updatedItems.isEmpty) {
      state = Cart(); // Clear everything if no items left
    } else {
      state = state.copyWith(items: updatedItems);
    }
  }

  // Get quantity for specific item configuration
  int getItemQuantity(String configurationKey) {
    final item = state.items.firstWhere(
      (item) => item.configurationKey == configurationKey,
      orElse: () => CartItem(
        id: 0, 
        restaurantId: '', 
        name: '', 
        basePrice: Decimal.fromInt(0), 
        quantity: 0,
        selectedOptions: {},
      ),
    );
    return item.quantity;
  }

  // Clear entire cart
  void clearCart() {
    state = Cart();
  }

  // Check if we can add item from this restaurant
  bool _canAddItemFromRestaurant(String restaurantId) {
    return state.isEmpty || state.restaurantId == restaurantId;
  }

  // Helper to get restaurant name (you'll implement this based on your data source)
  String _getRestaurantName(String restaurantId) {
    // TODO: Implement restaurant name lookup
    // This could query your restaurant data or be passed in from the UI
    return "Restaurant"; // Placeholder
  }

  // Update restaurant info (called when first item is added)
  void updateRestaurantInfo(String restaurantId, String restaurantName) {
    if (state.restaurantId!.isEmpty) {
      state = state.copyWith(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
      );
    }
  }
}

// Helper functions for creating cart items
class CartHelper {
  // Create CartItem from MenuItem and selected options
  static CartItem createCartItem({
    required MenuItem menuItem,
    required String restaurantName,
    required Map<int, List<MenuItemOptions>> selectedOptionsByGroup,
    int quantity = 1,
  }) {
    // Calculate total price modifier from all selected options
    Decimal totalOptionsPrice = Decimal.fromInt(0);
    Map<int, List<int>> selectedOptionsMap = {};

    // Process each option group
    for (final entry in selectedOptionsByGroup.entries) {
      final groupId = entry.key;
      final selectedOptions = entry.value;
      
      // Store the option IDs for this group
      selectedOptionsMap[groupId] = selectedOptions.map((opt) => opt.id).toList();
      
      // Add up the price modifiers
      for (final option in selectedOptions) {
        totalOptionsPrice += option.priceModifier;
      }
    }

    return CartItem(
      id: menuItem.id,
      restaurantId: menuItem.restaurantId,
      name: menuItem.name,
      basePrice: menuItem.basePrice,
      quantity: quantity,
      selectedOptions: selectedOptionsMap,
      optionsPrice: totalOptionsPrice,
    );
  }

  // Calculate price for menu item with selected options (useful for UI previews)
  static Decimal calculateItemPrice(
    MenuItem menuItem, 
    List<MenuItemOptions> selectedOptions
  ) {
    Decimal totalPrice = menuItem.basePrice;
    
    for (final option in selectedOptions) {
      totalPrice += option.priceModifier;
    }
    
    return totalPrice;
  }

  // Format price for display (converts Decimal to formatted string)
  static String formatPrice(Decimal price) {
    return '€${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // Validate that selected options meet group requirements
  static bool validateOptionSelection(
    MenuItemOptionGroup group,
    List<MenuItemOptions> selectedOptions,
  ) {
    final selectedCount = selectedOptions.length;
    
    // Check minimum selections
    if (selectedCount < group.minSelections) {
      return false;
    }
    
    // Check maximum selections
    if (selectedCount > group.maxSelections) {
      return false;
    }
    
    // If required, must have at least minimum selections
    if (group.isRequired && selectedCount < group.minSelections) {
      return false;
    }
    
    return true;
  }

  // Create a basic cart item for quick add (no customizations)
  static CartItem createBasicCartItem(MenuItem menuItem) {
    return CartItem(
      id: menuItem.id,
      restaurantId: menuItem.restaurantId,
      name: menuItem.name,
      basePrice: menuItem.basePrice,
      quantity: 1,
      selectedOptions: {}, // No customizations
      optionsPrice: Decimal.fromInt(0),
    );
  }
}
// // ignore_for_file: deprecated_member_use

// import 'package:flutter_riverpod/flutter_riverpod.dart';


// class CartNotifier extends StateNotifier<Map<int, int>> {
//   CartNotifier() : super({});

//   void addItem(int itemId) {
//     final currentCart = {...state};
//     currentCart[itemId] = (currentCart[itemId] ?? 0) + 1;
//     state = currentCart;
//   }

//   void removeItem(int itemId) {
//     final currentCart = {...state};
    
//     if (currentCart.containsKey(itemId)) {
//       if (currentCart[itemId]! > 1) {
//         currentCart[itemId] = currentCart[itemId]! - 1;
//       } else {
//         currentCart.remove(itemId);
//       }
//     }
    
//     state = currentCart;
//   }

//   void clearCart() {
//     state = {};
//   }

//   int getItemQuantity(int itemId) {
//     return state[itemId] ?? 0;
//   }

//   int get totalItems {
//     return state.values.fold(0, (sum, quantity) => sum + quantity);
//   }
// }

// final cartProvider = StateNotifierProvider<CartNotifier, Map<int, int>>((ref) {
//   return CartNotifier();
// });