import 'dart:async';

import 'dart:io';
import 'dart:ui';
import 'package:blue/global/constant.dart';
import 'package:blue/model/order_details_model.dart';
import 'package:blue/receipt/global_printing.dart';
import 'package:blue/schedule/widgets/constants.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:blue/model/order_model.dart';
import 'package:blue/view/order_details.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../global/constant.dart';
import '../global_provider.dart';
import '../model/order_model.dart';

class OrderPage extends StatefulWidget {
  final GlobalPrinting globalPrinting = GlobalPrinting();

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int initialTabIndex = 0;
  bool isLoading = true;

  DateTime selectedDate = DateTime.now();
  List<String> _dateList = [];

  final bool isStartButtonClicked = false;
  String startDate = '';
  String startDateSend = '';
  String endDate = '';
  String endDateSend = '';
  GlobalPrinting globalPrinting = GlobalPrinting();
  String delayTIme = '';

  bool isLoadingOrder = false;

  DateTime startDateFormat = DateTime.now();

  DateTime today = DateTime.now();
  Timer periodicTimer;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  @override
  void initState() {

    timerForData();

    if (Static.showOnlyCurrentDaysOrder) {
      OrderModel.getAllOrders(1).then((value) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      OrderModel.getAllOrders(Static.typeLastOrder).then((value) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }

    print('order api called');

    print('pending orders');
    print(OrderModel.pendingOrders.length);

    super.initState();
  }

  @override
  void dispose() {
    periodicTimer.cancel();
    super.dispose();
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
        // selectedDate = picked;
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


  bool isVisibleRange = false;
  bool isVisibleFrom = false;
  bool isVisibleTo = false;

  Future _dataSearch(int val) async {
    // final overlay = LoadingOverlay.of(context);
    // await overlay.during(OrderModel.getAllOrders(val));
    OrderModel.getAllOrders(val).then((value) {
      print(
          'pendingOrders-----------------------------${OrderModel.pendingOrders.length}');
      setState(() {
        isLoading = false;
      });
    });
  }

  Future _dataSearchByRange() async {
    if (startDate.isNotEmpty && endDate.isNotEmpty) {
      OrderModel.getAllOrdersByRange(startDateSend, endDateSend).then((value) {
        print(
            'pendingOrders-----------------------------${OrderModel.pendingOrders.length}');
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("BuildContext---------------------orderPage");

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
          actions: [],
        ),
        endDrawer: Drawer(
          child: Static.showOnlyCurrentDaysOrder
              ? Center(
                  child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                            height: 200,
                            width: 200,
                            child: SvgPicture.asset('assets/no_data.svg')),
                      ),
                      FittedBox(
                          fit: BoxFit.fill,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                                'you have selected show only current days true'),
                          )),
                    ],
                  ),
                ))
              : ListView(shrinkWrap: true, children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Search orders ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildDivider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RadioGroup<String>.builder(
                      direction: Axis.vertical,
                      groupValue: OrderModel.verticalGroupValue,
                      onChanged: (value) async {
                        setState(() {
                          OrderModel.verticalGroupValue = value;
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
                                        _selectDate(
                                            context, Constant.START_DATE);
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'From',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text('$startDate $startDateSend',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              isVisibleTo
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'To',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text('$endDate $endDateSend',
                                              style: TextStyle(
                                                  color: Colors.grey)),
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
                    child: Container(
                      child: RaisedButton(
                        color: Colors.green,
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          if (OrderModel.verticalGroupValue == "Today") {
                            print('---------------------------------Today');
                            Navigator.pop(context);
                            Static.typeLastOrder = 1;
                            _dataSearch(1).then((value) => () {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                          } else if (OrderModel.verticalGroupValue == "Last 7 days") {
                            print(
                                '-----------------------------------------------Last 7 days');
                            Navigator.pop(context);
                            Static.typeLastOrder = 2;
                            _dataSearch(2).then((value) => () {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                          } else if (OrderModel.verticalGroupValue == "Last 30 days") {
                            print(
                                '------------------------------------------------------Last 30 days');
                            Navigator.pop(context);
                            Static.typeLastOrder = 3;
                            _dataSearch(3).then((value) => () {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                          } else if (OrderModel.verticalGroupValue == "This year") {
                            print(
                                '------------------------------------------------------This year');
                            Navigator.pop(context);
                            Static.typeLastOrder = 4;
                            _dataSearch(4).then((value) => () {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                          } else if (OrderModel.verticalGroupValue == "Range") {
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
                    ),
                  )
                ]),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          backgroundColor: Colors.deepOrange,
          color: Colors.white,
          displacement: 150,
          strokeWidth: 4,
          child: isLoadingOrder
              ? Container(
                  child: Center(
                      child: CircularProgressIndicator(
                  backgroundColor: Colors.deepOrange,
                )))
              : ListView(
                  children: [
                    DefaultTabController(
                        length: Static.displayAwaitingNotPaidPayment ? 4 : 3,
                        // length of tabs
                        initialIndex: initialTabIndex,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                child: TabBar(
                                  labelColor: Colors.deepOrange,
                                  unselectedLabelColor: Colors.black,
                                  isScrollable:
                                      Static.displayAwaitingNotPaidPayment
                                          ? true
                                          : false,
                                  tabs: [
                                    Tab(text: 'Pending'),
                                    Tab(text: 'Accepted'),
                                    Tab(text: 'Cancelled'),
                                    if (Static.displayAwaitingNotPaidPayment)
                                      Tab(
                                          text:
                                              '${Static.Unconfirmed_payment_button_Value}'),
                                  ],
                                ),
                              ),
                              Container(
                                  height: MediaQuery.of(context).size.height -
                                      (210), //height of TabBarView
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 0.5))),
                                  child: TabBarView(children: <Widget>[
                                    OrderModel.pendingOrders.length == 0
                                        ? isLoading
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                    CircularProgressIndicator(
                                                        color:
                                                            Colors.deepOrange)
                                                  ])
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.no_food,
                                                    size: 120,
                                                    color: Colors.grey[300],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'No orders found!',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              )
                                        : ListView.builder(
                                            itemCount:
                                                OrderModel.pendingOrders.length,
                                            itemBuilder:
                                                (BuildContext ctxt, int index) {
                                              if (index >
                                                  OrderModel
                                                      .pendingOrders.length) {
                                                return SizedBox();
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5),
                                                child: Card(
                                                  child: InkWell(
                                                    onDoubleTap: () async {
                                                      if (Static
                                                          .autoPrintOrder)
                                                        _showMyDialog(OrderModel
                                                            .pendingOrders[
                                                        index]
                                                            .orderId
                                                            .toString());
                                                    },
                                                  onTap: () async {
                                                      if (!Static
                                                          .autoPrintOrder)
                                                        _showMyDialog(OrderModel
                                                            .pendingOrders[
                                                                index]
                                                            .orderId
                                                            .toString());
                                                    },
                                                    onLongPress: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OrderDetails(OrderModel
                                                                      .pendingOrders[
                                                                          index]
                                                                      .orderId)));
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
                                                                      .only(
                                                                  right: 8.0),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Icon(
                                                                  Icons
                                                                      .restaurant,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .deepOrange,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Static.displayOrderIdTable
                                                                        ? Text(
                                                                            '#${OrderModel.pendingOrders[index].orderId}',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                          )
                                                                        : Container(),
                                                                    Text(
                                                                      '${OrderModel.pendingOrders[index].customerName}',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    Text(
                                                                      '${OrderModel.pendingOrders[index].customerEmail}',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              12),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      '£${OrderModel.pendingOrders[index].total}',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .green,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      child:
                                                                          Text(
                                                                        OrderModel.pendingOrders[index].delColType ==
                                                                                1
                                                                            ? 'Delivery'
                                                                            : 'Collection',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .deepOrange,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              4),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            0,
                                                                        color: Colors
                                                                            .grey[300],
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              FittedBox(
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            child:
                                                                                Text(
                                                                              '${OrderModel.pendingOrders[index].deliveryTime}',
                                                                              style: TextStyle(color: Colors.black, fontSize: 12),
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                    OrderModel.acceptedOrders.length == 0
                                        ? isLoading
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                    CircularProgressIndicator(
                                                        color:
                                                            Colors.deepOrange)
                                                  ])
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.no_food,
                                                    size: 120,
                                                    color: Colors.grey[300],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'No orders found!',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              )
                                        : Column(
                                          children: [
                                            Container(

                                              color: Colors.green[50],
                                              child:Column(
                                                children: [
                                                   Center(child: Padding(
                                                    padding: const EdgeInsets.only(top:8.0),
                                                    child: Text(OrderModel.verticalGroupValue,style:TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold)),
                                                  ),),
                                                  OrderModel.verticalGroupValue=="Range"?Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text('$startDate - $endDate'),
                                                  ):SizedBox(),

                                                ],
                                              )
                                            ),
                                            Container(
                                              child: Center(

                                                child:Text.rich(
                                                    TextSpan(
                                                        text: 'Total Amount: ',
                                                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.green),
                                                        children: <InlineSpan>[
                                                          TextSpan(
                                                            text: '£',
                                                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.green),
                                                          ),
                                                          TextSpan(
                                                            text: OrderModel.acceptedOrderAmount.toStringAsFixed(2),
                                                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.green[800]),
                                                          )
                                                        ]
                                                    )
                                                ),


                                              ),
                                              height: 30,
                                              width: double.infinity,
                                              color: Colors.green[50],
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount: OrderModel
                                                      .acceptedOrders.length,
                                                  itemBuilder:
                                                      (BuildContext ctxt, int index) {
                                                    if (index >=
                                                        OrderModel
                                                            .acceptedOrders.length) {
                                                      return SizedBox();
                                                    }

                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    OrderDetails(OrderModel
                                                                        .acceptedOrders[
                                                                            index]
                                                                        .orderId)));
                                                      },
                                                      onLongPress: () {
                                                        _showMyDialogForDelete(
                                                            OrderModel
                                                                .acceptedOrders[index]
                                                                .orderId
                                                                .toString());
                                                      },
                                                      child: Card(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 8.0),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Icon(
                                                                      Icons
                                                                          .restaurant,
                                                                      size: 30,
                                                                      color: Colors
                                                                          .deepOrange,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Static.displayOrderIdTable
                                                                            ? Text(
                                                                                '#${OrderModel.acceptedOrders[index].orderId}',
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 18),
                                                                              )
                                                                            : Container(),
                                                                        Text(
                                                                          '${OrderModel.acceptedOrders[index].customerName}',
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .normal,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize:
                                                                                  14),
                                                                        ),
                                                                        Text(
                                                                          '${OrderModel.acceptedOrders[index].customerEmail}',
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .normal,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize:
                                                                                  12),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          '£${OrderModel.acceptedOrders[index].total}',
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .bold,
                                                                              color: Colors
                                                                                  .green,
                                                                              fontSize:
                                                                                  20),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(
                                                                                  4.0),
                                                                          child: Text(
                                                                            OrderModel.acceptedOrders[index].delColType ==
                                                                                    1
                                                                                ? 'Delivery'
                                                                                : 'Collection',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .deepOrange,
                                                                                fontSize:
                                                                                    14,
                                                                                fontWeight:
                                                                                    FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                        Card(
                                                                          elevation:
                                                                              0,
                                                                          color: Colors
                                                                                  .grey[
                                                                              300],
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(
                                                                                    4.0),
                                                                            child:
                                                                                Text(
                                                                              '${OrderModel.acceptedOrders[index].deliveryTime}',
                                                                              style: TextStyle(
                                                                                  color:
                                                                                      Colors.black,
                                                                                  fontSize: 12),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ),
                                    OrderModel.cancelledOrders.length == 0
                                        ? isLoading
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                    CircularProgressIndicator(
                                                        color:
                                                            Colors.deepOrange)
                                                  ])
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.no_food,
                                                    size: 120,
                                                    color: Colors.grey[300],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'No table booking found!',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              )
                                        : ListView.builder(
                                            itemCount: OrderModel
                                                .cancelledOrders.length,
                                            itemBuilder:
                                                (BuildContext ctxt, int index) {
                                              if (index >=
                                                  OrderModel
                                                      .cancelledOrders.length) {
                                                return SizedBox();
                                              }

                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OrderDetails(OrderModel
                                                                  .cancelledOrders[
                                                                      index]
                                                                  .orderId)));
                                                },
                                                child: Card(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Icon(
                                                                Icons
                                                                    .restaurant,
                                                                size: 30,
                                                                color: Colors
                                                                    .deepOrange,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Static.displayOrderIdTable
                                                                      ? Text(
                                                                          '#${OrderModel.cancelledOrders[index].orderId}',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 18),
                                                                        )
                                                                      : Container(),
                                                                  Text(
                                                                    '${OrderModel.cancelledOrders[index].customerName}',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                  Text(
                                                                    '${OrderModel.cancelledOrders[index].customerEmail}',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    '£${OrderModel.cancelledOrders[index].total}',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .green,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child: Text(
                                                                      OrderModel.cancelledOrders[index].delColType ==
                                                                              1
                                                                          ? 'Delivery'
                                                                          : 'Collection',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .deepOrange,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Card(
                                                                    elevation:
                                                                        0,
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      child:
                                                                          Text(
                                                                        '${OrderModel.cancelledOrders[index].deliveryTime}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                    if (Static.displayAwaitingNotPaidPayment)
                                      OrderModel.notpaidOrders.length == 0
                                          ? isLoading
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                      CircularProgressIndicator(
                                                          color:
                                                              Colors.deepOrange)
                                                    ])
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.no_food,
                                                      size: 120,
                                                      color: Colors.grey[300],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'No orders found!',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                )
                                          : ListView.builder(
                                              itemCount: OrderModel
                                                  .notpaidOrders.length,
                                              itemBuilder: (BuildContext ctxt,
                                                  int index) {
                                                if (index >
                                                    OrderModel
                                                        .notpaidOrders.length) {
                                                  return SizedBox();
                                                }

                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                OrderDetails(OrderModel
                                                                    .notpaidOrders[
                                                                        index]
                                                                    .orderId)));
                                                  },
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
                                                                  right: 8.0),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Icon(
                                                                  Icons
                                                                      .restaurant,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .deepOrange,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Static.displayOrderIdTable
                                                                        ? Text(
                                                                            '#${OrderModel.notpaidOrders[index].orderId}',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                          )
                                                                        : Container(),
                                                                    Text(
                                                                      '${OrderModel.notpaidOrders[index].customerName}',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    Text(
                                                                      '${OrderModel.notpaidOrders[index].customerEmail}',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              12),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      '£${OrderModel.notpaidOrders[index].total}',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .green,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      child:
                                                                          Text(
                                                                        OrderModel.notpaidOrders[index].delColType ==
                                                                                1
                                                                            ? 'Delivery'
                                                                            : 'Collection',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .deepOrange,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Card(
                                                                      elevation:
                                                                          0,
                                                                      color: Colors
                                                                              .grey[
                                                                          300],
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(4.0),
                                                                        child:
                                                                            Text(
                                                                          '${OrderModel.notpaidOrders[index].deliveryTime}',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 12),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              })
                                  ]))
                            ])),
                  ],
                ),
        ));
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

