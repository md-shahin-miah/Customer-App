import 'dart:convert';

import 'package:blue/global/constant.dart';
import 'package:http/http.dart' as http;
import 'package:blue/podo/menu/menu_category.dart';

class MenuCategoryModel {
  static List<MenuCategory> categories = List();

  static Future<void> getCategories() async {
    categories.clear();
    try {
      var response = await http.get('${Api.businessBaseUrl}getCategory');

      final jsonResponse = jsonDecode(response.body);
      List<dynamic> categoryArray = jsonResponse;

      for (var category in categoryArray) {
        MenuCategory categoryPodo = MenuCategory();
        categoryPodo.id = int.parse(category['cat_id']);
        categoryPodo.categoryName = category['cat_name'];
        categoryPodo.description = category['cat_description'];
        categoryPodo.categoryPosition = int.parse(category['cat_position']);
        categoryPodo.categoryStatus = int.parse(category['customise_status']);
        categoryPodo.activeDays = category['cat_active_days'];



        categories.add(categoryPodo);


      }
    } catch (e, stack) {
      print(stack.toString());
    }
  }

  static updateCategory(MenuCategory category) async {
    var response =
        await http.post('${Api.businessBaseUrl}updateCategory', body: {
      'trigger_cat': "update",
      'cat_id': "${category.id}",
      'cat_name': category.categoryName,
      'cat_description': category.description,
      'cat_active_days': category.activeDays
    });

    print('-------------------------------------------');
    print(response.body);
    return response.body;
  }
}
