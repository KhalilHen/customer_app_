import 'package:hf_customer_app/main.dart';
import 'package:hf_customer_app/models/menu_item.dart';

class MenuItemController {





  Future<List<MenuItem>> fetchMenuItems(categoryId) async {

    try {

      final response = await  supabase.from('menu_item').select('*').eq('category_id', categoryId);

      if (response.isEmpty) {

        
        return [];
      }




            return response.map<MenuItem>((menuData) {
    return MenuItem.fromJson(menuData);
  }).toList();


    }
    catch(e) {
      return [];
    }
  }
}