import 'dart:ui';

import 'package:blue/global/constant.dart';
import 'package:blue/model/home_model.dart';
import 'package:blue/model/tablebookiing_details_model.dart';
import 'package:blue/model/tablebooking_model.dart';
import 'package:blue/podo/table_booking.dart';
import 'package:blue/receipt/table_booking_receipt.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get/get.dart';
import '../global_provider.dart';
import 'package:blue/schedule/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TableBookingScreen extends StatefulWidget {
  @override
  _TableBookingScreenState createState() => _TableBookingScreenState();
}

class _TableBookingScreenState extends State<TableBookingScreen> {
  TableBookingReceipt tableBookingReceipt;
  int initialTabIndex = 0;
  bool isLoading = true;
  bool isLoadingForTB = false;
  List<String> options = ["Today", "This week", "This month"];
  String optionDropdownValue = "Today";

  DateTime selectedDate = DateTime.now();
  List<String> _dateList = [];
  final bool isStartButtonClicked = false;
  String startDate = '';
  String startDateSend = '';
  String endDate = '';
  String endDateSend = '';

  BlueThermalPrinter blueThermalPrinter = BlueThermalPrinter.instance;

  DateTime startDateFormat = DateTime.now();

  DateTime today = DateTime.now();

  @override
  void initState() {
    tableBookingReceipt = TableBookingReceipt();

    TableBookingModel.getAllTableBooking(Static.typeLast).then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });

    super.initState();
  }

  void _selectDate(BuildContext context, int from) async {
    if (from == Constant.END_DATE) {
      today = DateTime.now();
    }

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: from == Constant.START_DATE ? today : today,


      firstDate: from == Constant.START_DATE
          ? startDateFormat.add(new Duration(days: -1000))
          : today.add(new Duration(days: -1000)),


      lastDate: from == Constant.START_DATE ? today : today,


    );
    if (picked != null && picked != selectedDate)
      setState(() {

        _dateList.add((DateFormat.yMMMMEEEEd().format(picked)).toString());
        if (from == Constant.START_DATE) {
          setState(() {
            startDate = (DateFormat.yMMMMEEEEd().format(picked)).toString();
            startDateSend =
                (DateFormat('yyyy-MM-dd 00.00.00').format(picked)).toString();
            startDateFormat = picked;
          });
        } else if (from == Constant.END_DATE) {
          setState(() {
            endDate = (DateFormat.yMMMMEEEEd().format(picked)).toString();
            endDateSend =
                (DateFormat('yyyy-MM-dd 23.59.59').format(picked)).toString();
          });
        }
      });
  }

  List<String> _status = [
    "Today",
    "Last 7 days",
    "Last 30 days",
    "This year",
    "Range"
  ];



  String _verticalGroupValue = "Today";
  bool isVisibleRange = false;
  bool isVisibleFrom = false;
  bool isVisibleTo = false;

  Future _dataSearch(int val) async {
    print('_dataSearch $val');
    // final overlay = LoadingOverlay.of(context);
    // await overlay.during(TableBookingModel.getAllOrders(val));
    TableBookingModel.getAllTableBooking(val).then((value) {
      print(
          'pendingOrders _dataSearch-----------------------------${TableBookingModel.pendingOrders.length}');
      setState(() {
        isLoading = false;
      });
    });
  }

  Future _dataSearchByRange() async {
    print('_dataSearchByRange ');
    // final overlay = LoadingOverlay.of(context);
    // await overlay.during(TableBookingModel.getAllOrders(val));
    if (startDate.isNotEmpty && endDate.isNotEmpty) {
      TableBookingModel.getAllTableBookingByRange(startDateSend, endDateSend)
          .then((value) {
        print(
            'pendingOrders-----------------------------${TableBookingModel.pendingOrders.length}');
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 54),
              child: Image(
                image: AssetImage('assets/OrderEe.png'),
                alignment: Alignment.center,
                height: 50,
                width: 200,
                fit: BoxFit.fill,
              ),
            ),
          ),
          actions: [
            // IconButton(
            //     icon: Icon(Icons.sort),
            //     onPressed: () {
            //       _filterOrderByDate();
            //     }),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(shrinkWrap: true, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Search table booking',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
            ),
            _buildDivider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RadioGroup<String>.builder(
                direction: Axis.vertical,
                groupValue: _verticalGroupValue,
                onChanged: (value) async {
                  setState(() {
                    _verticalGroupValue = value;
                  });

                  if (value == "Range") {
                    setState(() {
                      isVisibleRange = true;
                    });
                  } else {
                    setState(() {
                      isVisibleRange = false;
                    });
                  }
                },
                items: _status,
                itemBuilder: (item) => RadioButtonBuilder(
                  item,
                ),
              ),
            ),
            isVisibleRange ? _buildDivider() : Container(),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10),
            //   child: RaisedButton(
            //       textColor: Colors.white,
            //       color: Colors.deepOrange,
            //       child: Text('Search with range'),
            //       onPressed: () {
            //
            //       }),
            // ),
            isVisibleRange
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                                textColor: Colors.white,
                                color: Colors.green,
                                child: Text('From'),
                                onPressed: () {
                                  _selectDate(context, Constant.START_DATE);
                                  setState(() {
                                    isVisibleFrom = true;
                                  });
                                }),
                            SizedBox(
                              height: 10,
                              width: 10,
                            ),
                            RaisedButton(
                                textColor: Colors.white,
                                color: Colors.deepOrange,
                                child: Text('To'),
                                onPressed: () {
                                  _selectDate(context, Constant.END_DATE);
                                  setState(() {
                                    isVisibleTo = true;
                                  });
                                })
                          ],
                        ),
                        isVisibleFrom
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'From',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('$startDate $startDateSend',
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              )
                            : Container(),
                        isVisibleTo
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'To',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('$endDate $endDateSend',
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                : Container(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  if (_verticalGroupValue == "Today") {
                    print('---------------------------------Today');
                    Navigator.pop(context);
                    Static.typeLast = 1;
                    _dataSearch(1).then((value) => () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                  } else if (_verticalGroupValue == "Last 7 days") {
                    print(
                        '-----------------------------------------------Last 7 days');
                    Static.typeLast = 2;
                    Navigator.pop(context);
                    _dataSearch(2).then((value) => () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                  } else if (_verticalGroupValue == "Last 30 days") {
                    print(
                        '------------------------------------------------------Last 30 days');
                    Navigator.pop(context);
                    Static.typeLast = 3;
                    _dataSearch(3).then((value) => () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                  } else if (_verticalGroupValue == "This year") {
                    print(
                        '------------------------------------------------------This year');
                    Navigator.pop(context);
                    Static.typeLast = 4;
                    _dataSearch(4).then((value) => () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                  } else if (_verticalGroupValue == "Range") {
                    print(
                        '------------------------------------------------------Range');
                    Navigator.pop(context);
                    _dataSearchByRange().then((value) => () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
        body: HomeModel.isTableBookingOn
            ? RefreshIndicator(
                onRefresh: _refreshData,
                backgroundColor: Colors.deepOrange,
                color: Colors.white,
                displacement: 150,
                strokeWidth: 4,
                child: isLoadingForTB
                    ? Container(
                        child: Center(
                            child: CircularProgressIndicator(
                                color: Colors.deepOrange)))
                    : ListView(
                        children: [
                          DefaultTabController(
                              length: 3, // length of tabs
                              initialIndex: initialTabIndex,
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container(
                                      child: TabBar(
                                        labelColor: Colors.deepOrange,
                                        unselectedLabelColor: Colors.black,
                                        // isScrollable:
                                        //     : true,
                                        tabs: [
                                          Tab(text: 'Pending'),
                                          Tab(text: 'Accepted'),
                                          Tab(text: 'Cancelled'),
                                          // Static.displayAwaitingNotPaidPayment
                                          // ? Tab(text: '${Static.Unconfirmed_payment_button_Value}')
                                          // : Container(height: 0,width: 0,),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                (210), //height of TabBarView
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.5))),
                                        child: TabBarView(children: <Widget>[
                                          TableBookingModel
                                                      .pendingOrders.length ==
                                                  0
                                              ? isLoading
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                          CircularProgressIndicator(
                                                              color: Colors
                                                                  .deepOrange)
                                                        ])
                                                  : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          size: 120,
                                                          color:
                                                              Colors.grey[300],
                                                        ),

                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          'No table booking found!',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    )
                                              : ListView.builder(
                                                  itemCount: TableBookingModel
                                                      .pendingOrders.length,
                                                  itemBuilder:
                                                      (BuildContext ctxt,
                                                          int index) {
                                                    if (index >
                                                        TableBookingModel
                                                            .pendingOrders
                                                            .length) {
                                                      return SizedBox();
                                                    }
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0,
                                                              right: 5),
                                                      child: Card(
                                                        child: InkWell(
                                                          onTap: () {
                                                            // if (!Static
                                                            //     .autoPrintTableBookingReceipt) {
                                                            _showMyDialog(
                                                                (TableBookingModel
                                                                        .pendingOrders[
                                                                    index]));
                                                            // }
                                                          },
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .table_chart_outlined,
                                                                        size:
                                                                            30,
                                                                        color: Colors
                                                                            .deepOrange,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Static.displayOrderIdTable
                                                                              ? Text(
                                                                                  '#${TableBookingModel.pendingOrders[index].orderId}',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                                )
                                                                              : Container(),
                                                                          Text(
                                                                            '${TableBookingModel.pendingOrders[index].customerName}',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.normal,
                                                                                color: Colors.black,
                                                                                fontSize: 14),
                                                                          ),
                                                                          Text(
                                                                            '${TableBookingModel.pendingOrders[index].customerEmail}',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.normal,
                                                                                color: Colors.black,
                                                                                fontSize: 12),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 5.0),
                                                                            child:
                                                                                FittedBox(
                                                                              child: Text(
                                                                                'Date: ${TableBookingModel.pendingOrders[index].orderDate}',
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 4),
                                                                            child:
                                                                                Card(
                                                                              elevation: 0,
                                                                              color: Colors.deepOrange[50],
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(4.0),
                                                                                child: Text(
                                                                                  'Time-${TableBookingModel.pendingOrders[index].orderTime}',
                                                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 4),
                                                                            child:
                                                                                Card(
                                                                              elevation: 0,
                                                                              color: Colors.black,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(4.0),
                                                                                child: FittedBox(
                                                                                  child: Text(
                                                                                    'Number of guests-${TableBookingModel.pendingOrders[index].numberOfGuest}',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                              TableBookingModel
                                                                          .pendingOrders[
                                                                              index]
                                                                          .specialReq !=
                                                                      ""
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              15,
                                                                          right:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            0,
                                                                        color: Colors
                                                                            .green[50],
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Expanded(
                                                                                child: RichText(
                                                                                    text: TextSpan(children: [
                                                                                  TextSpan(text: 'Special request: ', style: TextStyle(fontSize: 14.0, color: Colors.black)),
                                                                                  TextSpan(text: "${TableBookingModel.pendingOrders[index].specialReq}", style: TextStyle(fontSize: 14.0, color: Colors.black54)),
                                                                                ])),
                                                                              ),
                                                                              // RichText(
                                                                              //     text: TextSpan(children: [
                                                                              //       TextSpan(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley ${TableBookingModel.pendingOrders[index].specialReq}", style: TextStyle(,fontSize: 14.0,color: Colors.blue))
                                                                              //     ])),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(),

                                                              // Padding(
                                                              //   padding: const EdgeInsets.only(left: 20,bottom: 5,right: 5),
                                                              //   child: Text(" ",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 12)),
                                                              // )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                          TableBookingModel
                                                      .acceptedOrders.length ==
                                                  0
                                              ? isLoading
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                          CircularProgressIndicator(
                                                              color: Colors
                                                                  .deepOrange)
                                                        ])
                                                  : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Container(
                                                        //   height: MediaQuery.of(context).size.width/2,
                                                        //   width: MediaQuery.of(context).size.height/3,
                                                        //   child: Padding(
                                                        //     padding: const EdgeInsets.all(8.0),
                                                        //     child: SvgPicture.asset('assets/table.svg'),
                                                        //   ),
                                                        // ),
                                                        Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          size: 120,
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          'No table booking found!',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    )
                                              : ListView.builder(
                                                  itemCount: TableBookingModel
                                                      .acceptedOrders.length,
                                                  itemBuilder:
                                                      (BuildContext ctxt,
                                                          int index) {
                                                    if (index >=
                                                        TableBookingModel
                                                            .acceptedOrders
                                                            .length) {
                                                      return SizedBox();
                                                    }




                                                    return GestureDetector(
                                                      onTap: () {
                                                        _showMyDialog(
                                                            (TableBookingModel
                                                                .acceptedOrders[
                                                            index]),true);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 2,
                                                                horizontal: 5),
                                                        child: Card(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .table_chart_outlined,
                                                                        size:
                                                                            30,
                                                                        color: Colors
                                                                            .deepOrange,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Static.displayOrderIdTable
                                                                              ? Text(
                                                                                  '#${TableBookingModel.acceptedOrders[index].orderId}',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                                )
                                                                              : Container(),
                                                                          Text(
                                                                            '${TableBookingModel.acceptedOrders[index].customerName}',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.normal,
                                                                                color: Colors.black,
                                                                                fontSize: 14),
                                                                          ),
                                                                          Text(
                                                                            '${TableBookingModel.acceptedOrders[index].customerEmail}',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.normal,
                                                                                color: Colors.black,
                                                                                fontSize: 12),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 5.0),
                                                                            child:
                                                                                FittedBox(
                                                                              child: Text(
                                                                                'Date: ${TableBookingModel.acceptedOrders[index].orderDate}',
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 4),
                                                                            child:
                                                                                Card(
                                                                              elevation: 0,
                                                                              color: Colors.deepOrange[50],
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(4.0),
                                                                                child: Text(
                                                                                  'Time-${TableBookingModel.acceptedOrders[index].orderTime}',
                                                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 4),
                                                                            child:
                                                                                Card(
                                                                              color: Colors.black,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(4.0),
                                                                                child: FittedBox(
                                                                                  child: Text(
                                                                                    'Number of guests-${TableBookingModel.acceptedOrders[index].numberOfGuest}',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              TableBookingModel
                                                                          .acceptedOrders[
                                                                              index]
                                                                          .specialReq !=
                                                                      ""
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              15,
                                                                          right:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            0,
                                                                        color: Colors
                                                                            .green[50],
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Expanded(
                                                                                child: RichText(
                                                                                    text: TextSpan(children: [
                                                                                  TextSpan(text: 'Special request: ', style: TextStyle(fontSize: 14.0, color: Colors.black)),
                                                                                  TextSpan(text: "${TableBookingModel.acceptedOrders[index].specialReq}", style: TextStyle(fontSize: 14.0, color: Colors.black54)),
                                                                                ])),
                                                                              ),
                                                                              // RichText(
                                                                              //     text: TextSpan(children: [
                                                                              //       TextSpan(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley ${TableBookingModel.pendingOrders[index].specialReq}", style: TextStyle(,fontSize: 14.0,color: Colors.blue))
                                                                              //     ])),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                          TableBookingModel
                                                      .cancelledOrders.length ==
                                                  0
                                              ? isLoading
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                          CircularProgressIndicator(
                                                              color: Colors
                                                                  .deepOrange)
                                                        ])
                                                  : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Container(
                                                        //   height: MediaQuery.of(context).size.width/1.2,
                                                        //   width: MediaQuery.of(context).size.height/2,
                                                        //   child: Padding(
                                                        //     padding: const EdgeInsets.all(8.0),
                                                        //     child: Image.asset('assets/Reserved.png'),
                                                        //   ),
                                                        // ),
                                                        Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          size: 120,
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          'No table booking found!',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    )
                                              : ListView.builder(
                                                  itemCount: TableBookingModel
                                                      .cancelledOrders.length,
                                                  itemBuilder:
                                                      (BuildContext ctxt,
                                                          int index) {
                                                    if (index >=
                                                        TableBookingModel
                                                            .cancelledOrders
                                                            .length) {
                                                      return SizedBox();
                                                    }
                                                    return GestureDetector(
                                                      onTap: () {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder: (context) =>
                                                        //             OrderDetails(TableBookingModel
                                                        //                 .acceptedOrders[index]
                                                        //                 .orderId)));
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 2,
                                                                    horizontal:
                                                                        5),
                                                            child: Card(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Icon(
                                                                            Icons.table_chart_outlined,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Colors.deepOrange,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Static.displayOrderIdTable
                                                                                  ? Text(
                                                                                      '#${TableBookingModel.cancelledOrders[index].orderId}',
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                                    )
                                                                                  : Container(),
                                                                              Text(
                                                                                '${TableBookingModel.cancelledOrders[index].customerName}',
                                                                                style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14),
                                                                              ),
                                                                              Text(
                                                                                '${TableBookingModel.cancelledOrders[index].customerEmail}',
                                                                                style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 12),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 5.0),
                                                                                child: FittedBox(
                                                                                  child: Text(
                                                                                    'Date: ${TableBookingModel.cancelledOrders[index].orderDate}',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(bottom: 4),
                                                                                child: Card(
                                                                                  elevation: 0,
                                                                                  color: Colors.deepOrange[50],
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(4.0),
                                                                                    child: Text(
                                                                                      'Time-${TableBookingModel.cancelledOrders[index].orderTime}',
                                                                                      style: TextStyle(color: Colors.black, fontSize: 12),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(bottom: 4),
                                                                                child: Card(
                                                                                  elevation: 0,
                                                                                  color: Colors.black,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(4.0),
                                                                                    child: FittedBox(
                                                                                      child: Text(
                                                                                        'Number of guests-${TableBookingModel.cancelledOrders[index].numberOfGuest}',
                                                                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableBookingModel
                                                                              .cancelledOrders[index]
                                                                              .specialReq !=
                                                                          ""
                                                                      ? Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 15,
                                                                              right: 5,
                                                                              bottom: 5),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                0,
                                                                            color:
                                                                                Colors.green[50],
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: RichText(
                                                                                        text: TextSpan(children: [
                                                                                      TextSpan(text: 'Special request: ', style: TextStyle(fontSize: 14.0, color: Colors.black)),
                                                                                      TextSpan(text: "${TableBookingModel.cancelledOrders[index].specialReq}", style: TextStyle(fontSize: 14.0, color: Colors.black54)),
                                                                                    ])),
                                                                                  ),
                                                                                  // RichText(
                                                                                  //     text: TextSpan(children: [
                                                                                  //       TextSpan(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley ${TableBookingModel.pendingOrders[index].specialReq}", style: TextStyle(,fontSize: 14.0,color: Colors.blue))
                                                                                  //     ])),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                        ]))
                                  ])),
                        ],
                      ),
              )
            : Scaffold(
                body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 150,
                      color: Colors.red,
                    ),
                    Center(child: Text('Your table Booking is off!')),
                  ],
                ),
              )));
  }

  Future<void> _showMyDialog(
    TableBooking tableBooking,[bool isBookingAccepted = false]
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                isBookingAccepted?'Accepted table booking':'Pending table booking!',
                style: TextStyle(color: Colors.deepOrange),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Booking id- ${tableBooking.orderId}',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),

          actions: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text('skip')),
          ],
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RaisedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          if (!Static.isBusy) {

                            setState(() {
                              isLoadingForTB = true;
                            });

                            print(
                                'tableBooking.orderId.toString()-----------------------${tableBooking.orderId.toString()}');
                            if (Provider.of<GlobalProvider>(context,
                                        listen: false)
                                    .getPrinterConnectionStatus &&
                                await blueThermalPrinter.isConnected) {
                              var result = await TableBookingDetailsModel
                                  .getTableBookingDetails(
                                      tableBooking.orderId.toString());

                              print(
                                  'getTableBookingDetails--------------result-----------$result');

                              if (result) {

                                if(isBookingAccepted){
                                  await responseIntent();
                                }
                                else{

                                  if(!Static.enableDeveloperMode){
                                    await TableBookingModel.tableBookingChangeStatus(
                                        tableBooking.orderId.toString(), '2');
                                  }
                                  if(Static.autoPrintTableBookingReceipt){
                                    await responseIntent();
                                  }
                                }


                              } else {
                                setState(() {
                                  isLoadingForTB = false;
                                });
                                Get.snackbar(
                                  "Internet alert!",
                                  "Something went wrong, please check your internet connection and try again",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red[300],
                                  colorText: Colors.white,
                                  duration: Duration(seconds: 5),
                                );
                              }
                            } else {
                              setState(() {
                                isLoadingForTB = false;
                              });
                              Get.snackbar(
                                "Printer alert!",
                                "Something went wrong, please check your printer connection",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red[300],
                                colorText: Colors.white,
                                duration: Duration(seconds: 5),
                              );
                            }
                          } else {
                            Get.snackbar(
                              "Alert!",
                              "Printer is busy ",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green[300],
                              colorText: Colors.red,
                              duration: Duration(seconds: 5),
                            );
                          }

                          // tableBookingReceipt.tableReceipt();
                        },
                        child: Text(
                          isBookingAccepted?'Print':'Accept',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RaisedButton(
                        onPressed: () async {
                          print(
                              "printer--------------------------------${Static.isBusy}");

                          Navigator.pop(context);
                          setState(() {
                            isLoadingForTB = true;
                          });
                          await Future.delayed(Duration(seconds: 1));
                          TableBookingModel.tableBookingChangeStatus(
                              tableBooking.orderId.toString(), '3');
                          await Future.delayed(Duration(seconds: 1));
                          await responseIntentCancel();
                        },
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // actions: <Widget>[
          //   TextButton(
          //     child: Text(
          //       'ok',
          //       style: TextStyle(fontSize: 16),
          //     ),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  responseIntent() async {
    tableBookingReceipt.tableReceipt();
    await Future.delayed(Duration(seconds: 2));
    await TableBookingModel.getAllTableBooking(Static.typeLast);
    setState(() {
      isLoadingForTB = false;
    });
    // print(
    //     'response accept_Table booking------------------------------------$value');
    // if (value != 'failed') {
    //   ('response accept_Table booking------------------------------------failed');
    //   // Navigator.pop(context);
    // }
  }



  //
  responseIntentCancel() async {
    await TableBookingModel.getAllTableBooking(Static.typeLast);
    setState(() {
      isLoadingForTB = false;
    });
    print('responseIntentCancel  booking------------------------------------');
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }

  printTable(int id) async {
    TableBookingReceipt tableBookingReceipt = TableBookingReceipt();
    // TableBookingReceipt80 tableBookingReceipt80=TableBookingReceipt80();

    // if(Static.Paper_Size=='58mm'){
    tableBookingReceipt.tableReceipt();
    if (!Static.enableDeveloperMode) {
      await TableBookingModel.tableBookingChangeStatus(id.toString(), '2');
    }
    Static.tableOrderList.add(id.toString());
    // }
    // else{
    //   tableBookingReceipt80.tableReceipt();
    //   if (!Static.enableDeveloperMode) {
    //     await TableBookingModel.tableBookingChangeStatus(id.toString(), '2');
    //   }
    //   Static.tableOrderList.add(id.toString());
    // }

    print(
        'TableBookingDetailsModel.customer. ------------------${TableBookingDetailsModel.customer.orderId}');
    print(
        'TableBookingDetailsModel.customer. ------------------${TableBookingDetailsModel.customer.customerName}');
    print(
        'TableBookingDetailsModel.customer. ------------------${TableBookingDetailsModel.customer.orderTime}');
  }

  Future _refreshData() async {
    await TableBookingModel.getAllTableBooking(Static.typeLast);
    setState(() {});
  }
}