  Future<void> _showMyDialogForDelete(
    String id,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Column(
            children: [
              Text('Do you want to Delete?'),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Order Id- $id',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            ],
          )),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'skip',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
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
                          setState(() {
                            isLoadingOrder = true;
                          });
                          var result = await OrderModel.deleteOrder(id);

                          await _refreshData();
                          setState(() {
                            isLoadingOrder = false;
                          });
                          print('result OrderModel.deleteOrder--------$result');
                          if (result == 'success') {
                            Get.snackbar(
                              "Delete alert!",
                              "Order has been deleted",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red[300],
                              colorText: Colors.white,
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              duration: Duration(seconds: 5),
                            );

                            setState(() {
                              isLoadingOrder = false;
                            });
                          }
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RaisedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child:
                            Text('No', style: TextStyle(color: Colors.white)),
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMyDialog(
    String id,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Column(
            children: [
              Text('Add extra minutes!'),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Order Id- $id',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            ],
          )),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'skip',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: TextField(
                      onChanged: (String value) {
                        delayTIme = value;
                      },
                      cursorColor: Colors.deepOrange,
                      decoration: InputDecoration(
                          hintText: "extra minute",
                          labelText: "extra minute",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if (!Static.isBusy) {
                            Navigator.pop(context);
                            setState(() {
                              isLoadingOrder = true;
                            });
                            print(
                                'loadingOrder--------RaisedButton-------------$isLoadingOrder');
                            if (Provider.of<GlobalProvider>(context,
                                        listen: false)
                                    .getPrinterConnectionStatus &&
                                await bluetooth.isConnected) {
                              if (delayTIme.isEmpty) {
                                print('$delayTIme-----delayTime');
                                OrderDetailsModel.getOrderDetails(id)
                                    .then((value) => printOrderType(id));
                                if (!Static.enableDeveloperMode) {
                                  await OrderModel.changeStatus(id, '2');
                                } else {
                                  Get.snackbar(
                                    "Alert",
                                    "Developer mode is on,Order will not be accepted in this mode.",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.green[300],
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 5),
                                  );
                                }
                                await responseIntent();
                              } else {
                                OrderModel.addTimeDelay(id, delayTIme).then(
                                    (value) =>
                                        responseIntentDelayTime(id, value));
                              }
                            } else {
                              setState(() {
                                isLoadingOrder = false;
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
                              "Printer is busy",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green[300],
                              colorText: Colors.white,
                              duration: Duration(seconds: 5),
                            );
                          }
                        },
                        child: Text(
                          'Accept',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RaisedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          setState(() {
                            isLoadingOrder = true;
                          });
                          var result = await OrderModel.changeStatus(id, '3');
                          print(
                              'result OrderModel.changeStatus--------$result');
                          if (result == 'success') {
                            responseIntentCancel();
                          }
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
        );
      },
    );
  }

  responseIntent() async {
    print('loadingOrder--------responseIntent-------------$isLoadingOrder');
    if (Static.showOnlyCurrentDaysOrder) {
      await OrderModel.getAllOrders(1);
    } else {
      await OrderModel.getAllOrders(Static.typeLastOrder);
    }
    setState(() {
      isLoadingOrder = false;
    });
  }

  responseIntentDelayTime(String id, value) async {
    if (!Static.enableDeveloperMode) {
      await OrderModel.changeStatus(id, '2');
    }
    OrderDetailsModel.getOrderDetails(id).then((value) => printOrderType(id));
    if (Static.showOnlyCurrentDaysOrder) {
      await OrderModel.getAllOrders(1);
    } else {
      await OrderModel.getAllOrders(Static.typeLastOrder);
    }
    setState(() {
      isLoadingOrder = false;
    });
    print(
        'response accept_Table booking------------------------------------$value');
    if (value != 'failed') {}
  }

  responseIntentCancel() async {
    if (Static.showOnlyCurrentDaysOrder) {
      await OrderModel.getAllOrders(1);
    } else {
      await OrderModel.getAllOrders(2);
    }
    setState(() {
      isLoadingOrder = false;
    });
  }

  Future _refreshData() async {
    if (Static.showOnlyCurrentDaysOrder) {
      await OrderModel.getAllOrders(1);
    } else {
      await OrderModel.getAllOrders(Static.typeLastOrder);
    }
    setState(() {});
  }

  printOrderType(String id) async {
    if (Static.Paper_Size == "58mm") {
      await widget.globalPrinting.printOrder58(int.parse(id));
      await printKitchenReceipt(int.parse(id));
    } else if(Static.Paper_Size == "80mm"){
      await widget.globalPrinting.printOrder80(int.parse(id));
      await printKitchenReceipt(int.parse(id));
    }
    else{
      await widget.globalPrinting.printOrder80Large(int.parse(id));
      await printKitchenReceipt(int.parse(id));
    }
  }

  printKitchenReceipt(int id) async {
    print('printKitchenReceipt-------------------------');

    await Future.delayed(Duration(seconds: 2));
    widget.globalPrinting.printKitchenReceipt(id);
  }

  _writePrinterConnectionSound(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file =
        File("/data/user/0/uk.co.ordervox.merchant/files/printer.txt");
    await file.writeAsString(text);
    print('-----------------directory------${file.path}');
  }

  readDataFromFile() async {
    print('Static.NewId out----${Static.NewId}');

    if (!await bluetooth.isConnected) {
      _writePrinterConnectionSound("pcn");
      if (mounted) {
        Provider.of<GlobalProvider>(context, listen: false)
            .setPrinterConnectFalse();
      }
    } else {
      _writePrinterConnectionSound("pcy");
      if (mounted) {
        Provider.of<GlobalProvider>(context, listen: false)
            .setPrinterConnectTrue();
      }
    }

    if (Static.NewId == "1") {
      Static.NewId = "0";
      setState(() {
        isLoading = true;
      });

      print('Static.NewId----${Static.NewId}');

      if (Static.showOnlyCurrentDaysOrder) {
        OrderModel.getAllOrders(1).then((value) {
          setState(() {
            isLoading = false;
          });
        });
      } else {
        OrderModel.getAllOrders(2).then((value) {
          setState(() {
            isLoading = false;
          });
        });
      }
    }
  }

  Future _run() async {
    final isolate = await FlutterIsolate.spawn(timerForData(), "hello");
  }

  timerForData() {
    const oneSec = const Duration(seconds: 5);
    periodicTimer = Timer.periodic(oneSec, (Timer t) => readDataFromFile());
  }
}

class PeriodicRequester extends StatelessWidget {
  Stream<http.Response> getRandomNumberFact() async* {
    yield* Stream.periodic(Duration(seconds: 5), (_) {
      return _dataSearch(Static.typeLastOrder);
    }).asyncMap((event) async => await event);
  }

  Future _dataSearch(int val) async {
    // final overlay = LoadingOverlay.of(context);
    // await overlay.during(OrderModel.getAllOrders(val));
    OrderModel.getAllOrders(val).then((value) {
      print(
          'pendingOrders stream-----------------------------${OrderModel.pendingOrders.length}');
      // setState(() {
      //   isLoading = false;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<http.Response>(
      stream: getRandomNumberFact(),
      builder: (context, snapshot) => snapshot.hasData
          ? Center(child: Text(snapshot.data.body))
          : CircularProgressIndicator(color: Colors.deepOrange),
    );
  }
}
