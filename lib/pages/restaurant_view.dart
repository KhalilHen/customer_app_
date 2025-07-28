// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hf_customer_app/controller/menu_category_controller.dart';
import 'package:hf_customer_app/controller/menu_controller.dart';
import 'package:hf_customer_app/controller/order_controller.dart';
import 'package:hf_customer_app/custom-widgets/menu_category_widget.dart';
import 'package:hf_customer_app/custom-widgets/menu_groups.dart';
import 'package:hf_customer_app/custom-widgets/menu_quantity_widget.dart';
import 'package:hf_customer_app/custom-widgets/view_cart.dart';
import 'package:hf_customer_app/custom-widgets/view_cart_button.dart';
import 'package:hf_customer_app/listener/cart_listener.dart';
import 'package:hf_customer_app/models/cart_item.dart';
import 'package:hf_customer_app/models/menu_category.dart';
import 'package:hf_customer_app/models/menu_item.dart';
import 'package:hf_customer_app/models/restaurant.dart';
import 'package:hf_customer_app/service/analytics_service.dart';

class RestaurantView extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantView({super.key, required this.restaurant});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  final orderController = OrderController();
  final menuCategoryController = MenuCategoryController();
  final menuItemController = MenuItemController();

  @override
  Widget build(BuildContext context) {
    if (!widget.restaurant.isOpen) {
      return const Scaffold(
        body: Center(child: Text("Sorry restaurant is momenteel gesloten")),
      );
    }

    if (!widget.restaurant.isActive) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Sorry de huidige restaurant is momenteel niet beschikbaar",
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                pinned: true,
                backgroundColor: Colors.deepOrange,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'restaurant-${widget.restaurant.id}',
                    child:
                        widget.restaurant.restaurantPreviewBanner == null ||
                            widget.restaurant.restaurantPreviewBanner!.isEmpty
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                widget.restaurant.restaurantPreviewBanner ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  title: Text(
                    widget.restaurant.name,
                    style: TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.6),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const Text(
                                '3',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' ${widget.restaurant.reviewCount} reviews',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '30 min',
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.restaurant.description ??
                              "Momenteel geen bescrijving beschikbaar",
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Menu Categories and Items
              CustomFetchRestaurantCategory(restaurantId: widget.restaurant.id),
          
              // Add some bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

 
          //       Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: ViewCartButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, '/cart');
          //     },
          //   ),
          // ),
    ],
      ),
      floatingActionButton: const ViewCart(),
    );
  }

  
Widget _buildMenuItem(MenuItem item) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        _showMenuItemDetails(item);
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your existing image code stays exactly the same
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: (item.image != null && item.image!.isNotEmpty)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.fastfood, color: Colors.grey, size: 30),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.fastfood, color: Colors.grey, size: 30),
                    ),
            ),

            const SizedBox(width: 16),

            // Enhanced item details section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (item.description != null && item.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        item.description!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Enhanced price display using your Decimal type
                      Text(
                        // Use CartHelper.formatPrice if you created the helper class,
                        // or keep your existing formatting
                        '€${item.basePrice.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),

                      // Enhanced add/quantity button with cart integration
                      Consumer(
                        builder: (context, ref, child) {
                          // Create a basic cart item to check if it's already in cart
                          final basicCartItem = CartItem(
                            id: item.id,
                            restaurantId: item.restaurantId,
                            name: item.name,
                            basePrice: item.basePrice,
                            quantity: 1,
                            selectedOptions: {}, // No options for basic version
                          );
                          
                          final quantity = ref.read(cartProvider.notifier)
                              .getItemQuantity(basicCartItem.configurationKey);

                          if (quantity > 0) {
                            // Show quantity controls if item is in cart
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      ref.read(cartProvider.notifier)
                                          .updateQuantity(basicCartItem.configurationKey, quantity - 1);
                                    },
                                    child: const Icon(Icons.remove, color: Colors.white, size: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ref.read(cartProvider.notifier)
                                          .updateQuantity(basicCartItem.configurationKey, quantity + 1);
                                    },
                                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Show add button if item not in cart
                            return GestureDetector(
                              onTap: () => _quickAddToCart(item, ref),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Toevoegen',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Add this new method to your RestaurantView class for quick cart additions
void _quickAddToCart(MenuItem item,  ref) {
  final cartItem = CartItem(
    id: item.id,
    restaurantId: item.restaurantId,
    name: item.name,
    basePrice: item.basePrice,
    quantity: 1,
    selectedOptions: {}, // No customizations for quick add
  );

  final success = ref.read(cartProvider.notifier).addItem(cartItem);

  if (!success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Je kunt alleen bestellen bij één restaurant tegelijk. Leeg je winkelwagen om bij ${widget.restaurant.name} te bestellen.',
        ),
        backgroundColor: Colors.red,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} toegevoegd aan winkelwagen!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

  void _showMenuItemDetails(MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
          
              const SizedBox(height: 20),
          
              // Item image if available
              if (item.image != null && item.image!.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.fastfood,
                            color: Colors.grey,
                            size: 60,
                          ),
                        );
                      },
                    ),
                  ),
                ),
          
              Text(
                item.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          
              const SizedBox(height: 8),
          
              if (item.description != null && item.description!.isNotEmpty)
                Text(
                  item.description!,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
          
              const SizedBox(height: 16),
          
              Text(
                '€${item.basePrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
          
              const SizedBox(height: 16),
          
              CustomQuantityCounter(
                itemId: item.id,
                onChanged: () {
                },
              ),
          
              const SizedBox(height: 20),
          
              CustomMenuGroupWidget(item: item),
          
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add to cart logic with customizations
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Toevoegen aan winkelwagen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

}
