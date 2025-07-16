import 'package:flutter/material.dart';
import 'package:hf_customer_app/controller/menu_category_controller.dart';
import 'package:hf_customer_app/controller/menu_controller.dart';
import 'package:hf_customer_app/controller/order_controller.dart';
import 'package:hf_customer_app/models/menu_category.dart';
import 'package:hf_customer_app/models/menu_item.dart';
import 'package:hf_customer_app/models/restaurant.dart';
import 'package:hf_customer_app/service/analytics_service.dart';
import 'package:decimal/decimal.dart';

class RestaurantView extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantView({super.key, required this.restaurant});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {

  final quantity = int;
  final orderController = OrderController();
  final menuCategoryController = MenuCategoryController();
  final menuItemController = MenuItemController(); // You'll need to create this
  
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
      body: CustomScrollView(
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
          FutureBuilder<List<MenuCategory>>(
            future: menuCategoryController.fetchCategoryFromRestaurant(
              widget.restaurant.id,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(50),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                
                case ConnectionState.none:
                  AnalyticsService.logEvent(
                    'connection_state_none',
                    page: 'restaurant_overview_page',
                  );
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(50),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );

                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Der is een fout gekomen bij het laden van categorieen. Contact support als dit blijft voorkomen',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                  
                  if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Geen categorieën beschikbaar',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                  
                  final categories = snapshot.data!
                      .where((category) => category.isActive)
                      .toList();
                  
                  // Sort categories by display order
                  categories.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
                  
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = categories[index];
                        return _buildCategorySection(category);
                      },
                      childCount: categories.length,
                    ),
                  );

                case ConnectionState.active:
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(50),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
              }
            },
          ),
          // Add some bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
  
    );
  }

  Widget _buildCategorySection(MenuCategory category) {
    final sectionName = category.name.isEmpty ? 'Naamloos' : category.name;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.deepOrange.withOpacity(0.1),
            border: const Border(
              left: BorderSide(
                color: Colors.deepOrange,
                width: 4,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sectionName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              if (category.description != null && category.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    category.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Menu Items for this category
        FutureBuilder<List<MenuItem>>(
          future: menuItemController.fetchMenuItems(category.id),
          
          
          // (category.id),
        
          builder: (context, itemSnapshot) {
            if (itemSnapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            
            if (itemSnapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Fout bij laden van menu items',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            
            if (!itemSnapshot.hasData || itemSnapshot.data == null || itemSnapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Geen items beschikbaar in deze categorie',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }
            
            final menuItems = itemSnapshot.data!
                .where((item) => item.isActive && item.isAvailable)
                .toList();
            
            // Sort items by display order
            // menuItems.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
            
            return Column(
              children: menuItems.map((item) => _buildMenuItem(item)).toList(),
            );
          },
        ),
      ],
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
            // Item Image
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
                            child: Icon(
                              Icons.fastfood,
                              color: Colors.grey,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.fastfood,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
            ),
            
            const SizedBox(width: 16),
            
            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  if (item.description != null && item.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        item.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // '€${item.basePrice.toStringAsFixed(2)}',

// Option 1: Simple string replacement
  '€${item.basePrice.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      
                      
                      
                                            Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
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
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          if (item.description != null && item.description!.isNotEmpty)
            Text(
              item.description!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
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

           Row(
            children: [


const Text("quanity", style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            
            ),),
   IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.deepOrange,
                                      ),
                                      onPressed: () {
                                        // orderController.removeItem(item.menuItem.id);
                                      },
                                    ),
                                    const Text(
                                      '5',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
         IconButton(
                                        onPressed: () {
                                          // orderController.addItem(item.menuItem);

                                        },
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.deepOrange,
                                        ))

            ],
          ),
  

          
          const SizedBox(height: 20),
          
          // TODO: Add option groups and customization here
          // You can add FutureBuilder for option groups
          
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
  );
}
}
