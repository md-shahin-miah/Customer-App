import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blue/global/constant.dart';
import 'package:blue/podo/customer.dart';
import 'package:blue/podo/food_item.dart';
import 'package:blue/podo/sub_item.dart';

class OrderDetailsModel {
  static List<FoodItem> foodItems;
  static Customer customer;
  static String checkString(dynamic value) {
    if (value is int) {
      return value.toString();
    } else {
      return value;
    }
  }


  static Future<bool> getOrderDetails(id) async {
    print('called getOrderDetails model ----------------');
    foodItems = [];
    foodItems.clear();
    customer = Customer();

    try {
      foodItems.clear();
      print(
          "print process-----------------------------------stp-getOrderDetails-----orderid-$id---getOrderDetails-----");
      var response =
      await http.get('${Api.businessBaseUrl}getOrderDetails/$id');
      print('getOrderDetails  response---------------${response.body}');
      print(
          'getOrderDetails  businessBaseUrl---------------${Api.businessBaseUrl}getOrderDetails/$id');
      final jsonResponse = jsonDecode(response.body);
      print('getOrderDetails  jsonResponse---------------$jsonResponse');

      Map<String, dynamic> info = jsonResponse;

      final orderInfo = info['order_info'];

      String customerName = orderInfo['order_customer'];
      String customerContact = orderInfo['order_person_contact'];
      String customerEmail = orderInfo['order_person_email'];
      String deliveryTime = orderInfo['order_delivery_time'];
      String deliveryAddress = orderInfo['order_full_address'];
      String postCode = orderInfo['post_code'];
      String orderSpecialNotes = orderInfo['order_special_notes'];
      String orderDate = orderInfo['order_date'];
      String paymentMethod = orderInfo['order_payment_method'];
      String paymentStatus = orderInfo['payment_status'];
      String deviceInfo = orderInfo['order_device'];

      int deliveryType = int.parse(orderInfo['order_delivery_type']);
      double deliveryCharge = double.parse(orderInfo['order_delivery_fee']);
      double serviceCharge = double.parse(orderInfo['admin_fee']);
      double bagCharge = double.parse(orderInfo['bag_charge']);
      double taxFee = double.parse(orderInfo['tax_fee']);
      double discount = double.parse(orderInfo['discount_total']);
      double total = double.parse(orderInfo['order_total']);
      double totalToPay = (total + deliveryCharge + serviceCharge+bagCharge+taxFee) - discount;

      customer.customerName = customerName;
      customer.customerContact = customerContact;
      customer.customerEmail = customerEmail;
      customer.deliveryTime = deliveryTime;
      customer.deliveryAddress = deliveryAddress;
      customer.postCode = postCode;
      customer.specialRequest = orderSpecialNotes;
      customer.deliveryCharge = deliveryCharge;
      customer.deliveryType = deliveryType;
      customer.serviceCharge = serviceCharge;
      customer.paymentMethod = paymentMethod;
      customer.paymentStatus = paymentStatus == null ? "N/A" : "Paid";
      customer.discount = discount;
      customer.taxFee = taxFee==null?0:taxFee;
      customer.bagCharge = bagCharge==null?0:bagCharge;
      customer.total = total;
      customer.orderDate = orderDate;
      customer.totalToPay = totalToPay.toStringAsFixed(2);
      customer.deviceInfo = deviceInfo;

      List items = info['items'];

      for (var item in items) {
        int itemId = int.parse(item['item_id']);
        String itemName = item['item_name'];

        print("price------------------${checkString(item['price'])}");
        double itemPrice = double.parse(checkString(item['price']));
        int itemQuantity = int.parse(item['item_quantity']);
        double itemTotal = double.parse(checkString(item['item_total']));
        String specialRequest = item['special_request'];

        List<SubItem> subItems;
        if (item['subitems'] == null) {
          subItems = null;
        } else {
          subItems = List();
          final subItemsJson = item['subitems'];

          for (var subItem in subItemsJson) {
            if (subItem.isEmpty) {
              continue;
            }
            String subItemName = subItem['sub_item_name'];
            String subItemVarName = subItem['sub_item_var'];
            subItems.add(SubItem(subItemName, subItemVarName));
          }
        }

        FoodItem foodItem = FoodItem(itemId,itemName, itemPrice, itemQuantity,
            itemTotal, specialRequest, subItems);

        bool isContain = false;

        for (FoodItem item in foodItems) {
          if (item != null && item.itemId == foodItem.itemId) {
            isContain = true;
            break;
          }
        }

        if (!isContain) {
          foodItems.add(foodItem);
        }
      }
    } catch (e, s) {
      print(e.toString());

      print(s.toString());
      return false;
    }

    return true;
  }

  static reprintOrder(String id) async {
    var response = await http
        .post('${Api.businessBaseUrl}reprintRequest', body: {'order_id': id});

    print(response);

    return response.body;
  }
}
