import 'dart:developer';

import 'package:blue/global/constant.dart';
import 'package:blue/model/del_col_time.dart';
import 'package:blue/podo/del_col_time.dart';
import 'package:blue/view/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class SetDelCol extends StatefulWidget {
  final String day;
  final String dayInNum;

  SetDelCol(this.day, this.dayInNum);

  @override
  _SetDelColState createState() => _SetDelColState();
}

class _SetDelColState extends State<SetDelCol> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSelected = false;
  final format = DateFormat("HH:mm");

  bool isLoading=true;

  String deliveryStartTime1 = "",
      deliveryEndTime1 = "",
      deliveryStartTime2 = "",
      deliveryEndTime2 = "";
  String collectionStartTime1 = "",
      collectionEndTime1 = "",
      collectionStartTime2 = "",
      collectionEndTime2 = "";

  String temp_deliveryStartTime1 = "",
      temp_deliveryEndTime1 = "",
      temp_deliveryStartTime2 = "",
      temp_deliveryEndTime2 = "";

  String temp_collectionStartTime1 = "",
      temp_collectionEndTime1 = "",
      temp_collectionStartTime2 = "",
      temp_collectionEndTime2 = "";

  @override
  void initState() {
    super.initState();
    DelColTimeModel.getDelColTime(widget.dayInNum).then((val) {
      deliveryStartTime1 = val['delivery_start'];
      print('deliveryEndTime1'+deliveryEndTime1);
      deliveryEndTime1 = val['delivery_end'];
      deliveryStartTime2 = val['delivery_start_sp2'];
      deliveryEndTime2 = val['delivery_end_sp2'];

      collectionStartTime1 = val['collection_start'];
      collectionEndTime1 = val['collection_end'];
      collectionStartTime2 = val['collection_start_sp2'];
      collectionEndTime2 = val['collection_end_sp2'];



      setState(() {
        isLoading=false;

      });
    });
  }

  Decoration getRoundedCorner() {
    return BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(widget.day),),
      body:isLoading?Center(child: CircularProgressIndicator(color: Colors.deepOrange,)): ListView(
        children: [


          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Shift One',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Delivery start time'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: getRoundedCorner(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: DateTimeField(
                              format: format,
                              onChanged: (val) {
                                setState(() {
                                  if (val != null) {
                                    deliveryStartTime1 =
                                        '${val.hour}:${val.minute<10?"0${val.minute}":"${val.minute}"}';
                                    print('deliveryStartTime1-${val.minute<10?"0${val.minute}":"${val.minute}"}');

                                    temp_deliveryStartTime1 =
                                        deliveryStartTime1;
                                  } else {
                                    temp_deliveryStartTime1 = "Tap here";
                                    deliveryStartTime1 = "";
                                  }
                                });
                              },
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                  builder: (context, child) => MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child),
                                );
                                return DateTimeField.convert(time);
                              },
                            ),
                          ),
                        ),
                        (deliveryStartTime1 == "")
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  'Tap here',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ))
                            : (deliveryStartTime1 == temp_deliveryStartTime1)
                                ? SizedBox()
                                : Center(
                                    child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Text(
                                      deliveryStartTime1,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Delivery end time'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: getRoundedCorner(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: DateTimeField(
                              format: format,
                              onChanged: (val) {
                                setState(() {
                                  if (val != null) {
                                    deliveryEndTime1 =
                                    '${val.hour}:${val.minute<10?"0${val.minute}":"${val.minute}"}';
                                    temp_deliveryEndTime1=deliveryEndTime1;

                                  } else {
                                    deliveryEndTime1 ="";
                                    temp_deliveryEndTime1='Tap here';

                                  }
                                });
                              },
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                  builder: (context, child) => MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child),
                                );
                                return DateTimeField.convert(time);
                              },
                            ),
                          ),
                        ),
                        (deliveryEndTime1 == "")
                            ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Tap here',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ))
                            : (deliveryEndTime1 == temp_deliveryEndTime1)
                            ? SizedBox()
                            : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                deliveryEndTime1,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Collection start time'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: getRoundedCorner(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: DateTimeField(
                              format: format,
                              onChanged: (val) {
                                setState(() {
                                  if (val != null) {
                                    collectionStartTime1 =
                                    '${val.hour}:${val.minute<10?"0${val.minute}":"${val.minute}"}';

                                    temp_collectionStartTime1=collectionStartTime1;
                                  } else {
                                    collectionStartTime1 = "";
                                    temp_collectionStartTime1='Tap here';
                                  }
                                });
                              },
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                  builder: (context, child) => MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child),
                                );
                                return DateTimeField.convert(time);
                              },
                            ),
                          ),
                        ),
                        (collectionStartTime1 == "")
                            ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Tap here',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ))
                            : (collectionStartTime1 == temp_collectionStartTime1)
                            ? SizedBox()
                            : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                collectionStartTime1,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Collection end time'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: getRoundedCorner(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: DateTimeField(
                              format: format,
                              onChanged: (val) {
                                setState(() {
                                  if (val != null) {
                                    collectionEndTime1 =
                                    '${val.hour}:${val.minute<10?"0${val.minute}":"${val.minute}"}';
                                    temp_collectionEndTime1=collectionEndTime1;
                                  } else {
                                    collectionEndTime1 = "";
                                    temp_collectionEndTime1='Tap here';
                                  }
                                });
                              },
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                  builder: (context, child) => MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child),
                                );
                                return DateTimeField.convert(time);
                              },
                            ),
                          ),
                        ),
                        (collectionEndTime1 == "")
                            ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Tap here',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ))
                            : (collectionEndTime1 == temp_collectionEndTime1)
                            ? SizedBox()
                            : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                collectionEndTime1,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Shift Two',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Delivery start time'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: getRoundedCorner(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: DateTimeField(
                              format: format,
                              onChanged: (val) {
                                setState(() {
                                  if (val != null) {
                                    deliveryStartTime2 =
                                    '${val.hour}:${val.minute<10?"0${val.minute}":"${val.minute}"}';
                                    temp_deliveryStartTime2=deliveryStartTime2;
                                  } else {
                                    deliveryStartTime2 = "";
                                    temp_deliveryStartTime2='Tap here';
                                  }
                                });
                              },
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                  builder: (context, child) => MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child),
                                );
                                return DateTimeField.convert(time);
                              },
                            ),
                          ),
                        ),
                        (deliveryStartTime2 == "")
                            ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Tap here',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ))
                            : (deliveryStartTime2 == temp_deliveryStartTime2)
                            ? SizedBox()
                            : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                deliveryStartTime2,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Delivery end time'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: getRoundedCorner(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: DateTimeField(
                              format: format,
                              onChanged: (val) {
                                setState(() {
                                  if (val != null) {
                                    deliveryEndTime2 =
                                    '${val.hour}:${val.minute<10?"0${val.minute}":"${val.minute}"}';
                                    temp_deliveryEndTime2=deliveryEndTime2;
                                  } else {
                                    deliveryEndTime2 = "";
                                    temp_deliveryEndTime2='Tap here';
                                  }
                                });
                              },
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                  builder: (context, child) => MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child),
                                );
                                return DateTimeField.convert(time);
                              },
                            ),
                          ),
                        ),
                        (deliveryEndTime2 == "")
                            ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Tap here',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ))
                            : (deliveryEndTime2 == temp_deliveryEndTime2)
                            ? SizedBox()
                            : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                deliveryEndTime2,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Collection start time'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: getRoundedCorner(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: DateTimeField(
                              format: format,
                              onChanged: (val) {
                                setState(() {
                                  if (val != null) {
                                    collectionStartTime2 =
                                    '${val.hour}:${val.minute<10?"0${val.minute}":"${val.minute}"}';
                                    temp_collectionStartTime2=collectionStartTime2;
                                  } else {
                                    collectionStartTime2 = "";
                                    temp_collectionStartTime2='Tap here';
                                  }
                                });
                              },
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                  builder: (context, child) => MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child),
                                );
                                return DateTimeField.convert(time);
                              },
                            ),
                          ),
                        ),
                        (collectionStartTime2 == "")
                            ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Tap here',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ))
                            : (collectionStartTime2 == temp_collectionStartTime2)
                            ? SizedBox()
                            : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                collectionStartTime2,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Collection end time'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: getRoundedCorner(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: DateTimeField(
                              format: format,
                              onChanged: (val) {
                                setState(() {
                                  if (val != null) {
                                    collectionEndTime2 =
                                    '${val.hour}:${val.minute<10?"0${val.minute}":"${val.minute}"}';
                                    temp_collectionEndTime2=collectionEndTime2;
                                  } else {
                                    collectionEndTime2 = "";
                                    temp_collectionEndTime2='Tap here';
                                  }
                                });
                              },
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                  builder: (context, child) => MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child),
                                );
                                return DateTimeField.convert(time);
                              },
                            ),
                          ),
                        ),
                        (collectionEndTime2 == "")
                            ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Tap here',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ))
                            : (collectionEndTime2== temp_collectionEndTime2)
                            ? SizedBox()
                            : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                collectionEndTime2,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              color: MyColors.colorActiveIcon,
              onPressed: () async {
                DeliveryCollectionTime delColTime = DeliveryCollectionTime();

                delColTime.deliveryStartTime1 =
                    deliveryStartTime1 == null ? "00:00" : deliveryStartTime1;
                delColTime.deliveryEndTime1 =
                    deliveryEndTime1 == null ? "00:00" : deliveryEndTime1;
                delColTime.collectionStartTime1 = collectionStartTime1 == null
                    ? "00:00"
                    : collectionStartTime1;
                delColTime.collectionEndTime1 =
                    collectionEndTime1 == null ? "00:00" : collectionEndTime1;

                delColTime.deliveryStartTime2 =
                    deliveryStartTime2 == null ? "00:00" : deliveryStartTime2;
                delColTime.deliveryEndTime2 =
                    deliveryEndTime2 == null ? "00:00" : deliveryEndTime2;
                delColTime.collectionStartTime2 = collectionStartTime2 == null
                    ? "00:00"
                    : collectionStartTime2;
                delColTime.collectionEndTime2 =
                    collectionEndTime2 == null ? "00:00" : collectionEndTime2;

                delColTime.id = widget.dayInNum;

                final overlay = LoadingOverlay.of(context);
                final response = await overlay
                    .during(DelColTimeModel.updateDelColTime(delColTime));

                if (response == '"success"') {
                  _scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: Text('Time updated'),
                  ));

                  await Future.delayed(Duration(seconds: 2));

                  Navigator.pop(context);
                } else {
                  _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content:
                          Text('Something went wrong! Please try again.')));
                }

                print(response);
              },
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
