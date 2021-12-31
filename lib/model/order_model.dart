import 'dart:convert';
import 'package:blue/podo/order.dart';
import 'package:http/http.dart' as http;
import 'package:blue/global/constant.dart';

class OrderModel {
  static List<Order> pendingOrders = List();
  static List<Order> acceptedOrders = List();
  static List<Order> cancelledOrders = List();
  static List<Order> notpaidOrders = List();
  static double acceptedOrderAmount = 0;
  static String verticalGroupValue = "Today";
  
  static Future<void> getAllOrders(int type) async {
    print('type getAllOrders------$type');
    try {
      acceptedOrderAmount = 0;
      pendingOrders.clear();
      acceptedOrders.clear();
      cancelledOrders.clear();
      notpaidOrders.clear();
      var response = await http.get('${Api.businessBaseUrl}getOrders/$type');

      final jsonResponse = jsonDecode(response.body);
      print('response getAllOrders--------------------------${response.body}');
      print('api new----------------------------------${Api.businessBaseUrl}getOrders/$type');
      Map<String, dynamic> info = jsonResponse;

      final pendingOrdersList = info['pending_orders'];
      final acceptedOrdersList = info['accepted_orders'];
      final cancelledOrdersList = info['cancelled_orders'];
      final notPaidOrdersList = info['notpaid_orders'];

      if (pendingOrdersList != null) {
        for (int i = 0; i < pendingOrdersList.length; i++) {
          final orderObject = pendingOrdersList[i];
          // int id = int.parse(orderObject['order_id']);
          // Static.NewId=id.toString();
          // Static.NewIdlIST.add(id.toString());
          pendingOrders.add(Order(
              int.parse(orderObject['order_id']),
              orderObject['order_date'],
              orderObject['order_customer'],
              orderObject['order_person_contact'],
              orderObject['order_person_email'],
              int.parse(orderObject['order_delivery_type']),
              orderObject['order_delivery_time'],
              double.parse(orderObject['order_total'])));
        }
      }

      if (acceptedOrdersList != null) {
        for (int i = 0; i < acceptedOrdersList.length; i++) {

          final orderObject = acceptedOrdersList[i];
          acceptedOrderAmount+=double.parse(orderObject['order_total']);


          acceptedOrders.add(Order(
              int.parse(orderObject['order_id']),
              orderObject['order_date'],
              orderObject['order_customer'],
              orderObject['order_person_contact'],
              orderObject['order_person_email'],
              int.parse(orderObject['order_delivery_type']),
              orderObject['order_delivery_time'],
              double.parse(orderObject['order_total'])));

        }
      }

      if (cancelledOrdersList != null) {
        for (int i = 0; i < cancelledOrdersList.length; i++) {
          final orderObject = cancelledOrdersList[i];

          cancelledOrders.add(Order(
              int.parse(orderObject['order_id']),
              orderObject['order_date'],
              orderObject['order_customer'],
              orderObject['order_person_contact'],
              orderObject['order_person_email'],
              int.parse(orderObject['order_delivery_type']),
              orderObject['order_delivery_time'],
              double.parse(orderObject['order_total'])));
        }
      }

      if (notPaidOrdersList != null) {
        for (int i = 0; i < notPaidOrdersList.length; i++) {
          final orderObject = notPaidOrdersList[i];

          notpaidOrders.add(Order(
              int.parse(orderObject['order_id']),
              orderObject['order_date'],
              orderObject['order_customer'],
              orderObject['order_person_contact'],
              orderObject['order_person_email'],
              int.parse(orderObject['order_delivery_type']),
              orderObject['order_delivery_time'],
              double.parse(orderObject['order_total'])));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> getAllOrdersByRange(String startDate,String endDate) async {
    try {
      pendingOrders.clear();
      acceptedOrders.clear();
      cancelledOrders.clear();
      notpaidOrders.clear();
      print('---start date and endDate---------------------------$startDate-------------$endDate' );
      var response = await http.post('${Api.businessBaseUrl}getRangeOrders',body: {
      'start_date':startDate,
        'end_date':endDate
      });


      final jsonResponse = jsonDecode(response.body);
      print('response getAllOrdersByRange--------------------------${response.body}');
      Map<String, dynamic> info = jsonResponse;

      final pendingOrdersList = info['pending_orders'];
      final acceptedOrdersList = info['accepted_orders'];
      final cancelledOrdersList = info['cancelled_orders'];
      final notpaidOrdersList = info['awaiting_orders'];

      if (pendingOrdersList != null) {
        for (int i = 0; i < pendingOrdersList.length; i++) {
          final orderObject = pendingOrdersList[i];

          pendingOrders.add(Order(
              int.parse(orderObject['order_id']),
              orderObject['order_date'],
              orderObject['order_customer'],
              orderObject['order_person_contact'],
              orderObject['order_person_email'],
              int.parse(orderObject['order_delivery_type']),
              orderObject['order_delivery_time'],
              double.parse(orderObject['order_total'])));
        }
      }

      if (acceptedOrdersList != null) {
        for (int i = 0; i < acceptedOrdersList.length; i++) {
          final orderObject = acceptedOrdersList[i];

          acceptedOrders.add(Order(
              int.parse(orderObject['order_id']),
              orderObject['order_date'],
              orderObject['order_customer'],
              orderObject['order_person_contact'],
              orderObject['order_person_email'],
              int.parse(orderObject['order_delivery_type']),
              orderObject['order_delivery_time'],
              double.parse(orderObject['order_total'])));
        }
      }

      if (cancelledOrdersList != null) {
        for (int i = 0; i < cancelledOrdersList.length; i++) {
          final orderObject = cancelledOrdersList[i];

          cancelledOrders.add(Order(
              int.parse(orderObject['order_id']),
              orderObject['order_date'],
              orderObject['order_customer'],
              orderObject['order_person_contact'],
              orderObject['order_person_email'],
              int.parse(orderObject['order_delivery_type']),
              orderObject['order_delivery_time'],
              double.parse(orderObject['order_total'])));
        }
      }

      if (notpaidOrdersList != null) {
        for (int i = 0; i < notpaidOrdersList.length; i++) {
          final orderObject = notpaidOrdersList[i];

          notpaidOrders.add(Order(
              int.parse(orderObject['order_id']),
              orderObject['order_date'],
              orderObject['order_customer'],
              orderObject['order_person_contact'],
              orderObject['order_person_email'],
              int.parse(orderObject['order_delivery_type']),
              orderObject['order_delivery_time'],
              double.parse(orderObject['order_total'])));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Future getReprintQueue() async {
    /// var response = await http.get('${Api.BUSINESS_BASE_URL}getReprintQueue');

    var response = await http.get('${Api.businessBaseUrl}getReprintQueue');

    var result = jsonDecode(response.body);

    return result;
  }

  static clearReprint(String id) async {
    var response = await http
        .post('${Api.businessBaseUrl}clearReprint', body: {'order_id': id});

    print(response);

    return response.body;
  }

  static Future<String> changeStatus(String id, String status) async {
    /// var response = await http.get('${Api.BUSINESS_BASE_URL}getReprintQueue');

    print(
        '------------------businessBaseUrl  id-$id  change status-$status -----------------${Api.businessBaseUrl}changeStatus');
    var response = await http.post('${Api.businessBaseUrl}changeStatus',
        body: {'order_id': id, 'status': status});
    print('-------------------------------changeStatus   Api.businessBaseUrl}changeStatus----${response.body}');
    Static.NewId = "1";
    return response.body;
  }

  static Future<String> deleteOrder(String id) async {

    print(
        '---------deleteOrder---------businessBaseUrl  id-$id  -----------------${Api.businessBaseUrl}removeOrder');
    var response = await http.post('${Api.businessBaseUrl}removeOrder',
        body: {'order_id': id});
    print('-------------------------------removeOrder response----${response.body}');
    return response.body;
  }

  static Future addTimeDelay(String id, String time) async {
    print(
        '------------------businessBaseUrl  id-$id  time-$time -----------------${Api.businessBaseUrl}updateDeliveryTime');
    var response = await http.post('${Api.businessBaseUrl}updateDeliveryTime',
        body: {'order_id': id, 'time': time});
    print('-------------------------------time   Api.businessBaseUrl}updateDeliveryTime----${response.body}');
    return response.body;
  }


  static Future lastHit() async {
    /// var response = await http.get('${Api.BUSINESS_BASE_URL}getReprintQueue');

    print(
        '------------------businessBaseUrl -----------------${Api.LAST_HIT_URL}SupAdmin/bulid_summerys/3');
    var response = await http.get('${Api.LAST_HIT_URL}SupAdmin/bulid_summerys/3');
    print('-------------------------------last hit----${response.body}');
    return response.body;
  }


}
