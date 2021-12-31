import 'dart:convert';

import 'package:blue/global/constant.dart';
import 'package:blue/podo/del_col_time.dart';
import 'package:http/http.dart' as http;

class DelColTimeModel {
  static updateDelColTime(DeliveryCollectionTime deliveryCollectionTime) async {


    print('updateDeliveryCollectionTime--------${deliveryCollectionTime.deliveryStartTime1}-${deliveryCollectionTime.deliveryStartTime2}--${deliveryCollectionTime.collectionStartTime1}---${deliveryCollectionTime.collectionStartTime2}---${deliveryCollectionTime.deliveryEndTime1}---${deliveryCollectionTime.deliveryEndTime2}---${deliveryCollectionTime.collectionEndTime1}---${deliveryCollectionTime.collectionEndTime2}');

    var response = await http
        .post('${Api.businessBaseUrl}updateDeliveryCollectionTime', body: {
      'api_key': "vB5Ex1nS6ABRsbliby8eCSe67VY077I1",
      'day': "${deliveryCollectionTime.id}",
      'delivery_start_time_1': deliveryCollectionTime.deliveryStartTime1,
      'delivery_start_time_2': deliveryCollectionTime.deliveryStartTime2,
      'collection_start_time_1': deliveryCollectionTime.collectionStartTime1,
      'collection_start_time_2': deliveryCollectionTime.collectionStartTime2,
      'delivery_end_time_1': deliveryCollectionTime.deliveryEndTime1,
      'delivery_end_time_2': deliveryCollectionTime.deliveryEndTime2,
      'collection_end_time_1': deliveryCollectionTime.collectionEndTime1,
      'collection_end_time_2': deliveryCollectionTime.collectionEndTime2,
    });

    print('---------------${deliveryCollectionTime.id}');
    print(response.body);
    return response.body;
  }

  static getDelColTime(String day) async {
    var response = await http
        .post('${Api.businessBaseUrl}getDeliveryCollectionStartEnd', body: {
      'day': "$day",
    });

    print('----------------res ----------');
    print(response.body);

    return jsonDecode(response.body);
  }


  static Future getDelColTimeLimit(String dayIndex) async {

    print('dayIndex ${int.parse(dayIndex)+1}');
      var response = await http
          .post('${Api.businessBaseUrl}getDeliveryCollectionLimit', body: {
        'dt_id':"${int.parse(dayIndex)+1}",
      });

      print('----------------res getDelColTimeLimit----------${response.body}');
      print(jsonDecode(response.body));

      return jsonDecode(response.body);



  }


  static Future updateDelColLimit(String dayIndex,String day,String deliveryTimeLimit,String collectionTimeLimit) async {
    print('----------------updateDelColLimit dayIndex---------- $dayIndex');
    try{
      var response = await http
          .post('${Api.businessBaseUrl}updateDeliveryCollectionLimit', body: {
        'dt_id': "${int.parse(dayIndex)+1}",
        'day': "$day",
        'dt_del_time': "$deliveryTimeLimit",
        'dt_col_time': "$collectionTimeLimit",
      });

      print('----------------res updateDelColLimit----------');
      print(response.body);

      return response.body;

    }
    catch(e){

      print(e.toString());

    }

  }



}
