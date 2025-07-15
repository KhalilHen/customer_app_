import 'package:flutter/material.dart';
import 'package:hf_customer_app/models/restaurant.dart';

class RestaurantView extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantView({super.key,  required this.restaurant});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  @override
  // final restaurants = restaurants;
  // final restaurant2 = this.restaurant
  @override
  Widget build(BuildContext context) {
    return    Scaffold(


      body: SingleChildScrollView(
        child: SafeArea(
          child:    Column(

      children: [

        ClipRect(


         child:  widget.restaurant.restaurantBanner == null || widget.restaurant.restaurantBanner!.isEmpty ? Container(
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
                      : 
                       Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            widget.restaurant.restaurantBanner!,
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
            // child:  Image.network(widget.restaurant.restaurantBanner),
          // child: Image.network(widget.restaurant.im
          // ),

        ),


// Text(),
      ],
    ),
        ),
      ),
    );
  }
}