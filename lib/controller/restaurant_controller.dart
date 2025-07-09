import 'dart:convert';

import 'package:hf_customer_app/main.dart';
import 'package:hf_customer_app/models/restaurant.dart';
import 'package:hf_customer_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RestaurantController {
  // Future<List<Restaurant>> fetchRestaurants() async {
  Future<Stream<List<Restaurant>>> fetchRestaurants() async {
    try {
      //* This query is when you use a future to fetch once
      // final response = await supabase
      //     .from('restaurant')
      //     .select('name, description, restaurant_preview_banner')
      //     .order('id', ascending: true);


// * This is for a stream where you listen to changes constant
    // supabase.from('restaurants').select('name, description, restaurant_preview_banner').stream();
    supabase.from('restaurants').stream(primaryKey: ['id'])


    // final response = supabase.from('restaurant').stre
      // if (response.isEmpty) {
      //   return [];
      // }


//  return (response as List)

//     .map((json) => Restaurant.fromJson(json))
//         .toList();


    } on PostgrestException {



      return  [];
    } catch (e) {
          print('Error fetching restaurants: $e');

      return [];
    }
  }

  // Future<Restaurant> fetchSpecificRestaurant() async {}
}
