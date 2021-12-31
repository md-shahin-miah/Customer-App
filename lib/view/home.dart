import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:blue/global/constant.dart';
import 'package:blue/model/home_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  final HomeModel model = HomeModel();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AppLifecycleState _notification;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    var dayCash = selectedDatum[0].datum.day;
    var numberCash = selectedDatum[0].datum.number;

    var numberOnline = selectedDatum[1].datum.number;
    showInSnackBar(dayCash, numberCash, numberOnline);
  }

  void showInSnackBar(day, numCash, numOnline) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text(
            '$day\nNumbers of Cash: $numCash\nNumbers of Online: $numOnline')));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);
    if (widget.model.barChartGraphData.isEmpty) {
      if (Api.businessBaseUrl == '') {
        SharedPreferences.getInstance().then((prefs) {
          String domain = prefs.getString('domain') ?? '-1';
          if (domain != '-1') {
            Api.businessBaseUrl = 'https://$domain/api/Merchant/';
            widget.model.getRestaurantSettings().then((value) {

              // player.clearCache();
              if (mounted) {
                setState(() {});
              }
            });
          }
        });
      } else {
        widget.model.getRestaurantSettings().then((value) {
          if (mounted) {
            setState(() {});
          }
        });
      }
    } else {
      print('data found');
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widgetOrderAmounts = Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 4.0),
                      child: Text(
                        'Today',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 16.0),
                      child: Text(
                        '\£${widget.model.todayIncome}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 4.0),
                      child: Text(
                        'Last 7 days',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 16.0),
                      child: Text(
                        '\£${widget.model.oneWeekIncome}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 4.0),
                      child: FittedBox(
                        child: Text(
                          'Last 30 days',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 16.0),
                      child: FittedBox(
                        child: Text(
                          '\£${widget.model.oneMonthIncome}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final widgetOrderSummary = Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Color(0xffe7f1fa),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0.0),
                            child: Column(
                              children: [
                                Text(
                                  '${widget.model.pendingOrder}',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Text(
                                  'Pending',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  width: double.infinity,
                                  color: Colors.blue,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      '£ ${widget.model.pendingOrderAmount}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Color(0xffe5f3e5),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0.0),
                            child: Column(
                              children: [
                                Text(
                                  '${widget.model.acceptedOrder}',
                                  style: TextStyle(
                                      color: MyColors.colorAccepted,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Text(
                                  'Accepted',
                                  style: TextStyle(
                                      color: MyColors.colorAccepted,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  width: double.infinity,
                                  color: MyColors.colorAccepted,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      '£ ${widget.model.acceptedOrderAmount}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Color(0xfffae5e5),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0.0),
                            child: Column(
                              children: [
                                Text(
                                  '${widget.model.cancelledOrder}',
                                  style: TextStyle(
                                      color: MyColors.colorCancelled,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                FittedBox(
                                  child: Text(
                                    'Cancelled',
                                    style: TextStyle(
                                        color: MyColors.colorCancelled,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  width: double.infinity,
                                  color: MyColors.colorCancelled,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      '£ ${widget.model.cancelledOrder}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Static.displayAwaitingNotPaidPayment?Expanded(
                    child: Card(
                      color: Color(0xffe5f3f3),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0.0),
                            child: Column(
                              children: [
                                Text(
                                  '${widget.model.notPaidOrder}',
                                  style: TextStyle(
                                      color: MyColors.colorNotPaid,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Text(
                                  'Not paid',
                                  style: TextStyle(
                                      color: MyColors.colorNotPaid,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  width: double.infinity,
                                  color: MyColors.colorNotPaid,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      '£ ${widget.model.notPaidOrderAmount}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ):SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text('OrderE - Merchant'),
      // ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        backgroundColor: Colors.deepOrange,
        color: Colors.white,
        displacement: 150,
        strokeWidth: 4,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [
                widgetOrderAmounts,
                widgetOrderSummary,
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0),
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Online-Cash',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      widget.model.barChartGraphData.length <= 0
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Container(
                                            width: 30,
                                            height: 120,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 30,
                                            height: 130,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 150,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 150,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 150,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Container(
                                            width: 30,
                                            height: 100,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 150,
                                        color: Colors.white,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(left: 12),
                              height: 200,
                              width: double.infinity,
                              child: charts.BarChart(
                                widget.model.barChartGraphData,
                                animate: true,
                                barGroupingType: charts.BarGroupingType.stacked,
                                selectionModels: [
                                  new charts.SelectionModelConfig(
                                    type: charts.SelectionModelType.info,
                                    changedListener: _onSelectionChanged,
                                  )
                                ],
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: Color(0xfffa8128),
                              height: 16,
                              width: 40,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Cash'),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              color: Color(0xff2e5468),
                              height: 16,
                              width: 40,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Online'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8,top: 8,bottom: 16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                              width: double.infinity,
                              child: Center(
                                  child: Text('Delivery Collecetion',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                                  child: Column(
                                    children: [
                                      PieChart(
                                        dataMap: widget.model.todayDelCol,
                                        animationDuration:
                                            Duration(milliseconds: 800),
                                        chartLegendSpacing: 32,
                                        chartRadius:
                                            MediaQuery.of(context).size.width /
                                                3.2,
                                        colorList: [Colors.red, Colors.blue],
                                        initialAngleInDegree: 0,
                                        chartType: ChartType.ring,
                                        ringStrokeWidth: 32,
                                        centerText: "Today",
                                        legendOptions: LegendOptions(
                                          showLegendsInRow: false,
                                          legendPosition: LegendPosition.bottom,
                                          showLegends: true,
                                          legendTextStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        chartValuesOptions: ChartValuesOptions(
                                          showChartValueBackground: true,
                                          showChartValues: true,
                                          showChartValuesInPercentage: false,
                                          showChartValuesOutside: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.grey[200],
                                height: 200,
                                width: 1,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                                  child: Column(
                                    children: [
                                      PieChart(
                                        dataMap: widget.model.weekDelCol,
                                        animationDuration:
                                            Duration(milliseconds: 800),
                                        chartLegendSpacing: 32,
                                        chartRadius:
                                            MediaQuery.of(context).size.width /
                                                3.2,
                                        colorList: [Colors.red, Colors.blue],
                                        initialAngleInDegree: 0,
                                        chartType: ChartType.ring,
                                        ringStrokeWidth: 32,
                                        centerText: "This week",
                                        legendOptions: LegendOptions(
                                          showLegendsInRow: false,
                                          legendPosition: LegendPosition.bottom,
                                          showLegends: true,
                                          legendTextStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        chartValuesOptions: ChartValuesOptions(
                                          showChartValueBackground: true,
                                          showChartValues: true,
                                          showChartValuesInPercentage: false,
                                          showChartValuesOutside: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _refreshData() async {
    await widget.model.getRestaurantSettings();
    setState(() {});
  }

}
