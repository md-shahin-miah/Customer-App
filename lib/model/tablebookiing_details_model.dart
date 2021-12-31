import 'dart:convert';
import 'package:blue/podo/table_booking_pojo.dart';
import 'package:http/http.dart' as http;
import 'package:blue/global/constant.dart';


class TableBookingDetailsModel {
  static TableBookingOrder customer;

  static Future<bool> getTableBookingDetails(String id) async {
    customer = TableBookingOrder();
    print('getTableBookingDetails called-----------$id');
    try {
      var response = await http.post(
          '${Api.businessBaseUrl}getTableBookingDetails',
          body: {"id": id});

      final jsonResponse = jsonDecode(response.body);
      print('getTableBookingDetails  jsonResponse---------------$jsonResponse');

      List<dynamic> infos = jsonResponse;

      // CustomerTB customerTb =CustomerTB(info['booking_table_id'], info['bookingDate'], info['bookingTime'], info['full_name'], info['telephone'], info['email'], info['guests'], info['status']);
      print('info--------------------- cvk;ljzchvvbnh -------------$infos');

      for (var info in infos) {
        print("getTableBookingDetails--- info------info--------------------------${info.toString()}");
        customer.orderId =info['booking_table_id'];
        customer.orderDate = info['bookingDate'];
        customer.orderTime = info['bookingTime'];
        customer.customerName= info['full_name'];
        customer.customerContact =  info['telephone'];
        customer.customerEmail = info['email'];
        customer.numberOfGuest = info['guests'];
        customer.status = info['status'];
        customer.specialReq = info['request'];
        customer.tableBookingPlacementTime = info['inserted'];
        print(
            'customer.orderId------------------------------------------------ ${customer.orderId}');
        print(
            'customer.orderDate------------------------------------------------ ${customer.orderDate}');
        print(
            'customer.orderTime------------------------------------------------ ${customer.orderTime}');
        print(
            'customer.customerName------------------------------------------------ ${customer.customerName}');
        print(
            'customer.customerContact------------------------------------------------ ${customer.customerContact}');
        print(
            'customer.customerEmail------------------------------------------------ ${customer.customerEmail}');
        print(
            'customer.numberOfGuest------------------------------------------------ ${customer.numberOfGuest}');
        print(
            'customer.status------------------------------------------------ ${customer.status}');

      }

      // print('booking_table_id----$tbId-----$bookingDate----$fullName-$email--$status--');
      //
      //


      if(customer.status!=null){
        return true;
      }
    } catch (e, s) {
      print(e.toString());
      print(s.toString());

    return false;
    }
  }
}
