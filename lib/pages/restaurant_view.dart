// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      // floatingActionButton: FloatingActionButton(onPressed: () {

      //   // Navigate.pssu
      // }),
      floatingActionButton:  ViewCartButton(



             onPressed: () {
                context.push('/cart',
                
                extra:  widget.restaurant.specialInstructions
                );
              },
      ),
    );
  }


}
