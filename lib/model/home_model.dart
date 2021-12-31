import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:blue/global/constant.dart';
import 'package:blue/podo/order_graph.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomeModel {
  static bool isSettingLoaded = false;
  static bool isTableBookingOn = false;
  static bool isOnlineOrderOn = false;
  static bool isDeliveryOn = false;
  static bool isCollectionOn = false;
  static bool isEatOn = false;
  static bool isPrinterConnected = false;
  static double weekDelivery = 0;
  static double weekCollection = 0;
  static double todayDelivery = 0;
  static double todayCollection = 0;

  dynamic oneMonthIncome = '0';
  dynamic oneWeekIncome = '0';
  dynamic todayIncome = '0';

  dynamic pendingOrder = '0';
  dynamic acceptedOrder = '0';
  dynamic cancelledOrder = '0';
  dynamic notPaidOrder = '0';

  dynamic pendingOrderAmount = '0';
  dynamic acceptedOrderAmount = '0';
  dynamic cancelledOrderAmount = '0';
  dynamic notPaidOrderAmount = '0';

  static String businessName = "";
  static String businessContact = "";
  static String businessAddress = "";
  static String businessPostCode = "";

  List<OrderGraph> cashOrderData = [];
  List<OrderGraph> onlineOrderData = [];
  List<charts.Series<OrderGraph, String>> barChartGraphData =[];

  List<OrderGraph> collectionOrderData = [];
  List<OrderGraph> deliveryOrderData = [];
  List<charts.Series<OrderGraph, String>> lineChartGraphData = [];

  Map<String, double> todayDelCol = ({"Delivery": 0.0, "Collection": 0.0});
  Map<String, double> weekDelCol = ({"Delivery": 0.0, "Collection": 0.0});

  setStatus(key, val) async {
    var response = await http.post('${Api.businessBaseUrl}change_status',
        body: {'status_key': key, 'status_val': val});
    return response.body;
  }

  Future<String> getRestaurantSettings() async {


    cashOrderData.clear();
    onlineOrderData.clear();
    barChartGraphData.clear();
    collectionOrderData.clear();
    deliveryOrderData.clear();
    lineChartGraphData.clear();


    print('getRestaurantSettings()');
    try {
      var response = await http.get('${Api.businessBaseUrl}getBusinessInfo');

      print('api urls ${Api.businessBaseUrl}');
      print('api response $response');


      print('response : ${response.body}');

      final jsonResponse = jsonDecode(response.body);

      Map<String, dynamic> info = jsonResponse;

      businessName = info['restaurant_name'];
      businessAddress = info['restaurant_address'];
      businessPostCode = info['restaurant_postcode'];
      businessContact = info['restaurant_contact'];

      final restaurantDetails = jsonDecode(info['restaurant_all_details']);

      //restaurant setting card information
      if (restaurantDetails['table_booking_on_off'] == 'On') {
        isTableBookingOn = true;
      } else {
        isTableBookingOn = false;
      }

      if (restaurantDetails['maintenance_mode'] == 'yes') {
        isOnlineOrderOn = true;
      } else {
        isOnlineOrderOn = false;
      }

      if (restaurantDetails['delivery_collection_method'] == '1') {
        isDeliveryOn = true;
        isCollectionOn = false;
      } else if (restaurantDetails['delivery_collection_method'] == '2') {
        isDeliveryOn = false;
        isCollectionOn = true;
      } else {
        isDeliveryOn = true;
        isCollectionOn = true;
      }

      //income amounts
      oneMonthIncome = restaurantDetails['one_month_income'] == null
          ? '0'
          : double.parse('${restaurantDetails['one_month_income']}')
              .toStringAsFixed(2);
      oneWeekIncome = restaurantDetails['one_week_income'] == null
          ? '0'
          : double.parse('${restaurantDetails['one_week_income']}')
              .toStringAsFixed(2);
      todayIncome = restaurantDetails['today_income'] == null
          ? '0'
          : double.parse('${restaurantDetails['today_income']}')
              .toStringAsFixed(2);

      //order summary
      pendingOrder = restaurantDetails['num_pending_order_today'] == null
          ? '0'
          : restaurantDetails['num_pending_order_today'];

      acceptedOrder = restaurantDetails['num_accepted_order_today'] == null
          ? '0'
          : restaurantDetails['num_accepted_order_today'];
      cancelledOrder = restaurantDetails['num_cancelled_order_today'] == null
          ? '0'
          : restaurantDetails['num_cancelled_order_today'];
      notPaidOrder = restaurantDetails['num_awaiting_order_today'] == null
          ? '0'
          : restaurantDetails['num_awaiting_order_today'];

      //order amount
      pendingOrderAmount = restaurantDetails['num_pending_amount_today'] == null
          ? '0'
          : double.parse(restaurantDetails['num_pending_amount_today'])
              .toStringAsFixed(2);

      acceptedOrderAmount =
          restaurantDetails['num_accepted_amount_today'] == null
              ? '0'
              : double.parse(restaurantDetails['num_accepted_amount_today'])
                  .toStringAsFixed(2);
      cancelledOrderAmount =
          restaurantDetails['num_cancelled_amount_today'] == null
              ? '0'
              : double.parse(restaurantDetails['num_cancelled_amount_today'])
                  .toStringAsFixed(2);
      notPaidOrderAmount =
          restaurantDetails['num_awaiting_amount_today'] == null
              ? '0'
              : double.parse(restaurantDetails['num_awaiting_amount_today'])
                  .toStringAsFixed(2);

      //todayDelivery-Collecton Data

      todayDelivery = restaurantDetails['num_delivery_order_today'].toDouble();
      todayCollection =
          restaurantDetails['num_collection_order_today'].toDouble();

      final lastWeekOrders =
          json.decode(restaurantDetails['last7DaysOrdersAllDetails']);

      //one week cash online with total
      for (int i = 1; i <= 7; i++) {
        var dayObject = lastWeekOrders['day$i'];
        cashOrderData.add(OrderGraph(dayObject['day'], dayObject['cash']));
        onlineOrderData.add(OrderGraph(dayObject['day'], dayObject['online']));
      }

      /// Creating barchart online cash
      barChartGraphData.add(new charts.Series<OrderGraph, String>(
          id: 'Cash',
          domainFn: (OrderGraph orders, _) => orders.day,
          measureFn: (OrderGraph orders, _) => orders.number,
          data: cashOrderData,
          seriesColor: charts.ColorUtil.fromDartColor(Color(0xfffa8128))));

      barChartGraphData.add(new charts.Series<OrderGraph, String>(
          id: 'Online',
          domainFn: (OrderGraph orders, _) => orders.day,
          measureFn: (OrderGraph orders, _) => orders.number,
          data: onlineOrderData,
          seriesColor: charts.ColorUtil.fromDartColor(Color(0xff2e5468))));

      //one week delivery collection
      for (int i = 1; i <= 7; i++) {
        var dayObject = lastWeekOrders['day$i'];
        weekDelivery += dayObject['delivery'].toDouble();
        weekCollection += dayObject['collection'].toDouble();
      }

      print('this week del $weekDelivery');

      print('this week col $weekCollection');
      //delcol today

      todayDelCol.update("Delivery", (value) => todayDelivery);
      todayDelCol.update("Collection", (value) => todayCollection);

      weekDelCol.update("Delivery", (value) => weekDelivery);
      weekDelCol.update("Collection", (value) => weekCollection);
      isSettingLoaded = true;
    } catch (e, stack) {
      print("Couldn't read file");
      print(e.toString());
      print(stack.toString());
    }

    print('online order status');
    print(isOnlineOrderOn);
    print('return called');
    return '';
    //return rawData;
  }
}
