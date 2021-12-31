import 'dart:convert';

import 'package:blue/global/constant.dart';
import 'package:http/http.dart' as http;
import 'package:blue/podo/menu/menu_food_item.dart';
import 'package:blue/podo/menu/menu_food_variance.dart';
import 'package:blue/podo/menu/menu_subitem.dart';
import 'package:blue/podo/menu/menu_subitem_variance.dart';

class FoodModel {
  static List<MenuFoodItem> foodItems = [];
  static List<MenuFoodVariance> foodItemVariances =[];
  static List<MenuSubItem> subitems =[];
  static List<MenuSubItemVariance> subitemVariances =[];

  static Future<void> getFoodItems(String catId) async {
    try {
      foodItems.clear();
      print(catId);
      var response = await http
          .post('${Api.businessBaseUrl}getFoodItem', body: {'cat_id': catId});

      List<dynamic> resultArray = jsonDecode(response.body);

      print("getFoodItem response body---------------${response.body}");

      for (var data in resultArray) {
        bool hasVariance = data['has_variance'];
        final item = data['details'];

        MenuFoodItem foodItem = MenuFoodItem();

        foodItem.itemId = int.parse(item['item_id']);
        foodItem.itemCategoryId = int.parse(item['item_category']);
        foodItem.itemName = item['item_name'];
        foodItem.itemPrice = double.parse(item['item_price']);
        foodItem.eatinItemPrice = double.parse(item['eatin_item_price']);
        foodItem.eatinAvailable = int.parse(item['eatin_available']);
        foodItem.itemDescription = item['item_description'];
        foodItem.itemPerson = int.parse(item['item_person']);
        foodItem.itemDelCol = int.parse(item['item_del_col']);
        foodItem.itemPosition = int.parse(item['item_position']);
        foodItem.getSubItem = int.parse(item['get_sub_item']);
        foodItem.status = int.parse(item['status']);
        foodItem.visibility = int.parse(item['visibility']);
        foodItem.offerInclude = int.parse(item['offer_include']);
        foodItem.spicyLevel = int.parse(item['spicy_level']);
        foodItem.allergyLevel =
            item['allergy_level'] == null ? "" : item['allergy_level'];
        foodItem.specialRequeststatus = int.parse(item['specialrequeststatus']);

        foodItem.hasVariance = hasVariance;
        foodItems.add(foodItem);
      }
    } catch (e, stack) {
      print(e.toString());
      print(stack.toString());
    }
  }

  static Future<void> getFoodItemVariance(String catId, String itemId) async {
    try {
      foodItemVariances.clear();

      var response = await http.post(
          '${Api.businessBaseUrl}getFoodItemVariance',
          body: {'cat_id': catId, 'item_id': itemId});

      List<dynamic> variances = jsonDecode(response.body);

      for (var data in variances) {
        MenuFoodVariance foodVariance = MenuFoodVariance();

        foodVariance.varianceId = int.parse(data['variance_id']);
        foodVariance.varianceCatId = int.parse(data['variance_cat_id']);
        foodVariance.varianceItemId = int.parse(data['variance_item_id']);
        foodVariance.varianceName = data['variance_name'];
        foodVariance.variancePrice = double.parse(data['variance_price']);
        foodVariance.eatinVariancePrice =
            double.parse(data['eatin_variance_price']);
        foodVariance.varianceStatus = int.parse(data['variance_status']);
        foodVariance.variancePosition = int.parse(data['variance_position']);
        foodVariance.vsibility = int.parse(data['visibility']);

        foodItemVariances.add(foodVariance);
      }
    } catch (e, stack) {
      print(e.toString());
      print(stack.toString());
    }
  }

  static Future<void> getSubItem(String itemId) async {
    try {
      subitems.clear();

      var response = await http
          .post('${Api.businessBaseUrl}getSubItem', body: {'item_id': itemId});

      List<dynamic> variances = jsonDecode(response.body);

      for (var data in variances) {
        MenuSubItem subItem = MenuSubItem();

        subItem.itemId = int.parse(data['item_id']);
        subItem.subItemId = int.parse(data['sub_item_id']);
        subItem.subItemName = data['sub_item_name'];
        subItem.optionMax = int.parse(data['option_max']);
        subItem.optionMin = int.parse(data['option_min']);
        subItem.status = int.parse(data['status']);
        subItem.visibility = int.parse(data['visibility']);
        subItem.subItemPosition = int.parse(data['sub_item_position']);
        subitems.add(subItem);
      }
    } catch (e, stack) {
      print(e.toString());
      print(stack.toString());
    }
  }

