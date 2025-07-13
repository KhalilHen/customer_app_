import 'package:flutter/material.dart';
import 'package:hf_customer_app/controller/restaurant_controller.dart';
import 'package:hf_customer_app/models/restaurant.dart';

class RestaurantOverviewPage extends StatefulWidget {
  const RestaurantOverviewPage({super.key});

  @override
  State<RestaurantOverviewPage> createState() => _RestaurantOverviewPageState();
}

class _RestaurantOverviewPageState extends State<RestaurantOverviewPage> {
  final restaurantController = RestaurantController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: restaurantController.fetchAllRestaurants(),
        builder: (context, snapshot) {

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();

            case ConnectionState.none:
              return const LinearProgressIndicator();

            case ConnectionState.active:
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final List<Restaurant> restaurants = snapshot.data!;

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];

                    return GestureDetector(

                         onTap: () {
                                         //TODO Add here route
                                        },
                      child: Hero(
                        tag: "Restaurant-${restaurant.id}",
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(restaurant.name),
                        
                              const SizedBox(height: 20),
                        
                              Text(restaurant.description ?? "geen tekst"),
                              Text(restaurant.phoneNumber),
                        
                              const SizedBox(height: 30),
                        
                              restaurant.restaurantPreviewBanner != null
                                  ? Image.network(
                                      restaurant.restaurantPreviewBanner!,
                        
                                      height: 150,
                                      width: 300,
                                    )
                                  : const Icon(Icons.hide_image),
                        
                            ],
                          ),
                        ),
                      ),
                    );

                    // return RestaurantCard();
                  },
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "Sorry der zijn momenteel geen restaurants bij u in de buurt",
                  ),
                );
              } else {
                return const Center(
                  child: Text("Sorry der is niks beschikbaar momenteel"),
                );
              }
            case ConnectionState.done:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(
                    24.0,
                  ), // Add some breathing room
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // So it doesn't stretch the whole height
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.redAccent,
                      ),
                      const Text(
                        "Er ging iets mis. Probeer de pagina opnieuw te laden door op de knop hieronder te drukken.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 16,
                      ), // Space between text and button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text("Opnieuw laden"),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 200,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            restaurantController.fetchAllRestaurants();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
          ),
          child: const Text(
            "Test button",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18, // Bigger text
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Widget RestaurantCard() {}
}
