import 'package:flutter/material.dart';
import 'package:hf_customer_app/models/restaurant.dart';

class RestaurantView extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantView({super.key,  
  required this.restaurant
  });

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  // final restaurants = restaurants;
  // final restaurant2 = this.restaurant
  @override
  Widget build(BuildContext context) {
    return         Scaffold(
     
   body:  CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            backgroundColor: Colors.deepOrange,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'restaurant-${widget.restaurant.id}',
                child: widget.restaurant.restaurantPreviewBanner == null || widget.restaurant.restaurantPreviewBanner!.isEmpty
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 100,
                            // color: Colors.white,
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
                  color: Colors.white, // Ensures contrast with the gradient.
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
                            // ' ${widget.restaurant.rating.toStringAsFixed(1)} ? ' ,


                          '3',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' ${widget.restaurant.reviewCount} reviews',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
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
                    child: Container(
                        child: Text(
                          widget.restaurant.description ??"Momenteel geen bescrijving beschikbaar",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    )),
                  ),

                  const SizedBox(height: 16),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // FutureBuilder<List<Category>>(
                        //   future: categoryController.fetchRestaurantCategory(restaurantId: widget.restaurant.id),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.connectionState == ConnectionState.waiting) {
                        //       return const Center(child: CircularProgressIndicator());
                        //     } else if (snapshot.hasError) {
                        //       print(snapshot.error);
                        //       return const Center(child: Text('Error loading categories'));
                        //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        //       return const Center(child: Text('No categories available'));
                        //     } else {
                        //       final categories = snapshot.data!;
                        //       return Row(
                        //         children: categories.map((category) {
                        //           return Container(
                        //             margin: const EdgeInsets.only(right: 8),
                        //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        //             decoration: BoxDecoration(
                        //               color: Colors.grey[200], // Updated color to match homepage.dart
                        //               borderRadius: BorderRadius.circular(20),
                        //             ),
                        //             child: Text(category.name),
                        //           );
                        //         }).toList(),
                        //       );
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Menu Sections
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: restaurant.menuSections!.map((section) {
                  //     return customWidgets.buildMenuSection(context, {
                  //       'id': section.id,
                  //       'title': section.name,
                  //     });
                  //   }).toList(),
                  // ),

                  // FutureBuilder<List<MenuSection>>(

                  //     // print('restaurant.id: ${restaurant.id}');
                  //     future: menuController.fetchMenuSections(restaurantId: widget.restaurant.id),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState == ConnectionState.waiting) {
                  //         return const Center(child: CircularProgressIndicator());
                  //       }
                  //       if (snapshot.hasError) {
                  //         print(snapshot.data);

                  //         print(snapshot.error);
                  //         return const Center(child: CircularProgressIndicator());
                  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  //         return const Center(child: Text('No menu sections is avaibel!'));
                  //       }

                  //       List<MenuSection>? sections = snapshot.data!;

                  //       if (sections.isEmpty) {
                  //         return const Center(child: Text('No menu sections is avaibel!'));
                  //       }
                  //       return Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: sections.map((section) {
                  //           // Debugging: Print each section's data
                  //           print('Section ID: ${section.id}, Section Name: ${section.name}');

                  //           // Handle sections with missing or empty names
                  //           final sectionName = section.name.isEmpty ? 'Unnamed Section' : section.name;

                  //           // Call buildMenuSection with the actual model
                  //           return customWidgets.buildMenuSection(context, {
                  //             'id': section.id,
                  //             'title': section.name,
                  //           });
                  //         }).toList(),
                  //       );
                  //     }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}