
import 'package:hf_customer_app/main.dart';
import 'package:hf_customer_app/models/restaurant.dart';

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
          .where((restaurant) => restaurant.isOpen  && restaurant.isActive)
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
 

}
