import 'dart:convert';

import 'package:blue/global/constant.dart';
import 'package:http/http.dart' as http;
import 'package:blue/podo/menu/menu_category.dart';

class ScheduleModel {
  static addSchedule(String startDate, String endDate) async {
    var response = await http.post('${Api.businessBaseUrl}add_schedule', body: {
      'start_date': startDate,
      'end_date': endDate,
      'key': 'TrA5x8oEbAQJIkBiFoYDKK2WRD6tzKLV',
    });

    print('-------------------------------------------');
    print(response.body);
    return response.body;
  }

  static Future<List<dynamic>> getSchedule() async {
    var response = await http.get('${Api.businessBaseUrl}get_schedule');
    print('response : ${response.body}');
    final jsonResponse = jsonDecode(response.body);

    print(jsonResponse);

    List<dynamic> schedules = jsonResponse;
    return schedules;
  }

  static deleteSchedule(String id) async {
    var response = await http.post('${Api.businessBaseUrl}delete_schedule', body: {
      'id': id,
      'key': 'TrA5x8oEbAQJIkBiFoYDKK2WRD6tzKLV',
    });

    return response.body;
  }

}
