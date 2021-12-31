import 'package:blue/main.dart';
import 'package:blue/model/settings_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_provider.dart';
import 'package:blue/global/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

import 'printer_home.dart';

class PrinterCredential extends StatefulWidget {
  static final String path = "lib/src/pages/settings/settings3.dart";

  @override
  _PrinterCredentialState createState() => _PrinterCredentialState();
}

class _PrinterCredentialState extends State<PrinterCredential> {
  final TextStyle headerStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.normal,
    fontSize: 18.0,
  );

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  int isFirstTimeLog = 0;
  bool isLoading = true;
  bool enablePendingOrderSound = false;
  bool hideRestaurantAddressOnReceipt = false;
  bool displayOrderIdTable = false;
  bool autoPrintTableBookingReceipt = false;
  bool autoPrintOrder = true;
  bool showOnlyCurrentDaysOrder = false;
  bool kitchenReceiptDefault = false;
  bool kitchenReceiptSameAsFront = false;
  bool displayOrderIdInReceipt = true;
  bool displayAwaitingNotPaidPayment = false;
  bool enableAwaitingNotPaidPaymentSound = false;
  bool enableDeveloperMode = false;
  bool autoAcceptedTableBooking = false;

  String autoAcceptedTableBookingData = "";
  String version = "";

  // ignore: non_constant_identifier_names
  String Unconfirmed_payment_button_Value = 'Awaiting';
  String Paper_Size = '80mm';
  String AutoCutter = 'No';

  // ignore: non_constant_identifier_names
  String Number_of_front_receipt_Value = 'One';

  // ignore: non_constant_identifier_names
  String Number_of_kitchen_receipt_Value = 'One';

  // ignore: non_constant_identifier_names
  String Pending_order_sound_length_value = 'Long';
  var textStyle = 'Unconfirmed payment button';

  var isFirstTIme = 0;

  // Future saveToPref() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('enablePendingOrderSound', enablePendingOrderSound);
  //   await prefs.setBool(
  //       'hideRestaurantAddressOnReceipt', hideRestaurantAddressOnReceipt);
  //   await prefs.setBool('displayOrderIdTable', displayOrderIdTable);
  //   await prefs.setBool(
  //       'autoPrintTableBookingReceipt', autoPrintTableBookingReceipt);
  //   await prefs.setBool('autoPrintOrder', autoPrintOrder);
  //   await prefs.setBool('showOnlyCurrentDaysOrder', showOnlyCurrentDaysOrder);
  //   await prefs.setBool('kitchenReceiptDefault', kitchenReceiptDefault);
  //   await prefs.setBool('kitchenReceiptSameAsFront', kitchenReceiptSameAsFront);
  //   await prefs.setBool('displayOrderIdInReceipt', displayOrderIdInReceipt);
  //   await prefs.setBool(
  //       'displayAwaitingNotPaidPayment', displayAwaitingNotPaidPayment);
  //   await prefs.setBool(
  //       'enableAwaitingNotPaidPaymentSound', enableAwaitingNotPaidPaymentSound);
  //   await prefs.setBool('enableDeveloperMode', enableDeveloperMode);
  //
  //   await prefs.setString(
  //       'Unconfirmed_payment_button_Value', Unconfirmed_payment_button_Value);
  //   await prefs.setString(
  //       'Number_of_front_receipt_Value', Number_of_front_receipt_Value);
  //   await prefs.setString(
  //       'Number_of_kitchen_receipt_Value', Number_of_kitchen_receipt_Value);
  //   await prefs.setString(
  //       'Pending_order_sound_length_value', Pending_order_sound_length_value);
  //   await prefs.setString('Paper_size', Paper_Size);
  //   await prefs.setString('AutoCutter', AutoCutter);
  //   await prefs.setInt('isfirst', 2);
  // }
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getIsFirstTime();

    // isLoading=true;

    //
    // SettingsModel settingsModel = SettingsModel();

    getPackage();

    SettingsModel.getSettings().then((value) {
      print('value from get Settings $value');
      setConditionForGet(value);
    });
    //
    // SharedPreferences.getInstance().then((prefs) {
    //   Static.enablePendingOrderSound =
    //       prefs.getBool('enablePendingOrderSound') ?? true;
    //   Static.hideRestaurantAddressOnReceipt =
    //       prefs.getBool('hideRestaurantAddressOnReceipt') ?? false;
    //   Static.displayOrderIdTable =
    //       prefs.getBool('displayOrderIdTable') ?? true;
    //   Static.autoPrintTableBookingReceipt =
    //       prefs.getBool('autoPrintTableBookingReceipt') ?? false;
    //   Static.autoPrintOrder = prefs.getBool('autoPrintOrder') ?? true;
    //   Static.showOnlyCurrentDaysOrder =
    //       prefs.getBool('showOnlyCurrentDaysOrder') ?? false;
    //   Static.kitchenReceiptDefault =
    //       prefs.getBool('kitchenReceiptDefault') ?? true;
    //   Static.kitchenReceiptSameAsFront =
    //       prefs.getBool('kitchenReceiptSameAsFront') ?? false;
    //   Static.displayOrderIdInReceipt =
    //       prefs.getBool('displayOrderIdInReceipt') ?? true;
    //   Static.displayAwaitingNotPaidPayment =
    //       prefs.getBool('displayAwaitingNotPaidPayment') ?? false;
    //   Static.enableAwaitingNotPaidPaymentSound =
    //       prefs.getBool('enableAwaitingNotPaidPaymentSound') ?? false;
    //   Static.enableDeveloperMode =
    //       prefs.getBool('enableDeveloperMode') ?? false;
    //
    //   Static.Unconfirmed_payment_button_Value =
    //       prefs.getString('Unconfirmed_payment_button_Value') ?? Unconfirmed_payment_button_Value;
    //   Static.Paper_Size =
    //       prefs.getString('Paper_size') ?? Paper_Size;
    //   Static.AutoCutter =
    //       prefs.getString('AutoCutter') ?? AutoCutter;
    //   Static.Number_of_front_receipt_Value =
    //       prefs.getString('Number_of_front_receipt_Value') ?? Number_of_front_receipt_Value;
    //   Static.Number_of_kitchen_receipt_Value =
    //       prefs.getString('Number_of_kitchen_receipt_Value') ?? Number_of_kitchen_receipt_Value;
    //   Static.Pending_order_sound_length_value =
    //       prefs.getString('Pending_order_sound_length_value') ?? Pending_order_sound_length_value;
    //
    //   isFirstTIme=prefs.getInt('isfirst')??0;
    //
    //   // PrinterSetting printerSetting=PrinterSetting(Static.enablePendingOrderSound,Static.hideRestaurantAddressOnReceipt,Static.displayOrderIdTable,
    //   //     Static.autoPrintTableBookingReceipt,Static.autoPrintOrder,Static.showOnlyCurrentDaysOrder,Static.kitchenReceiptDefault, Static.kitchenReceiptSameAsFront,
    //   //     Static.displayOrderIdInReceipt,Static.displayAwaitingNotPaidPayment,Static.enableAwaitingNotPaidPaymentSound, Static.enableDeveloperMode,
    //   //     Static.Unconfirmed_payment_button_Value, Static.Paper_Size,Static.AutoCutter,Static.Number_of_front_receipt_Value,Static.Number_of_kitchen_receipt_Value,
    //   //     Static.Pending_order_sound_length_value
    //   // );
    //
    //
    //
    //
    // }).then((value) => dataUpdate());
  }

  void checkForReceipt() {
    if (!kitchenReceiptSameAsFront && !kitchenReceiptDefault) {
      AutoCutter = 'Yes';
      Get.snackbar(
        'Alert',
        'Disable popup will not work when Kitchen receipt (same as front) and kitchen receipt(default) both are disable ',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.deepOrange,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerGlobal = Provider.of<GlobalProvider>(context);
    if (!kitchenReceiptSameAsFront && !kitchenReceiptDefault) {
      AutoCutter = 'Yes';
    }

    print(
        'providerGlobal.getPrinterConnectionStatus----${providerGlobal.getPrinterConnectionStatus}');

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          'Printer settings',
        ),
        actions: [
          InkWell(
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                print(
                    'values save------- $Unconfirmed_payment_button_Value  $Paper_Size $AutoCutter $Number_of_front_receipt_Value $Number_of_kitchen_receipt_Value $Pending_order_sound_length_value,version--$version,$autoAcceptedTableBookingData');

                SettingsModel.UpDateSettings(
                  enablePendingOrderSound,
                  hideRestaurantAddressOnReceipt,
                  displayOrderIdTable,
                  autoPrintTableBookingReceipt,
                  autoPrintOrder,
                  showOnlyCurrentDaysOrder,
                  kitchenReceiptDefault,
                  kitchenReceiptSameAsFront,
                  displayOrderIdInReceipt,
                  displayAwaitingNotPaidPayment,
                  enableAwaitingNotPaidPaymentSound,
                  enableDeveloperMode,
                  Unconfirmed_payment_button_Value,
                  Paper_Size,
                  AutoCutter,
                  Number_of_front_receipt_Value,
                  Number_of_kitchen_receipt_Value,
                  Pending_order_sound_length_value,
                  autoAcceptedTableBookingData,
                  version,
                ).then((value) => goIntent());
                // saveToPref()
              },
              child: !isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 20),
                          child: Text(
                            'Save',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    )
                  : Container()),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isFirstTIme == 1
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });

                            print(
                                'values------- $Unconfirmed_payment_button_Value  $Paper_Size $AutoCutter $Number_of_front_receipt_Value $Number_of_kitchen_receipt_Value $Pending_order_sound_length_value');

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PrinterHome()));
                          },
                          //   SettingsModel.UpDateSettings(
                          //       enablePendingOrderSound,
                          //       hideRestaurantAddressOnReceipt,
                          //       displayOrderIdTable,
                          //       autoPrintTableBookingReceipt,
                          //       autoPrintOrder,
                          //       showOnlyCurrentDaysOrder,
                          //       kitchenReceiptDefault,
                          //       kitchenReceiptSameAsFront,
                          //       displayOrderIdInReceipt,
                          //       displayAwaitingNotPaidPayment,
                          //       enableAwaitingNotPaidPaymentSound,
                          //       enableDeveloperMode,
                          //       Unconfirmed_payment_button_Value,
                          //       Paper_Size,
                          //       AutoCutter,
                          //       Number_of_front_receipt_Value,
                          //       Number_of_kitchen_receipt_Value,
                          //       Pending_order_sound_length_value).then((value) => goIntentPrinterConnection());
                          // },
                          child: isFirstTimeLog > 0
                              ? Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        providerGlobal
                                                .getPrinterConnectionStatus
                                            ? Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                      Icons.print,
                                                      color: Colors.green,
                                                      size: 32,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'Printer is connected',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                      Icons.print_disabled,
                                                      color: Colors.red,
                                                      size: 32,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'Printer is not connected',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isLoading = true;
                                                      });

                                                      print(
                                                          'values------- $Unconfirmed_payment_button_Value  $Paper_Size $AutoCutter $Number_of_front_receipt_Value $Number_of_kitchen_receipt_Value $Pending_order_sound_length_value');

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  PrinterHome()));
                                                    },

                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: FittedBox(
                                                        fit: BoxFit.fill,
                                                        child: Text(
                                                          'Connect',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                !isLoading
                    ? Column(
                        children: [
                          Text(
                            "SETTINGS",
                            style: headerStyle,
                          ),
                          const SizedBox(height: 5.0),
                          Card(
                            elevation: 0.5,
                            margin: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 0,
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          child: Text('Paper size'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: DropdownButton<String>(
                                              value: Paper_Size,
                                              // icon: const Icon(Icons.arrow_downward),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.deepPurple),
                                              underline: Container(
                                                height: 0,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  Paper_Size = newValue;
                                                });
                                              },
                                              items: <String>[
                                                '58mm',
                                                '80mm',
                                                '80mm-large',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                !kitchenReceiptDefault &&
                                        !kitchenReceiptSameAsFront
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                child: Text(
                                                    'Disable kitchen receipt popup?'),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                  child: DropdownButton<String>(
                                                    value: AutoCutter,
                                                    // icon: const Icon(Icons.arrow_downward),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    style: const TextStyle(
                                                        color:
                                                            Colors.deepPurple),
                                                    underline: Container(
                                                      height: 0,
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                    ),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        AutoCutter = newValue;
                                                      });
                                                    },
                                                    items: <String>[
                                                      'Yes',
                                                      'No',
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          child: Text(
                                              'Unconfirmed payment button'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: DropdownButton<String>(
                                              value:
                                                  Unconfirmed_payment_button_Value,
                                              // icon: const Icon(Icons.arrow_downward),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.deepPurple),
                                              underline: Container(
                                                height: 0,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  Unconfirmed_payment_button_Value =
                                                      newValue;
                                                });
                                              },
                                              items: <String>[
                                                'Not paid',
                                                'Awaiting',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          child:
                                              Text('Number of front receipt'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: DropdownButton<String>(
                                              value:
                                                  Number_of_front_receipt_Value,
                                              // icon: const Icon(Icons.arrow_downward),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.deepPurple),
                                              underline: Container(
                                                height: 0,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  Number_of_front_receipt_Value =
                                                      newValue;
                                                });
                                              },
                                              items: <String>[
                                                'One',
                                                'Two',
                                                'Three',
                                                'Four',
                                                'Five'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          child:
                                              Text('Number of kitchen receipt'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: DropdownButton<String>(
                                              value:
                                                  Number_of_kitchen_receipt_Value,
                                              // icon: const Icon(Icons.arrow_downward),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.deepPurple),
                                              underline: Container(
                                                height: 0,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  Number_of_kitchen_receipt_Value =
                                                      newValue;
                                                });
                                              },
                                              items: <String>[
                                                'One',
                                                'Two',
                                                'Three',
                                                'Four',
                                                'Five'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          child: Text(
                                              'Pending order sound length'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: DropdownButton<String>(
                                              value:
                                                  Pending_order_sound_length_value,
                                              // icon: const Icon(Icons.arrow_downward),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.deepPurple),
                                              underline: Container(
                                                height: 0,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  Pending_order_sound_length_value =
                                                      newValue;
                                                });
                                              },
                                              items: <String>[
                                                'Short',
                                                'Medium',
                                                'Long',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            "MORE SETTINGS",
                            style: headerStyle,
                          ),
                          SizedBox(height: 5.0),
                          Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 0,
                            ),
                            child: Column(
                              children: <Widget>[
                                // Padding(
                                //   padding: const EdgeInsets.all(12.0),
                                //   child: Row(
                                //     children: [
                                //       Expanded(
                                //           flex: 7,
                                //           child: Container(
                                //             child: Text('Display Table Booking'),
                                //           )),
                                //       Expanded(
                                //         flex: 2,
                                //         child: Container(
                                //           height: 28,
                                //           child: FlutterSwitch(
                                //             showOnOff: true,
                                //             activeColor: Colors.green,
                                //             activeTextColor: Colors.black,
                                //             inactiveTextColor: Colors.blue[50],
                                //             value: displayTableBooking,
                                //             onToggle: (val) {
                                //               setState(() {
                                //                 displayTableBooking = val;
                                //               });
                                //             },
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child: Text(
                                                'Enable pending order sound'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value: enablePendingOrderSound,
                                            onToggle: (val) {
                                              setState(() {
                                                enablePendingOrderSound = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child: Text(
                                                'Hide restaurant address on receipt'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value:
                                                hideRestaurantAddressOnReceipt,
                                            onToggle: (val) {
                                              setState(() {
                                                hideRestaurantAddressOnReceipt =
                                                    val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child:
                                                Text('Display order id table'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value: displayOrderIdTable,
                                            onToggle: (val) {
                                              setState(() {
                                                displayOrderIdTable = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child: Text(
                                                'Auto print table booking receipt'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value: autoPrintTableBookingReceipt,
                                            onToggle: (val) {
                                              setState(() {
                                                autoPrintTableBookingReceipt =
                                                    val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),

                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child: Text(
                                                'Auto accept table booking'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value: autoAcceptedTableBooking,
                                            onToggle: (val) {
                                              setState(() {
                                                autoAcceptedTableBooking = val;
                                                print(
                                                    'autoAcceptedTableBookingData----$val');
                                                if (val) {
                                                  autoAcceptedTableBookingData =
                                                      "on";
                                                } else {
                                                  autoAcceptedTableBookingData =
                                                      "off";
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child: Text('Auto print order '),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value: autoPrintOrder,
                                            onToggle: (val) {
                                              setState(() {
                                                autoPrintOrder = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child: Text(
                                                'Show only current days order'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value: showOnlyCurrentDaysOrder,
                                            onToggle: (val) {
                                              setState(() {
                                                showOnlyCurrentDaysOrder = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child: Text(
                                                'Kitchen receipt(Default)'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value: kitchenReceiptDefault,
                                            onToggle: (val) {
                                              setState(() {
                                                kitchenReceiptDefault = val;

                                                checkForReceipt();

                                                if (kitchenReceiptDefault &&
                                                    kitchenReceiptSameAsFront) {
                                                  checkKitchenBothIsOn();
                                                  kitchenReceiptSameAsFront =
                                                      false;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child: Text(
                                                'Kitchen receipt(same as  front)'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value: kitchenReceiptSameAsFront,
                                            onToggle: (val) {
                                              setState(() {
                                                kitchenReceiptSameAsFront = val;

                                                checkForReceipt();

                                                if (kitchenReceiptSameAsFront) {
                                                  checkKitchenBothIsOn();
                                                  kitchenReceiptDefault = false;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child: Text(
                                                'Display order id(in receipt)'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value: displayOrderIdInReceipt,
                                            onToggle: (val) {
                                              setState(() {
                                                displayOrderIdInReceipt = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child: Text(
                                                'Display awaiting/not paid payment'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value:
                                                displayAwaitingNotPaidPayment,
                                            onToggle: (val) {
                                              setState(() {
                                                displayAwaitingNotPaidPayment =
                                                    val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child: Text(
                                                'Enable awaiting /not paid  payment sound'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value:
                                                enableAwaitingNotPaidPaymentSound,
                                            onToggle: (val) {
                                              setState(() {
                                                enableAwaitingNotPaidPaymentSound =
                                                    val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Container(
                                            child:
                                                Text('Enable developer mode'),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 28,
                                          child: FlutterSwitch(
                                            activeColor: Colors.green,
                                            showOnOff: true,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.blue[50],
                                            value: enableDeveloperMode,
                                            onToggle: (val) {
                                              setState(() {
                                                enableDeveloperMode = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  RaisedButton(
                                      color: Colors.deepOrange,
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        SettingsModel.UpDateSettings(
                                          enablePendingOrderSound,
                                          hideRestaurantAddressOnReceipt,
                                          displayOrderIdTable,
                                          autoPrintTableBookingReceipt,
                                          autoPrintOrder,
                                          showOnlyCurrentDaysOrder,
                                          kitchenReceiptDefault,
                                          kitchenReceiptSameAsFront,
                                          displayOrderIdInReceipt,
                                          displayAwaitingNotPaidPayment,
                                          enableAwaitingNotPaidPaymentSound,
                                          enableDeveloperMode,
                                          Unconfirmed_payment_button_Value,
                                          Paper_Size,
                                          AutoCutter,
                                          Number_of_front_receipt_Value,
                                          Number_of_kitchen_receipt_Value,
                                          Pending_order_sound_length_value,
                                          autoAcceptedTableBookingData,
                                          version,
                                        ).then((value) => goIntent());
                                        // saveToPref()
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),

                          // Card(
                          //   margin: const EdgeInsets.symmetric(
                          //     vertical: 8.0,
                          //     horizontal: 0,
                          //   ),
                          //   child: ListTile(
                          //     leading: Icon(Icons.exit_to_app),
                          //     title: Text("Logout"),
                          //     onTap: () {},
                          //   ),
                          // ),
                          const SizedBox(height: 30.0),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: Container(
                      color: Colors.transparent,
                      child: CircularProgressIndicator(
                        color: Colors.deepOrange,
                      )))
              : Container(),
        ],
        // child:
      ),
    );
  }

  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            // _connected = true;
            print('CONNECTED state---');
          });
          break;

        case BlueThermalPrinter.DISCONNECTED:
          if (mounted) {
            setState(() {
              print('DISCONNECTED state in pc---');
              // _connected = false;
              Provider.of<GlobalProvider>(context, listen: false)
                  .setPrinterConnectFalse();
            });
          }
          break;
        case BlueThermalPrinter.STATE_ON:
          if (mounted) {
            setState(() {
              // Provider.of<GlobalProvider>(context, listen: false).setBluetoothOnTrue();
              // _connect();
              // okTo = true;
            });
          }
          break;
        case BlueThermalPrinter.STATE_OFF:
          print('BlueThermalPrinter.STATE_OFF----------------');
          setState(() {
            Provider.of<GlobalProvider>(context, listen: false)
                .setBluetoothOnFalse();
            Provider.of<GlobalProvider>(context, listen: false)
                .setPrinterConnectFalse();
            // okTo = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected) {
      setState(() {
        // _connected = true;
      });
    }
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

  goIntent() async {
    await SettingsModel.getSettings();

    isLoading = false;
    print('Static.FirstTime------------------------ ${Static.FirstTime}');

    setIsFirstTime();
    if (Static.FirstTime == "1" ||
        !Provider.of<GlobalProvider>(context, listen: false)
            .getPrinterConnectionStatus) {
      Static.FirstTime = "0";
      print(
          'Static.FirstTime force 0 ------------------------ ${Static.FirstTime}');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => PrinterHome()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MyApp()));
    }
  }

  goIntentPrinterConnection() async {
    await SettingsModel.getSettings();

    isLoading = false;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => PrinterHome()));
  }

  dataUpdate() {
    enablePendingOrderSound = Static.enablePendingOrderSound;
    hideRestaurantAddressOnReceipt = Static.hideRestaurantAddressOnReceipt;
    displayOrderIdTable = Static.displayOrderIdTable;
    autoPrintTableBookingReceipt = Static.autoPrintTableBookingReceipt;
    autoPrintOrder = Static.autoPrintOrder;
    showOnlyCurrentDaysOrder = Static.showOnlyCurrentDaysOrder;
    kitchenReceiptDefault = Static.kitchenReceiptDefault;
    kitchenReceiptSameAsFront = Static.kitchenReceiptSameAsFront;
    displayOrderIdInReceipt = Static.displayOrderIdInReceipt;
    displayAwaitingNotPaidPayment = Static.displayAwaitingNotPaidPayment;
    enableAwaitingNotPaidPaymentSound =
        Static.enableAwaitingNotPaidPaymentSound;
    enableDeveloperMode = Static.enableDeveloperMode;

    Unconfirmed_payment_button_Value = Static.Unconfirmed_payment_button_Value;
    Paper_Size = Static.Paper_Size;
    AutoCutter = Static.disableKitchenPopUp;
    Number_of_front_receipt_Value = Static.Number_of_front_receipt_Value;
    Number_of_kitchen_receipt_Value = Static.Number_of_kitchen_receipt_Value;
    Pending_order_sound_length_value = Static.Pending_order_sound_length_value;
    autoAcceptedTableBooking = Static.autoAcceptTableBooking;

    setState(() {
      isLoading = false;
    });
  }

  void setSettings() async {
    await SettingsModel.UpDateSettings(
      enablePendingOrderSound,
      hideRestaurantAddressOnReceipt,
      displayOrderIdTable,
      autoPrintTableBookingReceipt,
      autoPrintOrder,
      showOnlyCurrentDaysOrder,
      kitchenReceiptDefault,
      kitchenReceiptSameAsFront,
      displayOrderIdInReceipt,
      displayAwaitingNotPaidPayment,
      enableAwaitingNotPaidPaymentSound,
      enableDeveloperMode,
      Unconfirmed_payment_button_Value,
      Paper_Size,
      AutoCutter,
      Number_of_front_receipt_Value,
      Number_of_kitchen_receipt_Value,
      Pending_order_sound_length_value,
      autoAcceptedTableBookingData,
      version,
    );
    SettingsModel.getSettings();
  }

  checkKitchenBothIsOn() {
    Get.snackbar(
      'Alert',
      'You can\'t enable  Kitchen receipt (same as front) and kitchen receipt(default) both at the same time',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[200],
      colorText: Colors.red,
      duration: Duration(seconds: 5),
    );
  }

  void setConditionForGet(String value) {
    if (Static.autoAcceptTableBooking) {
      autoAcceptedTableBookingData = "on";
    } else {
      autoAcceptedTableBookingData = "off";
    }
    if (value == "yes") {
      dataUpdate();
    } else {
      // setState(() {
      //   isLoading = false;
      // });
      dataUpdate();
    }
  }

  void setIsFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('isFirst'+'${Api.businessBaseUrl}', 2);
  }

  void getIsFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstTimeLog = prefs.getInt('isFirst'+'${Api.businessBaseUrl}') ?? 0;
      print("isFirstTime-------------------------$isFirstTimeLog");
    });
  }
}