  static Future<void> getSubItemVariance(String subItemId) async {
    try {
      subitemVariances.clear();

      var response = await http.post('${Api.businessBaseUrl}getSubItemVariance',
          body: {'sub_item_id': subItemId});

      List<dynamic> variances = jsonDecode(response.body);

      for (var data in variances) {
        MenuSubItemVariance subItemVariance = MenuSubItemVariance();
        subItemVariance.subItemId = int.parse(data['sub_item_id']);
        subItemVariance.subItemVarianceId =
            int.parse(data['sub_item_variance_id']);
        subItemVariance.subItemVariancePrice =
            double.parse(data['sub_item_variance_price']);
        subItemVariance.eatinSubItemVariancePrice =
            double.parse(data['eatin_sub_item_variance_price']);
        subItemVariance.subItemVarianceName = data['sub_item_variance_name'];
        subItemVariance.visibility = int.parse(data['visibility']);
        subItemVariance.status = int.parse(data['status']);
        subItemVariance.subItemVariancePosition =
            int.parse(data['sub_item_variance_position']);

        subitemVariances.add(subItemVariance);
      }
    } catch (e, stack) {
      print(e.toString());
      print(stack.toString());
    }
  }

  static updateFoodItem(MenuFoodItem foodItem) async {
    var response =
        await http.post('${Api.businessBaseUrl}updateFoodItem', body: {
      'trigger_food': "update",
      'item_id': "${foodItem.itemId}",
      'item_category': "${foodItem.itemCategoryId}",
      'item_name': foodItem.itemName,
      'include_eatin': "${foodItem.eatinAvailable}",
      'item_price': "${foodItem.itemPrice}",
      'eatin_item_price': "${foodItem.eatinItemPrice}",
      'item_description': "${foodItem.itemDescription}",
      'item_person': "${foodItem.itemPerson}",
      'get_sub_item': "${foodItem.getSubItem}",
      'item_del_col': "${foodItem.itemDelCol}",
      'visibility': "${foodItem.visibility}",
      'offer_include': "${foodItem.offerInclude}",
      'spicy_level': "${foodItem.spicyLevel}",
      'allergy_level': "${foodItem.allergyLevel}"
    });
print('foodItem.visibility-${foodItem.visibility}');
print('foodItem.eatinAvailable-${foodItem.eatinAvailable}');
    print('-------------------------------------------');
    print(response.body);
    return response.body;
  }

  static updateSubItemVariance(MenuSubItemVariance variance) async {
    var response =
        await http.post('${Api.businessBaseUrl}updateSubItemVariance', body: {
      'trigger_sub_item_variance': "update",
      'sub_item_variance_name': "${variance.subItemVarianceName}",
      'sub_item_variance_price': "${variance.subItemVariancePrice}",
      'eatin_sub_item_variance_price': variance.eatinSubItemVariancePrice <= 0
          ? '-10'
          : "${variance.eatinSubItemVariancePrice}",
      'visibility': "${variance.visibility}",
      'sub_item_id': "${variance.subItemId}",
      'sub_item_variance_id': "${variance.subItemVarianceId}"
    });

    print('-------------------------------------------');
    print(response.body);
    return response.body;
  }

  static updateFoodVariance(MenuFoodVariance variance) async {
    var response =
        await http.post('${Api.businessBaseUrl}updateFoodVariance', body: {
      'trigger_food_variance': "update",
      'variance_cat_id': "${variance.varianceCatId}",
      'variance_item_id': "${variance.varianceItemId}",
      'variance_id': "${variance.varianceId}",
      'variance_name': "${variance.varianceName}",
      'variance_price': "${variance.variancePrice}",
      'eatin_variance_price': "${variance.eatinVariancePrice}",
      'visibility': "${variance.vsibility}"
    });

    print('-------------------------------------------');
    print(response.body);
    return response.body;
  }

  static updateSubItem(MenuSubItem subItem) async {
    var response =
        await http.post('${Api.businessBaseUrl}updateSubItem', body: {
      'trigger': "update_sub_item",
      'sub_item_name': "${subItem.subItemName}",
      'item_id': "${subItem.itemId}",
      'visibility': "${subItem.visibility}",
      'sub_item_required': "${subItem.subItemRequired}",
      'option_min': "${subItem.optionMin}",
      'option_max': "${subItem.optionMax}",
      'sub_item_id': "${subItem.subItemId}"
    });

    print('-------------------------------------------');
    print(response.body);
    return response.body;
  }
}
