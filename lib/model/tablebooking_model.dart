import 'dart:convert';

import 'package:blue/global/constant.dart';
import 'package:blue/podo/table_booking.dart';
import 'package:http/http.dart' as http;

class TableBookingModel{
  static List<TableBooking> pendingOrders = List();
  static List<TableBooking> acceptedOrders = List();
  static List<TableBooking> cancelledOrders = List();
  static List<TableBooking> notpaidOrders = List();

  static Future<void> getAllTableBooking(int type) async {
    try {
      pendingOrders.clear();
      acceptedOrders.clear();
      cancelledOrders.clear();
      notpaidOrders.clear();
      var response = await http.get('${Api.businessBaseUrl}getTableBookingData/$type');
      print('response getAllTable_booking re--------------------------${response.body}');
      final jsonResponse = jsonDecode(response.body);
      print('response getAllTable_booking--------------------------${response.body}');
      print('response getAllTable_booking api --------------------------${Api.businessBaseUrl}getTableBookingData/$type');
      Map<String, dynamic> info = jsonResponse;

      final pendingTableBookingList = info['pending_table_booking'];
      final acceptedTableBookingList = info['accepted_table_booking'];
      final cancelledTableBookingList = info['cancelled_table_booking'];

      if (pendingTableBookingList != null) {
        for (int i = 0; i < pendingTableBookingList.length; i++) {
          final orderObject = pendingTableBookingList[i];

          pendingOrders.add(TableBooking(
           int.parse(orderObject['booking_table_id']),
            orderObject['bookingDate'],
            orderObject['bookingTime'],
            orderObject['full_name'],
            orderObject['telephone'],
            orderObject['email'],
            int.parse(orderObject['guests']),
            orderObject['status'],
            orderObject['request'],
          ));
        }
      }

      if (acceptedTableBookingList != null) {
        for (int i = 0; i < acceptedTableBookingList.length; i++) {
          final orderObject = acceptedTableBookingList[i];

          acceptedOrders.add(TableBooking(
           int.parse(orderObject['booking_table_id']),
            orderObject['bookingDate'],
            orderObject['bookingTime'],
            orderObject['full_name'],
            orderObject['telephone'],
            orderObject['email'],
            int.parse(orderObject['guests']),
            orderObject['status'],
            orderObject['request'],
          ));
        }
      }

      if (cancelledTableBookingList != null) {
        for (int i = 0; i < cancelledTableBookingList.length; i++) {
          final orderObject = cancelledTableBookingList[i];

          cancelledOrders.add(TableBooking(
           int.parse(orderObject['booking_table_id']),
            orderObject['bookingDate'],
            orderObject['bookingTime'],
            orderObject['full_name'],
            orderObject['telephone'],
            orderObject['email'],
            int.parse(orderObject['guests']),
            orderObject['status'],
            orderObject['request'],
          ));
        }
      }


    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> getAllTableBookingByRange(String startDate,String endDate) async {
    try {
      pendingOrders.clear();
      acceptedOrders.clear();
      cancelledOrders.clear();
      notpaidOrders.clear();
      print('---start date and endDate---------------------------$startDate-------------$endDate' );
      var response = await http.post('${Api.businessBaseUrl}getRangeTableBooking',body: {
        'start_date':startDate,
        'end_date':endDate
      });


      final jsonResponse = jsonDecode(response.body);
      print('response getAlltable_bookingByRange--------------------------${response.body}');
      Map<String, dynamic> info = jsonResponse;

      final pendingTableBookingList = info['pending_table_booking'];
      final acceptedTableBookingList = info['accepted_table_booking'];
      final cancelledOrdersList = info['cancelled_table_booking'];

      if (pendingTableBookingList != null) {
        for (int i = 0; i < pendingTableBookingList.length; i++) {
          final orderObject = pendingTableBookingList[i];

          pendingOrders.add(TableBooking(
           int.parse(orderObject['booking_table_id']),
            orderObject['bookingDate'],
            orderObject['bookingTime'],
            orderObject['full_name'],
            orderObject['telephone'],
            orderObject['email'],
            int.parse(orderObject['guests']),
            orderObject['status'],
            orderObject['request'],
          ));
        }
      }

      if (acceptedTableBookingList != null) {
        for (int i = 0; i < acceptedTableBookingList.length; i++) {
          final orderObject = acceptedTableBookingList[i];

          acceptedOrders.add(TableBooking(
            int.parse(orderObject['booking_table_id']),
            orderObject['bookingDate'],
            orderObject['bookingTime'],
            orderObject['full_name'],
            orderObject['telephone'],
            orderObject['email'],
            int.parse(orderObject['guests']),
            orderObject['status'],
            orderObject['request'],
          ));
        }
      }

      if (cancelledOrdersList != null) {
        for (int i = 0; i < cancelledOrdersList.length; i++) {
          final orderObject = cancelledOrdersList[i];

          cancelledOrders.add(TableBooking(
           int.parse(orderObject['booking_table_id']),
            orderObject['bookingDate'],
            orderObject['bookingTime'],
            orderObject['full_name'],
            orderObject['telephone'],
            orderObject['email'],
            int.parse(orderObject['guests']),
            orderObject['status'],
            orderObject['request'],
          ));
              }
      }

    } catch (e) {
      print(e.toString());
    }
  }


  static Future tableBookingChangeStatus(String id, String status) async {
    print(
        '------------------businessBaseUrl -----------------${Api.businessBaseUrl}updateTableBookingStatus');
    var response = await http.post('${Api.businessBaseUrl}updateTableBookingStatus',
        body: {'id': id, 'status': status});
    print('-------------------------------tableBookingChangeStatus------${response.body}');
    return response.body;
  }

}