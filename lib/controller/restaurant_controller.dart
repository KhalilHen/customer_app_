import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:hf_customer_app/main.dart';
import 'package:hf_customer_app/models/restaurant.dart';
import 'package:hf_customer_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class RestaurantController {
  Stream<List<Restaurant>> fetchAllRestaurants() {
    //TODO Figure out if try catch is needed when you output it as a streambuilder
    final response = supabase
        .from('restaurant')
        .stream(primaryKey: ['id'])
        .order('name', ascending: true);
        // .order('');

    return response.map((data) {
      // print("test. $data");
      return data
          .map((row) => Restaurant.fromJson(row))
          .where((restaurant) => restaurant.isOpen && restaurant.isActive)
          .toList();
    });
  }

  Stream<List<Restaurant>> fetchClosedRestaurants() {
    final response = supabase
        .from('restaurant')
        .stream(primaryKey: ['id'])
        .order('name', ascending: true);

    return response.map((data) {
      return data
          .map((row) => Restaurant.fromJson(row))
          .where(
            (restaurant) => restaurant.isOpen == false && restaurant.isActive,
          )
          .toList();
    });
  }
  // Future<List<Restaurant>> fetchRestaurants() async {
  //   Future<Stream<List<Restaurant>>> fetchRestaurants() async {
  //     try {
  //       //* This query is when you use a future to fetch once
  //       // final response = await supabase
  //       //     .from('restaurant')
  //       //     .select('name, description, restaurant_preview_banner')
  //       //     .order('id', ascending: true);

  // // * This is for a stream where you listen to changes constant
  //     // supabase.from('restaurants').select('name, description, restaurant_preview_banner').stream();
  //     supabase.from('restaurants').stream(primaryKey: ['id'])

  //     // final response = supabase.from('restaurant').stre
  //       // if (response.isEmpty) {
  //       //   return [];
  //       // }

  // //  return (response as List)

  // //     .map((json) => Restaurant.fromJson(json))
  // //         .toList();

  //     } on PostgrestException {

  //       return  [];
  //     } catch (e) {
  //           print('Error fetching restaurants: $e');

  //       return [];
  //     }
  //   }

  // Future<Restaurant> fetchSpecificRestaurant() async {}

  //   Stream<List<Restaurant>> getNearbyRestaurants(
  //     Position userPosition,
  //   )  {
  //     double delta = 0.1;

  //     final response = supabase
  //         .from('restaurant')
  //         .stream(primaryKey: ['id']).map((data) {

  //           return data.where((Restaurant)

  //           {
  // double distance =  Geolocator.distanceBetween(userPosition.latitude,  userPosition.longitude, Restaurant['latitude'], Restaurant['longitude'],  );

  // return distance <= 1000;

  //           }).toList();

  //         });

  //   }
}
