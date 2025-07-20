

import 'package:hf_customer_app/main.dart';
import 'package:hf_customer_app/models/menu_category.dart';

class MenuCategoryController {




Future<List<MenuCategory>> fetchCategoryFromRestaurant(restaurantId) async {


  try {
    final response = await supabase.from('menu_item_category').select('*').eq('restaurant_id', restaurantId).order('display_order', ascending: true);



   
      if(response.isEmpty) {
        return  [];
      }


      return response.map<MenuCategory>((categoryData) {
    return MenuCategory.fromJson(categoryData);
  }).toList();
  }
  catch(e) {

    return [];
  }
}

  
}

