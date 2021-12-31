import 'dart:io';

import 'package:blue/main.dart';
import 'package:blue/model/auth.dart';
import 'package:blue/schedule/schedulemain.dart';
import 'package:blue/view/DeliveryCollectionTimeLimit.dart';
import 'package:blue/view/printer_credential.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:blue/global/constant.dart';
import 'package:blue/model/home_model.dart';
import 'package:blue/view/loader.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global_provider.dart';
import 'del_col_setting.dart';
import 'login_page.dart';

class SettingPage extends StatefulWidget {
  final HomeModel model = HomeModel();

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String packageName = '';
  int pincodeMatched = 0;
  String userInput = '';
  String password;

  bool logoutIndicator=false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool askForPass = true;

  @override
  void initState() {
    // TODO: implement initState
    SharedPreferences.getInstance().then((prefs) {
      Static.BusinessName = prefs.getString("BusinessName") ?? 'No name';

      setState(() {
        password = prefs.getString("password") ?? "";
        askForPass = prefs.getBool("askForPass"+"${Api.businessBaseUrl}") ?? true;

      });

    });
    getPackage();

    super.initState();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // void _checkPrinterStatus(context, status) {
  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(8))),
  //             title: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text('Printer status'),
  //                 IconButton(
  //                   color: Colors.red,
  //                   icon: Icon(Icons.close),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                 )
  //               ],
  //             ),
  //             content: status == true
  //                 ? Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.only(bottom: 12.0),
  //                         child: SvgPicture.asset(
  //                           'assets/icons/printer_connected.svg',
  //                           height: 50,
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(bottom: 12.0),
  //                         child: Text(
  //                           'Printer is connected!',
  //                           style: TextStyle(fontWeight: FontWeight.bold),
  //                         ),
  //                       )
  //                     ],
  //                   )
  //                 : Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.only(bottom: 12.0),
  //                         child: SvgPicture.asset(
  //                           'assets/icons/printer_disconnected.svg',
  //                           height: 50,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         width: 12,
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(bottom: 12.0),
  //                         child: Text(
  //                           'Printer is disconnected!',
  //                           style: TextStyle(fontWeight: FontWeight.bold),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    print('online order status');
    print(HomeModel.isOnlineOrderOn);
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text('OrderE - Merchant'),
      //   //     actions: <Widget>[
      //   //   PopupMenuButton<String>(
      //   //     onSelected: choiceAction,
      //   //     itemBuilder: (BuildContext context) {
      //   //       return ['Privacy policy', 'Logout', 'Credential']
      //   //           .map((String choice) {
      //   //         return PopupMenuItem<String>(
      //   //           value: choice,
      //   //           child: Text(choice),
      //   //         );
      //   //       }).toList();
      //   //     },
      //   //   )
      //   // ]),
      // ),
      body:
          // !HomeModel.isSettingLoaded
          //     ? Center(
          // //         child: CircularProgressIndicator(
          //              color:Colors.deepOrange
          //             ),
          // //       )
          //     :

          Stack(
        children: [
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: ListTile(
                    leading: Icon(
                      Icons.home_work,
                      size: 32,
                      color: Colors.deepOrange,
                    ),
                    title: Text(
                      '${Static.BusinessName}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                    subtitle: Text(
                      '${Api.BusinessUrl}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    // trailing: IconButton(
                    //   icon: Icon(Icons.add),
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (_) => PrinterCredential()));
                    //   },
                    // )
                  ),
                ),
              ),

              !HomeModel.isSettingLoaded
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child:
                            CircularProgressIndicator(color: Colors.deepOrange),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                HomeModel.isOnlineOrderOn
                                    ? 'Live mode'
                                    : 'Maintenance mode',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HomeModel.isOnlineOrderOn
                                        ? Colors.black
                                        : MyColors.colorFadeIcon),
                              ),
                            ),
                            subtitle: HomeModel.isOnlineOrderOn
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4.0, 0, 8),
                                    child: Text(
                                        'Your website/app is in Live mode.'),
                                  )
                                : Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4.0, 0, 8),
                                    child: Text(
                                        'Customer will not able to place any order.'),
                                  ),
                            trailing: Switch(
                                value: HomeModel.isOnlineOrderOn,
                                activeColor: MyColors.colorActiveSwitch,
                                onChanged: (val) async {
                                  bool pervState = HomeModel.isOnlineOrderOn;
                                  setState(() {
                                    HomeModel.isOnlineOrderOn = val;
                                  });
                                  var status = val ? "yes" : "no";
                                  final overlay = LoadingOverlay.of(context);
                                  final response = await overlay.during(widget
                                      .model
                                      .setStatus(Api.KEY_ONLINE_ORDER, status));

                                  if (response == 'success') {
                                    setState(() {
                                      HomeModel.isOnlineOrderOn = val;
                                    });
                                  } else {
                                    setState(() {
                                      HomeModel.isOnlineOrderOn = pervState;
                                    });
                                  }
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: SvgPicture.asset(
                                      'assets/icons/table_booking.svg',
                                      height: 45,
                                      width: 45,
                                      color: HomeModel.isOnlineOrderOn
                                          ? HomeModel.isTableBookingOn
                                              ? MyColors.colorActiveIcon
                                              : MyColors.colorFadeIcon
                                          : MyColors.colorFadeIcon,
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Table booking',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: HomeModel.isOnlineOrderOn
                                                ? HomeModel.isTableBookingOn
                                                    ? Colors.black
                                                    : MyColors.colorFadeIcon
                                                : MyColors.colorFadeIcon),
                                      ),
                                    ),
                                    subtitle: HomeModel.isTableBookingOn
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 4.0, 0, 8),
                                            child: Text(
                                                'Table booking from your website/app is enabled.'),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 4.0, 0, 8),
                                            child: Text(
                                                'Table booking from your website/app is disabled.'),
                                          ),
                                    trailing: HomeModel.isOnlineOrderOn
                                        ? Switch(
                                            activeColor:
                                                MyColors.colorActiveSwitch,
                                            value: HomeModel.isTableBookingOn,
                                            onChanged: (val) async {
                                              bool pervState =
                                                  HomeModel.isTableBookingOn;
                                              setState(() {
                                                HomeModel.isTableBookingOn =
                                                    val;
                                              });
                                              var status = val ? '1' : '0';
                                              final overlay =
                                                  LoadingOverlay.of(context);
                                              final response =
                                                  await overlay.during(
                                                      widget.model.setStatus(
                                                          Api.KEY_TABLE_BOOKING,
                                                          status));

                                              print(response);
                                              if (response == 'success') {
                                                setState(() {
                                                  HomeModel.isTableBookingOn =
                                                      val;
                                                });
                                              } else {
                                                setState(() {
                                                  HomeModel.isTableBookingOn =
                                                      pervState;
                                                });
                                              }
                                            })
                                        : SizedBox(),
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: SvgPicture.asset(
                                      'assets/icons/delivery.svg',
                                      color: HomeModel.isOnlineOrderOn
                                          ? HomeModel.isDeliveryOn
                                              ? MyColors.colorActiveIcon
                                              : MyColors.colorFadeIcon
                                          : MyColors.colorFadeIcon,
                                      height: 35,
                                      width: 40,
                                    ),
                                    title: Text(
                                      'Delivery',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: HomeModel.isOnlineOrderOn
                                              ? HomeModel.isDeliveryOn
                                                  ? Colors.black
                                                  : MyColors.colorFadeIcon
                                              : MyColors.colorFadeIcon),
                                    ),
                                    subtitle: HomeModel.isDeliveryOn
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 4.0, 0, 8),
                                            child: Text(
                                                'Delivery order from website/app is enabled.'),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 4.0, 0, 8),
                                            child: Text(
                                                'Delivery order from your website/app is disabled.'),
                                          ),
                                    trailing: HomeModel.isOnlineOrderOn
                                        ? Switch(
                                            activeColor:
                                                MyColors.colorActiveSwitch,
                                            value: HomeModel.isDeliveryOn,
                                            onChanged: (val) async {
                                              bool pervState =
                                                  HomeModel.isCollectionOn;
                                              setState(() {
                                                HomeModel.isCollectionOn = val;
                                              });

                                              var status;
                                              if (HomeModel.isCollectionOn ==
                                                      true &&
                                                  val == true) {
                                                status = '0';
                                              } else if (HomeModel
                                                          .isCollectionOn ==
                                                      false &&
                                                  val == true) {
                                                status = '1';
                                              } else if (HomeModel
                                                          .isCollectionOn ==
                                                      true &&
                                                  val == false) {
                                                status = '2';
                                              } else if (HomeModel
                                                          .isCollectionOn ==
                                                      false &&
                                                  val == false) {
                                                status = '2';
                                                HomeModel.isCollectionOn = true;
                                              }

                                              print('status $status');
                                              final overlay =
                                                  LoadingOverlay.of(context);
                                              final response =
                                                  await overlay.during(
                                                      widget.model.setStatus(
                                                          Api.KEY_DEL_COL,
                                                          status));

                                              if (response == 'success') {
                                                setState(() {
                                                  HomeModel.isDeliveryOn = val;
                                                });
                                              } else {
                                                setState(() {
                                                  HomeModel.isDeliveryOn =
                                                      pervState;
                                                });
                                              }
                                            })
                                        : SizedBox(),
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: SvgPicture.asset(
                                      'assets/icons/collection.svg',
                                      color: HomeModel.isOnlineOrderOn
                                          ? HomeModel.isCollectionOn
                                              ? MyColors.colorActiveIcon
                                              : MyColors.colorFadeIcon
                                          : MyColors.colorFadeIcon,
                                      height: 45,
                                      width: 45,
                                    ),
                                    title: Text(
                                      'Collection',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: HomeModel.isOnlineOrderOn
                                              ? HomeModel.isCollectionOn
                                                  ? Colors.black
                                                  : MyColors.colorFadeIcon
                                              : MyColors.colorFadeIcon),
                                    ),
                                    subtitle: HomeModel.isCollectionOn
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 4.0, 0, 8),
                                            child: Text(
                                                'Collection order from website/app is enabled.'),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 4.0, 0, 8),
                                            child: Text(
                                                'Collection order from your website/app is disabled.'),
                                          ),
                                    trailing: HomeModel.isOnlineOrderOn
                                        ? Switch(
                                            activeColor:
                                                MyColors.colorActiveSwitch,
                                            value: HomeModel.isCollectionOn,
                                            onChanged: (val) async {
                                              bool prevState =
                                                  HomeModel.isCollectionOn;
                                              setState(() {
                                                HomeModel.isCollectionOn = val;
                                              });
                                              var status;
                                              if (HomeModel.isDeliveryOn ==
                                                      true &&
                                                  val == true) {
                                                status = '0';
                                              } else if (HomeModel
                                                          .isDeliveryOn ==
                                                      false &&
                                                  val == true) {
                                                status = '2';
                                              } else if (HomeModel
                                                          .isDeliveryOn ==
                                                      true &&
                                                  val == false) {
                                                status = '1';
                                              } else if (HomeModel
                                                          .isDeliveryOn ==
                                                      false &&
                                                  val == false) {
                                                status = '1';
                                                HomeModel.isDeliveryOn = true;
                                              }
                                              final overlay =
                                                  LoadingOverlay.of(context);
                                              final response =
                                                  await overlay.during(
                                                      widget.model.setStatus(
                                                          Api.KEY_DEL_COL,
                                                          status));

                                              if (response == 'success') {
                                                setState(() {
                                                  HomeModel.isCollectionOn =
                                                      val;
                                                });
                                              } else {
                                                setState(() {
                                                  HomeModel.isCollectionOn =
                                                      prevState;
                                                });
                                              }
                                            })
                                        : SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

              //   Container(
              //     margin: EdgeInsets.only(left: 16, right: 16),
              //     decoration: BoxDecoration(
              //       color: Colors.grey[50],
              //       borderRadius: BorderRadius.only(
              //           topLeft: Radius.circular(4),
              //           topRight: Radius.circular(4),
              //           bottomLeft: Radius.circular(4),
              //           bottomRight: Radius.circular(4)),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.grey.withOpacity(0.4),
              //           spreadRadius: 2,
              //           blurRadius: 2,
              //           offset: Offset(0, 0), // changes position of shadow
              //         ),
              //       ],
              //     ),
              //     child: ListTile(
              //         leading: SvgPicture.asset('assets/icons/eatin.svg',
              //             height: 45,
              //             width: 45,
              //             color: widget.model.isEatOn
              //                 ? MyColors.colorActiveIcon
              //                 : MyColors.colorFadeIcon),
              //         title: Padding(
              //           padding: const EdgeInsets.only(top: 8.0),
              //           child: Text(
              //             'Eat-in',
              //             style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 color: widget.model.isEatOn
              //                     ? Colors.black
              //                     : MyColors.colorFadeIcon),
              //           ),
              //         ),
              //         subtitle: HomeModel.isTableBookingOn
              //             ? Padding(
              //                 padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 8),
              //                 child: Text('Eat-in from your website/app is enabled.'),
              //               )
              //             : Padding(
              //                 padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 8),
              //                 child:
              //                     Text('Eat-in from your website/app is disabled.'),
              //               ),
              //         trailing: Switch(
              //             activeColor: MyColors.colorActiveSwitch,
              //             value: widget.model.isEatOn,
              //             onChanged: (val) async {
              //               bool pervState = widget.model.isEatOn;
              //               setState(() {
              //                 widget.model.isEatOn = val;
              //               });
              //               var status = val ? '1' : '0';
              //               final overlay = LoadingOverlay.of(context);
              //               final response = await overlay.during(widget.model
              //                   .setStatus(Api.KEY_TABLE_BOOKING, status));

              //               print(response);
              //               if (response == 'success') {
              //                 setState(() {
              //                   widget.model.isEatOn = val;
              //                 });
              //               } else {
              //                 setState(() {
              //                   widget.model.isEatOn = pervState;
              //                 });
              //               }
              //             })),
              //   ),
              //   Container(
              //     margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              //     decoration: BoxDecoration(
              //       color: Colors.grey[50],
              //       borderRadius: BorderRadius.only(
              //           topLeft: Radius.circular(4),
              //           topRight: Radius.circular(4),
              //           bottomLeft: Radius.circular(4),
              //           bottomRight: Radius.circular(4)),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.grey.withOpacity(0.4),
              //           spreadRadius: 2,
              //           blurRadius: 2,
              //           offset: Offset(0, 0), // changes position of shadow
              //         ),
              //       ],
              //     ),
              //     child: GestureDetector(
              //       onTap: () {
              //         _checkPrinterStatus(context, true);
              //       },
              //       child: ListTile(
              //           leading: SvgPicture.asset('assets/icons/printer.svg',
              //               height: 35, width: 35, color: Colors.black),
              //           title: Padding(
              //             padding: const EdgeInsets.only(top: 8.0),
              //             child: Text(
              //               'Printer status',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.bold, color: Colors.black),
              //             ),
              //           ),
              //           subtitle: Padding(
              //             padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 8),
              //             child: Text('Check printer status'),
              //           )),
              //     ),
              //   ),

              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Card(
                  child: ListTile(
                    // leading: Icon(
                    //   Icons.access_time,
                    //   size: 32,
                    //   color: Colors.deepOrange,
                    // ),
                    title: Text(
                      'Ask for Password every time',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    trailing: Switch(
                        value: askForPass,
                        activeColor: MyColors.colorActiveSwitch,
                        onChanged: (val) async {
                          setState(() {
                            askForPass = val;

                            SharedPreferences.getInstance().then((pref) {
                              pref.setBool("askForPass"+"${Api.businessBaseUrl}", val);
                            });
                          });
                          print('switch val: $val');
                        }),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Card(
                  child: ListTile(
                      leading: Icon(
                        Icons.access_time,
                        size: 32,
                        color: Colors.deepOrange,
                      ),
                      title: Text(
                        'Delivery Collection Time Limit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      DeliveryCollectionTimeLimit()));
                        },
                      )),
                ),
              ),

              !HomeModel.isSettingLoaded
                  ? Center(
                      child: Container(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Card(
                        child: ListTile(
                            leading: Icon(
                              Icons.access_time,
                              size: 32,
                              color: Colors.deepOrange,
                            ),
                            title: Text(
                              'Delivery Collection Time Setting',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            DeliveryCollectionSetting()));
                              },
                            )),
                      ),
                    ),
              Container(
                margin: EdgeInsets.only(bottom: 0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Card(
                    child: ListTile(
                        leading: Icon(
                          Icons.date_range,
                          size: 32,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          'Schedule Setting',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SchedulePage()));
                          },
                        )),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PrinterCredential()));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.print_outlined,
                          size: 32,
                          color: Colors.deepOrange,
                        ),
                        title: Text(
                          'Printer settings',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        // trailing: IconButton(
                        //   icon: Icon(Icons.add),
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (_) => PrinterCredential()));
                        //   },
                        // )
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Others',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // InkWell(
                      //   onTap: () async {
                      //     final overlay = LoadingOverlay.of(context);
                      //     final response =
                      //         await overlay.during(Auth.updateApp());
                      //     print(
                      //         'response Update----------------------------------------$response');
                      //
                      //     if (response != "no") {
                      //       appUpdate(response);
                      //     } else {
                      //       _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      //           content: Text('No update is available')));
                      //     }
                      //
                      //     // _showMyDialog(10000);
                      //   },
                      //   child: Container(
                      //     margin: EdgeInsets.only(bottom: 5),
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(left: 8, right: 8),
                      //       child: ListTile(
                      //         leading: Icon(
                      //           Icons.download_outlined,
                      //           size: 32,
                      //           color: Colors.deepOrange,
                      //         ),
                      //         title: Text(
                      //           'Update App',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.black),
                      //         ),
                      //         // trailing: IconButton(
                      //         //   icon: Icon(Icons.add),
                      //         //   onPressed: () {
                      //         //     Navigator.push(
                      //         //         context,
                      //         //         MaterialPageRoute(
                      //         //             builder: (_) => PrinterCredential()));
                      //         //   },
                      //         // )
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   height: 0.5,
                      //   color: Colors.grey,
                      // ),
                      InkWell(
                        onTap: () {
                          privacyPolicy();
                          // _showMyDialog(10000);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: ListTile(
                              leading: Icon(
                                Icons.privacy_tip_outlined,
                                size: 32,
                                color: Colors.deepOrange,
                              ),
                              title: Text(
                                'Privacy policy',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              // trailing: IconButton(
                              //   icon: Icon(Icons.add),
                              //   onPressed: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (_) => PrinterCredential()));
                              //   },
                              // )
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.grey,
                      ),
                      InkWell(
                        onTap: () {
                          FlutterRestart.restartApp();
                          // _showMyDialog(10000);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: ListTile(
                              leading: Icon(
                                Icons.restart_alt_rounded,
                                size: 32,
                                color: Colors.deepOrange,
                              ),
                              title: Text(
                                'Restart App',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              // trailing: IconButton(
                              //   icon: Icon(Icons.add),
                              //   onPressed: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (_) => PrinterCredential()));
                              //   },
                              // )
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.grey,
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            logoutIndicator=true;
                          });
                          // await Future.delayed(Duration(seconds: 2));
                          logOut();

                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: ListTile(
                              leading: Icon(
                                Icons.logout,
                                size: 32,
                                color: Colors.deepOrange,
                              ),
                              title: Text(
                                'Log out',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              // trailing: IconButton(
                              //   icon: Icon(Icons.add),
                              //   onPressed: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (_) => PrinterCredential()));
                              //   },
                              // )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Version code $packageName'),
                ],
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
          if (askForPass)
            if (pincodeMatched == 0)
              Container(
                child: InkWell(
                  onTap: () {
                    _showMyDialog();
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),

          if(logoutIndicator)
            Center(
              child: Container(
                color: Colors.white,
                alignment:Alignment.center,
                  child: CircularProgressIndicator(color: Colors.red,)),
            ),

        ],
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Static.privacyPolicy) {
      privacyPolicy();
    } else if (choice == Static.logOut) {
      logOut();
    } else if (choice == 'Credential') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => PrinterCredential()));
    }
    // else if(choice == Constants.SignOut){
    //   print('SignOut');
    // }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Column(
            children: [
              Text('Enter your password'),
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: TextField(
                      onChanged: (String value) {
                        userInput = value;
                      },
                      cursorColor: Colors.deepOrange,
                      decoration: InputDecoration(
                          hintText: "password",
                          labelText: "password",
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
                          FocusScope.of(context).requestFocus(FocusNode());

                          passwordMatch();
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
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

  void logOut() async {
    const MethodChannel methodChannel =
        MethodChannel('samples.flutter.io/battery');

    await _firebaseMessaging.unsubscribeFromTopic(Api.BusinessUrl);
    Static.IsLoggedOut = "1";
    setIsFirstTime();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('logged', 0);
    await prefs.setString('printer_address', '-1');
    await prefs.setString('domain', '-1');
    await prefs.setString('BusinessName', 'No Name');
    // Provider.of<GlobalProvider>(context, listen: false)
    //     .setPrinterConnectFalse();
    methodChannel.invokeMethod('getPendingOrders', {'domain': ''});

    await saveToPref();
    setState(() {
      logoutIndicator=false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginPage()));
  }
  void setIsFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('isFirst'+'${Api.businessBaseUrl}', 0);
  }

  void privacyPolicy() {
    _launchURL('https://ordervox.co.uk/index.php/privacy-policy');
  }

  void appUpdate(response) {
    _launchURL(response);
  }

  _writePrinterConnectionSound(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file =
        File('/data/user/0/uk.co.ordervox.merchant/files/printer.txt');
    await file.writeAsString(text);
    print('-----------------directory----${directory.path}/printer.txt');
  }

  _writeAwaitingSound(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file =
        File('/data/user/0/uk.co.ordervox.merchant/files/awaiting.txt');
    await file.writeAsString(text);
  }

  _writeAwaitingSoundStopForServer(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file =
        File('/data/user/0/uk.co.ordervox.merchant/files/server.txt');
    await file.writeAsString(text);
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future saveToPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('enablePendingOrderSound', true);
    // await prefs.setBool('hideRestaurantAddressOnReceipt', false);
    // await prefs.setBool('displayOrderIdTable', true);
    // await prefs.setBool('autoPrintTableBookingReceipt', false);
    // await prefs.setBool('autoPrintOrder', true);
    // await prefs.setBool('showOnlyCurrentDaysOrder', false);
    // await prefs.setBool('kitchenReceiptDefault', true);
    // await prefs.setBool('kitchenReceiptSameAsFront', false);
    // await prefs.setBool('displayOrderIdInReceipt', true);
    // await prefs.setBool('displayAwaitingNotPaidPayment', false);
    // await prefs.setBool('enableAwaitingNotPaidPaymentSound', false);
    //
    // await prefs.setString('Unconfirmed_payment_button_Value', 'Awaiting');
    // await prefs.setString('Number_of_front_receipt_Value', 'One');
    // await prefs.setString('Number_of_kitchen_receipt_Value', 'One');
    // await prefs.setString('Pending_order_sound_length_value', 'Long');
    // await prefs.setBool('enableDeveloperMode', false);
    //
    // await prefs.setString('Paper_size', '80mm');
    // await prefs.setString('AutoCutter', 'No');
    // SharedPreferences prefs =
    // await SharedPreferences.getInstance();
    await prefs.setString('device_name', "");
    await prefs.setString('device_address', "");
    await prefs.setInt('device_type', 0);
  }

  Future<void> getPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      packageName = packageInfo.version;
    });
  }

  void passwordMatch() {
    Navigator.pop(context);

    if (password.isNotEmpty && userInput.isNotEmpty) {
      print('password if--------------------------$password $userInput ');
      if (password == userInput) {
        setState(() {
          pincodeMatched = 1;
          print(
              'password if--------------------------$password $userInput $pincodeMatched');
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text(
                'Your password is not matched,please try again with correct one')));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.red,
          content: new Text('Your are trying with empty password')));
      print(
          'password else--------------------------$password $userInput $pincodeMatched');
    }
  }

// Future<void> _showMyDialog(int id) async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//
//           children: [
//           Text(
//             'Order ID : ',
//             style: TextStyle(fontWeight: FontWeight.w400),
//
//           ),
//           SizedBox(height: 10,),
//           Text(
//             '$id',
//             style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
//           ),
//         ],),
//
//         ],)
//         ,
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               Text(
//                 'Do you want to print a Kitchen  Receipt?',
//                 style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,),
//               ),
//               // Text(''),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               primary: Colors.red, // background
//               onPrimary: Colors.white, // foreground
//             ),
//             child: Text('Print'),
//             onPressed: () {
//               print('-------------------printKitchenReceipt trigerred--------------$id');
//               // globalPrinting.printKitchenReceipt(id);
//               // Static.orderIdListKitchenReceipt.add(id);
//               // Static.isPopUpOn=false;
//               // Navigator.pop(context);
//
//
//             },
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               primary: Colors.green, // background
//               onPrimary: Colors.white, // foreground
//             ),
//             child: Text('No'),
//             onPressed: () {
//               Navigator.pop(context);
//               Static.orderIdListKitchenReceipt.add(id);
//               Static.isPopUpOn=false;
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

}
