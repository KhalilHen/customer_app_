

import 'package:flutter/material.dart';
import 'package:hf_customer_app/controller/menu_category_controller.dart';
import 'package:hf_customer_app/controller/menu_controller.dart';
import 'package:hf_customer_app/custom-widgets/fetch_menu_items.dart';
import 'package:hf_customer_app/models/menu_category.dart';
import 'package:hf_customer_app/service/analytics_service.dart';


class CustomFetchRestaurantCategory extends StatefulWidget {
  final String restaurantId;
  const CustomFetchRestaurantCategory({super.key, required this.restaurantId});

  @override
  State<CustomFetchRestaurantCategory> createState() => _CustomFetchRestaurantCategoryState();
}

class _CustomFetchRestaurantCategoryState extends State<CustomFetchRestaurantCategory> {
    final  menuCategoryController = MenuCategoryController();
    final menuItemController = MenuItemController();
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List<MenuCategory>>(

      future: menuCategoryController.fetchCategoryFromRestaurant(widget.restaurantId),


builder:  (context, snapshot) {

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
          
                      if (!snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.data!.isEmpty) {
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
                      categories.sort(
                        (a, b) => a.displayOrder.compareTo(b.displayOrder),
                      );
          
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final category = categories[index];
                          return _buildCategorySection(category);
                        }, childCount: categories.length),
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
              left: BorderSide(color: Colors.deepOrange, width: 4),
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
              if (category.description != null &&
                  category.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    category.description!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
        ),

       CustomFetchMenuItems( categoryId: category,),
      ],
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:hf_customer_app/controller/menu_category_controller.dart';
// import 'package:hf_customer_app/controller/order_controller.dart';
// import 'package:hf_customer_app/models/menu_category.dart';


// class CustomMenuWidgets {
//   final menuCategoryController = MenuCategoryController();
//   final OrderController orderController;

//   CustomMenuWidgets({required this.orderController});

//   Widget buildMenuSection(BuildContext context, Map<String, dynamic> section) {
//     String title = section['title'];
//     int sectionId = section['id'];
//     print('Building menu section: title=$title, sectionId=$sectionId');

//     return FutureBuilder<List<MenuCategory>>(
//       future: menuCategoryController.fetchCategoryFromRestaurant(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return const Center(child: Text('Error loading menu items'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No menu items available!'));
//         }

//         List<MenuCategory> items = snapshot.data!;
//         return Column(
//           key: ValueKey(sectionId),
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.headlineLarge,
//             ),
//             const SizedBox(height: 16),
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: items.length,
//               separatorBuilder: (context, index) => const Divider(),
//               itemBuilder: (context, index) {
//                 return const Text("test");
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // class MenuItemWidget extends StatefulWidget {
// //   final MenuItem item;
// //   final OrderController orderController;
// // // final int  itemCount = 0;
// //   const MenuItemWidget({
// //     super.key,
// //     required this.item,
// //     required this.orderController,
// //   });

// //   @override
// //   State<MenuItemWidget> createState() => _MenuItemWidgetState();
// // }

// // class _MenuItemWidgetState extends State<MenuItemWidget> {
// //   @override
// //   void showMenuItemDetails(
// //     BuildContext context,
// //   ) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       builder: (_) => MenuItemBottomSheet(menuItem: widget.item),
// //     );
// //   }

// //   @override
// //   Widget build(
// //     BuildContext context,
// //   ) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: InkWell(
// //         onTap: () {
// //           showMenuItemDetails(context);
// //         },
// //         child: Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Container(
// //               width: 80,
// //               height: 80,
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(8),
// //                 image: widget.item.imageUrl != null
// //                     ? DecorationImage(
// //                         image: NetworkImage(widget.item.imageUrl!),
// //                         fit: BoxFit.cover,
// //                       )
// //                     : null,
// //                     //test
// //               ),
// //               child: widget.item.imageUrl == null
// //                   ? const Icon(
// //                       Icons.image_not_supported,
// //                       size: 80,
// //                       color: Colors.grey,
// //                     )
// //                   : null,
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     widget.item.name,
// //                     style: Theme.of(context).textTheme.headlineMedium,
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     widget.item.description ?? 'No description available',
// //                     style: TextStyle(
// //                       color: Colors.grey[600],
// //                       fontSize: 14,
// //                     ),
// //                     maxLines: 2,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   const SizedBox(height: 9),
// //                   Text(
// //                     '\$${widget.item.price}',
// //                     style: const TextStyle(
// //                       color: Colors.deepOrange,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 16,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Consumer<OrderController>(
// //               builder: (context, orderController, child) {
// //                 final isInCart = orderController.cartItems.containsKey(widget.item.id);
// //                 return IconButton(
// //                   icon: Icon(isInCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart),
// //                   color: Colors.deepOrange,
// //                   onPressed: () {
// //                     if (isInCart) {
// //                       orderController.removeItem(widget.item.id);
// //                     } else {
// //                       orderController.addToCard(id: widget.item.id, quantity: 1, item: widget.item.id);
// //                     }
// //                   },
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
