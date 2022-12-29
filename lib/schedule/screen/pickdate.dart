import 'package:blue/model/schedule_model.dart';
import 'package:blue/schedule/schedulemain.dart';
import 'package:blue/schedule/widgets/constants.dart';
import 'package:blue/view/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//

import 'package:intl/intl.dart';

class PickDate extends StatefulWidget {
  @override
  _PickDateState createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> {
  DateTime selectedDate = DateTime.now();
  List<String> _dateList = List();
  final bool isStartButtonClicked = false;
  String _individual;
  String startDate;
  String endDate;

  DateTime startDateFormat;

  DateTime today = DateTime.now();

  void _selectDate(BuildContext context, int from) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startDateFormat == null
          ? today
          : startDateFormat.add(new Duration(days: 1)),
      firstDate: startDateFormat == null
          ? today
          : startDateFormat.add(new Duration(days: 1)),
      lastDate: today.add(new Duration(days: 1000)),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        // selectedDate = picked;

        _dateList.add((DateFormat.yMMMMEEEEd().format(picked)).toString());

        if (from == Constant.START_DATE) {
          startDate = (DateFormat.yMMMMEEEEd().format(picked)).toString();
          startDateFormat = picked;
        } else if (from == Constant.END_DATE) {
          endDate = (DateFormat.yMMMMEEEEd().format(picked)).toString();
        } else if (from == Constant.INDIVIDUAL) {
          startDate = (DateFormat.yMMMMEEEEd().format(picked)).toString();
          endDate = (DateFormat.yMMMMEEEEd().format(picked)).toString();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    // print(dateList[0].toString());
    final bool args = ModalRoute.of(context).settings.arguments;
    // final individualText =
    //     'Please click the Button for Picking Individual Date to close your business for a single day';
    // final rangeDate = 'Please click the Buttons for Picking Range Date, ';
    // final text = args ? individualText : rangeDate;

    print(args);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(args ? 'Individual' : 'Date Range'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(child: Image.asset('assets/icons/datetime.jpg')),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(
                      //     text,
                      //     style: TextStyle(color: Colors.blueGrey),
                      //   ),
                      // ),
                      (args)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                textColor: Colors.white,
                                color: Colors.deepOrange,
                                onPressed: () =>
                                    _selectDate(context, Constant.INDIVIDUAL),
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Pick a date')),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                    textColor: Colors.white,
                                    color: Colors.green,
                                    child: Text('Start Date'),
                                    onPressed: () => _selectDate(
                                        context, Constant.START_DATE),
                                  ),
                                  SizedBox(
                                    height: 10,
                                    width: 10,
                                  ),
                                  RaisedButton(
                                    textColor: Colors.white,
                                    color: Colors.deepOrange,
                                    child: Text('End Date'),
                                    onPressed: () =>
                                        _selectDate(context, Constant.END_DATE),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                args
                    ? startDate != null
                        ? Container(
                            padding: EdgeInsets.all(5),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 5),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'Your Business will be Closed On',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        startDate != null
                                            ? startDate
                                            : ' Please select from above',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton(
                                            color: Colors.blue[500],
                                            onPressed: () async {
                                              print('onpress');

                                              final overlay =
                                                  LoadingOverlay.of(context);
                                              final response =
                                                  await overlay.during(
                                                      ScheduleModel.addSchedule(
                                                          startDate, endDate));

                                              print(response);
                                              if (response == 'success') {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SchedulePage()));
                                              }
                                            },
                                            child: Text(
                                              'Add',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container()
                    : startDate != null
                        ? Container(
                            padding: EdgeInsets.all(5),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 5),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Your Business will be Closed',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('From : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.black54)),
                                          Text(
                                            startDate != null
                                                ? startDate
                                                : ' Please select from above',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('To : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.black54)),
                                          Text(
                                            endDate != null
                                                ? endDate
                                                : ' Please select from above',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton(
                                            color: Colors.blue[500],
                                            onPressed: () async {
                                              print('onpressrange');

                                              final overlay =
                                                  LoadingOverlay.of(context);
                                              final response =
                                                  await overlay.during(
                                                      ScheduleModel.addSchedule(
                                                          startDate, endDate));

                                              print(response);

                                              if (response == 'success') {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SchedulePage()));
                                              }
                                            },
                                            child: Text(
                                              'Add',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
