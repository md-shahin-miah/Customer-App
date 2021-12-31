import 'dart:convert';
import 'package:blue/NewProvider.dart';
import 'package:blue/global_provider.dart';
import 'package:blue/model/tablebookiing_details_model.dart';
import 'package:blue/schedule/screen/pickdate.dart';
import 'package:blue/schedule/widgets/constants.dart';
import 'package:blue/util/doubleBackTocloseWidget.dart';
import 'package:blue/view/network_error.dart';
import 'package:blue/view/printer_credential.dart';
import 'package:blue/view/printer_home.dart';
import 'package:blue/view/splash_screen.dart';
import 'package:blue/view/table_booking_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blue/view/home.dart';
import 'package:blue/view/login_page.dart';
import 'package:blue/view/menu/menu.dart';
import 'package:blue/view/order_page.dart';
import 'package:blue/view/setting.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'
    show
        Directory,
        File,
        HttpClient,
        HttpOverrides,
        Platform,
        SecurityContext,
        X509Certificate;
import 'package:blue/view/order_details.dart';
import 'package:blue/global/constant.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'model/order_details_model.dart';
import 'model/order_model.dart';
import 'model/settings_model.dart';
import 'model/tablebooking_model.dart';
import 'receipt/front_receipt.dart';
import 'receipt/global_printing.dart';
import 'receipt/table_booking_receipt.dart';


//print triggered but can't accepted , should

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

const EVENTS_KEY = "fetch_events";
bool enableHeadless = false;

void main() async {
  _enablePlatformOverrideForDesktop();
  HttpOverrides.global = new MyHttpoverrides();
  runApp(MultiProvider(
    providers: [
      // ChangeNotifierProvider(create: (_) => BluetoothProvider()),
      ChangeNotifierProvider(create: (_) => GlobalProvider()),
      ChangeNotifierProvider(create: (_) => NewProvide()),
    ],
    child: GetMaterialApp(
        routes: {
          Constant.PICK_DATE: (_) => PickDate(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.deepOrange,
          inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
        ),
        home: SplashScreenPage()),
  ));

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.deepOrangeAccent, // navigation bar color
    statusBarColor: Colors.deepOrangeAccent, // status bar color
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  int _currentIndex = 2;
  final List<Widget> pages = [
    OrderPage(),
    MenuPage(),
    HomePage(),
    TableBookingScreen(),
    SettingPage(),
  ];

  bool _enabled = true;
  int _status = 0;
  List<String> _events = [];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String domain;
  String storeToken;
  String deviceName;
  String deviceAddress;
  int deviceType;

  bool isReconnecting = false;

  static const MethodChannel methodChannel =
      MethodChannel('samples.flutter.io/battery');

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;


  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  String pathImage;
  FrontReceipt testPrint;
  bool _connected = false;
  Timer periodicTimer;
  var format;
  var dateTimeNow;
  GlobalPrinting globalPrinting = GlobalPrinting();
  TableBookingReceipt tableBookingReceipt;

  String datetime;

  int readFileCount = 0;

  String pDateTime;
  String pIsRestarted;

  var listTableBookingId;
  var listNormalOrder;

  bool isPrintingNormalOrder = false;

  int cleanValue = 0;
  int counterReconnect = 0;
  bool isConnected;

  @override
  void initState() {
    printerProgressBar();

    Screen.keepOn(true);

    initPlatformState();

    WidgetsBinding.instance.addObserver(this);
    Static.IsLoggedOut = "0";

    //
    SharedPreferences.getInstance().then((prefs) {
      listTableBookingId =
          prefs.getString('alreadyPrintedTable' + '${Api.businessBaseUrl}');
      listNormalOrder = prefs
          .getString('alreadyPrintedNormalOrder' + '${Api.businessBaseUrl}');

      if (listTableBookingId != null) {
        Static.tableOrderList =
            List<String>.from(json.decode(listTableBookingId));
      }
      if (listNormalOrder != null) {
        Static.orderIdList = List<String>.from(json.decode(listNormalOrder));
      }
    });

    format = DateFormat.yMd();
    dateTimeNow = format.format(DateTime.now());

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    tableBookingReceipt = TableBookingReceipt();

    timerForData();
    getPrefData();

    if (Platform.isIOS) iOSPermission();


    SharedPreferences.getInstance().then((prefs) async {
      Static.Domain = prefs.getString('domain') ?? '-1';
      domain = Static.Domain;
      print('domain-------------------------------------------$domain');

      await SettingsModel.getSettings();

      deviceName = prefs.getString('device_name') ?? null;
      deviceAddress = prefs.getString('device_address') ?? null;
      deviceType = prefs.getInt('device_type');
      BluetoothDevice de = BluetoothDevice(deviceName, deviceAddress);
      Provider.of<GlobalProvider>(context, listen: false)
          .setBluetoothDevice(de);
      // if () {

      print("deviceAddress ---------------------------------${deviceAddress.toString()} ");
      if (!await bluetooth.isConnected) {
        if (deviceAddress != null) {
          _writePrinterConnectionSound("pcn");
          if (mounted) {
            setState(() {
              isReconnecting = true;
            });
          }

          Provider.of<GlobalProvider>(context, listen: false)
              .setPrinterConnectFalse();

          Provider.of<GlobalProvider>(context, listen: false)
              .setBluetoothDevice(de);
          initPlatformState().then((value) => _connect());
        } else {
          Provider.of<GlobalProvider>(context, listen: false)
              .setPrinterConnectFalse();

          setState(() {});
        }
      } else {
        Provider.of<GlobalProvider>(context, listen: false)
            .setPrinterConnectTrue();
        _writePrinterConnectionSound("pcy");
      }

      // }
      // else {
      //   Provider.of<GlobalProvider>(context, listen: false)
      //       .setPrinterConnectFalse();
      //   setState(() {
      //     print(
      //         "Provider.of<GlobalProvider>(context, listen: false)---------${Provider.of<GlobalProvider>(context, listen: false).getPrinterConnectionStatus}");
      //   });
      // }

      if (domain != '-1') {
        Api.businessBaseUrl = 'https://$domain/api/Merchant/';
        Api.LAST_HIT_URL = 'https://$domain/';
        Api.BusinessUrl = 'www.$domain';
        _firebaseMessaging.subscribeToTopic(domain);

        methodChannel.invokeMethod('getPendingOrders', {'domain': domain});

        // methodChannel.invokeMethod('update_app');
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginPage()));
      }
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        int id = int.parse("${message['data']['title']}");

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (_) => NotificationPage(id)));
      },
      onLaunch: (Map<String, dynamic> message) async {
        int id = int.parse("${message['data']['title']}");

        Navigator.push(
            context, MaterialPageRoute(builder: (_) => OrderDetails(id)));
      },
      onResume: (Map<String, dynamic> message) async {
        int id = int.parse("${message['data']['title']}");

        Navigator.push(
            context, MaterialPageRoute(builder: (_) => OrderDetails(id)));
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
    });
    super.initState();

    // bluetooth.onRead().listen((event) {
    //   print('event-----------------${event}');
    //
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    if (Static.autoPrintOrder) {
      setListToSharePref('alreadyPrintedTable' + '${Api.businessBaseUrl}',
          Static.tableOrderList);
    }
    if (Static.autoPrintTableBookingReceipt) {
      setListToSharePref('alreadyPrintedNormalOrder' + '${Api.businessBaseUrl}',
          Static.orderIdList);
    }

    super.dispose();
  }

  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });

    switch (state) {
      case AppLifecycleState.resumed:
        print('AppLifecycleState.resumed------------------------------------');
        // Handle this case
        break;
      case AppLifecycleState.inactive:
        print('AppLifecycleState.inactive--------------------');
        // Handle this case
        break;
      case AppLifecycleState.paused:
        print('AppLifecycleState.paused--------------------');
        if (Static.autoPrintOrder) {
          setListToSharePref('alreadyPrintedTable' + '${Api.businessBaseUrl}',
              Static.tableOrderList);
        }
        if (Static.autoPrintTableBookingReceipt) {
          setListToSharePref(
              'alreadyPrintedNormalOrder' + '${Api.businessBaseUrl}',
              Static.orderIdList);
        }

        // Handle this case
        break;
    }
  }

  Future<void> handleClick(String value) async {
    switch (value) {
      case 'Reconnect':
        if (deviceAddress != null) {
          setState(() {
            isReconnecting = true;
          });

          _connect();
          // await Future.delayed(Duration(seconds: 5));
          // setState(() {
          //   isReconnecting = false;
          // });
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => PrinterHome()));
        }

        break;
      case 'Printer Settings':
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PrinterCredential()));
        break;

    }
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool printerConnection() {}

  @override
  Widget build(BuildContext context) {
    final providerGlobal = Provider.of<GlobalProvider>(context);

    final newProvider = Provider.of<NewProvide>(context);

    // if(!Static.printerIsConnected){
    //   Provider.of<GlobalProvider>(context, listen: false).setPrinterConnectFalse();
    //   _writePrinterConnectionSound("pcn");
    // }
    // else{
    //
    // }

    // if (providerGlobal.getPrinterConnectionStatus) {
    //   Static.printerIsConnected = true;
    //   print('printer connection---pcy');
    //   print('printer connection---${Static.printerIsConnected}');
    //   _writePrinterConnectionSound("pcy");
    // } else {
    //   Static.printerIsConnected = false;
    //   print('printer connection---pcn');
    //   _writePrinterConnectionSound("pcn");
    //   print('printer connection no---${Static.printerIsConnected}');
    // }

    bool isConnectedAppbar = false;
    bluetooth.isConnected.then((value) => isConnectedAppbar = value);

    return Scaffold(
        key: _scaffoldKey,
        appBar: _currentIndex == 1 || _currentIndex == 2 || _currentIndex == 4
            ? AppBar(
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Image(
                      image: AssetImage('assets/OrderEe.png'),
                      alignment: Alignment.center,
                      height: 50,
                      width: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // title: Text('OrderE - Merchant'),
                actions: [
                  isReconnecting
                      ? Container(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 15, top: 12, bottom: 10),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      :

                      // !onConnecting?
                      providerGlobal.getPrinterConnectionStatus
                          ? InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PrinterCredential()));

                                // bluetooth.printCustom("Test PRINT RECEIPT", 0, 0);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 15),
                                child: Icon(
                                  Icons.print,
                                  size: 40,
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 0, right: 15.0),
                              child: PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.print_disabled,
                                  size: 38,
                                ), // add this line
                                onSelected: handleClick,
                                itemBuilder: (BuildContext context) {
                                  return {'Reconnect', 'Printer Settings'}
                                      .map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                              ),
                            )
                ],
              )
            : PreferredSize(
                child: Container(
                  color: Colors.deepOrange,
                ),
                preferredSize: Size(0.0, 0.0),
              ),
        // leading:
        body: DoubleBackToCloseWidget(
            child: Container(
          child: _connectionStatus == 'ConnectivityResult.none'
              ? NetworkErrorScreen()
              : pages[_currentIndex],
        )),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Colors.deepOrange,
          buttonBackgroundColor: Colors.deepOrange,
          height: 60,
          animationDuration: Duration(
            milliseconds: 100,
          ),
          index: 2,
          animationCurve: Curves.easeInOutBack,
          items: <Widget>[
            Icon(Icons.restaurant, size: 30, color: Colors.white),
            Icon(Icons.list, size: 30, color: Colors.white),
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.table_chart, size: 30, color: Colors.white),
            Icon(Icons.settings, size: 30, color: Colors.white),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ));
  }

  Future<void> initPlatformState() async {
    isConnected = await bluetooth.isConnected;

    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      print(
          'bluetooth.onStateChanged().listen((state)---------------------------$state');
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print(
                'BlueThermalPrinter.CONNECTED   main----------------------------------');
          });
          break;

        case BlueThermalPrinter.DISCONNECTED:
          if (mounted) {
            setState(() {
              print(
                  'BlueThermalPrinter.DISCONNECTED  main----------------------------------');
              _connected = false;

              _writePrinterConnectionSound("pcn");
              Provider.of<GlobalProvider>(context, listen: false)
                  .setPrinterConnectFalse();
            });
          }
          break;
        case BlueThermalPrinter.STATE_ON:
          if (mounted) {
            setState(() {
              // Provider.of<GlobalProvider>(context, listen: false).setBluetoothOnTrue();
              print(
                  "BlueThermalPrinter.STATE_ON   main------------------------------");
              if (Provider.of<GlobalProvider>(context, listen: false)
                      .bluetoothDevice !=
                  null) {
                setState(() {
                  isReconnecting = true;
                });

                _connect();
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => PrinterHome()));
              }
            });
          }
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            Provider.of<GlobalProvider>(context, listen: false)
                .setBluetoothOnFalse();
            Provider.of<GlobalProvider>(context, listen: false)
                .setPrinterConnectFalse();
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
        _connected = true;
      });
    }
  }

  void _connect() {
    print("_connect called--------------------------------");
    if (Provider.of<GlobalProvider>(context, listen: false).bluetoothDevice ==
        null) {
      print(
          "device address  null on connect---------------${Provider.of<GlobalProvider>(context, listen: false).bluetoothDevice.address}");
    } else {
      bluetooth.isConnected.then((isConnected) async {
        if (!isConnected) {
          print(
              'device name  on connect--------------------------- ${Provider.of<GlobalProvider>(context, listen: false).bluetoothDevice.name}');
          bluetooth
              .connect(Provider.of<GlobalProvider>(context, listen: false)
                  .bluetoothDevice)
              .catchError((error) {
            if (mounted) {
              Provider.of<GlobalProvider>(context, listen: false)
                  .setPrinterConnectFalse();
              _writePrinterConnectionSound("pcn");
              Get.snackbar(
                'Pinter Alert!',
                'Printer Connection Failed, Please make sure your printer is on and paired',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.white,
                colorText: Colors.red,
                borderColor: Colors.black54,
                borderWidth: 1,
                duration: Duration(seconds: 5),
              );
              if (mounted) {
                setState(() {
                  _connected = false;
                  isReconnecting = false;
                });
              }
            }
          });

          for (int i = 0; i < 9; i++) {
            print(
                "isConnected-----------------on connect----------in loop for   ${await bluetooth.isConnected}");

            if (await bluetooth.isConnected) {
              if (mounted) {
                Provider.of<GlobalProvider>(context, listen: false)
                    .setPrinterConnectTrue();
              }
              _writePrinterConnectionSound("pcy");
              if (mounted) {
                setState(() {
                  _connected = true;
                  isReconnecting = false;
                });
              }
              print(
                  "isConnected---------on if isConnected true---------------on connect------------for ${await bluetooth.isConnected}");
              return;
            } else {
              await Future.delayed(Duration(seconds: 2));
            }
          }

          //
          // await Future.delayed(Duration(seconds: 8));
          // print("bluetooth.isConnected---------------------------main ${await bluetooth.isConnected}");
          //
          // if(await bluetooth.isConnected){
          //   Provider.of<GlobalProvider>(context, listen: false)
          //       .setPrinterConnectTrue();
          //   setState(() {
          //     _connected = true;
          //     isReconnecting=false;
          //     print('isReconnecting-------------$isReconnecting');
          //     onConnecting=false;
          //   });
          //   print("isConnected---------------------------re ${_connected}");
          // }

        }
      });
    }
  }

  Future _reConnect() {
    // if (Provider.of<GlobalProvider>(context, listen: false).bluetoothDevice ==
    //     null) {
    //   print(
    //       "printer device----------------on  _reConnect---------${Provider.of<GlobalProvider>(context, listen: false).bluetoothDevice.address}");
    // } else {
      bluetooth.isConnected.then((isConnected) async {
        if (!isConnected) {
          print(
              'device name------on _reConnect------------------ ${Provider.of<GlobalProvider>(context, listen: false).bluetoothDevice}');
          bluetooth
              .connect(Provider.of<GlobalProvider>(context, listen: false)
                  .bluetoothDevice)
              .catchError((error) {
            if (mounted) {
              Provider.of<GlobalProvider>(context, listen: false)
                  .setPrinterConnectFalse();
              _writePrinterConnectionSound("pcn");

              // Get.snackbar(
              //   'Pinter Alert!',
              //   'Printer Connection Failed, Please make sure your printer is on and paired',
              //   snackPosition: SnackPosition.TOP,
              //   backgroundColor: Colors.white,
              //   colorText: Colors.red,
              //   borderColor: Colors.black54,
              //   borderWidth: 1,
              //   duration: Duration(seconds: 5),
              // );

              // setState(() => );
              if (mounted) {
                setState(() {
                  _connected = false;
                  isReconnecting = false;

                  print(
                      'isReconnecting---------on  _reConnect-------------------$isReconnecting');
                });
              }
            }
          });

          for (int i = 0; i < 7; i++) {
            print(
                "isConnected-------------on  _reConnect---------------------------for loop ${await bluetooth.isConnected}");

            if (await bluetooth.isConnected) {
              if (mounted) {
                Provider.of<GlobalProvider>(context, listen: false)
                    .setPrinterConnectTrue();
              }
              _writePrinterConnectionSound("pcy");
              if (mounted) {
                setState(() {
                  _connected = true;
                  isReconnecting = false;
                });
              }

              return;
            } else {
              await Future.delayed(Duration(seconds: 2));
            }
          }

          // await Future.delayed(Duration(seconds: 8));
          // print("bluetooth.isConnected---------------------------rec ${await bluetooth.isConnected}");
          //
          // if(await bluetooth.isConnected){
          //   Provider.of<GlobalProvider>(context, listen: false)
          //       .setPrinterConnectTrue();
          //   // setState(() => );
          //   print("isConnected---------------------------re ${_connected}");
          //   setState(() {
          //     _connected = true;
          //     isReconnecting=false;
          //     print('isReconnecting-------------$isReconnecting');
          //     onConnecting=false;
          //   });
          // }

        }
      });
    // }
  }

  readAllDataFromKotlinFile() async {
    // Screen.keepOn(true);
    cleanValue++;
    counterReconnect++;

    if (cleanValue == 10000) {
      if (Static.orderIdList.length > 10) {
        Static.orderIdList.removeRange(0, Static.orderIdList.length - 10);
        if (Static.autoPrintTableBookingReceipt) {
          setListToSharePref(
              'alreadyPrintedNormalOrder' + '${Api.businessBaseUrl}',
              Static.orderIdList);
        }
      }
      if (Static.tableOrderList.length > 10) {
        Static.tableOrderList.removeRange(0, Static.tableOrderList.length - 10);
        if (Static.autoPrintOrder) {
          setListToSharePref('alreadyPrintedTable' + '${Api.businessBaseUrl}',
              Static.tableOrderList);
        }
      }
      if (Static.NewIdlIST.length > 10) {
        Static.NewIdlIST.removeRange(0, Static.NewIdlIST.length - 10);
      }

      setListToSharePref('alreadyPrintedTable' + '${Api.businessBaseUrl}',
          Static.tableOrderList);
      setListToSharePref('alreadyPrintedNormalOrder' + '${Api.businessBaseUrl}',
          Static.orderIdList);
      cleanValue = 0;
      FlutterRestart.restartApp();


    }

    print(
        "bluetooth---------------.isConnected---------------${await bluetooth.isConnected}");
    print(
        "bluetooth---------------.isAvailable---------------${await bluetooth.isAvailable}");
    print(
        "bluetooth---------------.isOn---------------${await bluetooth.isOn}------------deviceAddress------$deviceAddress");




    if (!await bluetooth.isConnected) {
      _writePrinterConnectionSound("pcn");
      if (mounted) {
        Provider.of<GlobalProvider>(context, listen: false)
            .setPrinterConnectFalse();
      }

      if (counterReconnect >= 3) {
        if (deviceAddress != null) {
          if (mounted) {
            setState(() {
              isReconnecting = true;
            });
          }

          await _reConnect();
          // await Future.delayed(Duration(seconds: 4));

          // setState(() {
          //   isReconnecting=false;
          //
          // });

        }
        counterReconnect = 0;
      }

      if (mounted) {
        setState(() {});
      }
    } else {
      _writePrinterConnectionSound("pcy");
      if (mounted) {
        Provider.of<GlobalProvider>(context, listen: false)
            .setPrinterConnectTrue();
      }
    }

    if (await bluetooth.isConnected) {
      _writePrinterConnectionSound("pcy");
    } else {
      _writePrinterConnectionSound("pcn");
    }

    final fileSettings = await _localFileSettings;
    try {
      String contentsSettings = await fileSettings.readAsString();

      if (contentsSettings.contains("1")) {
        SettingsModel.getSettings().then((value) {
          changeStatusOfSettings();
        });
      } else if (contentsSettings.contains("3")) {
        // print(
        //     '-------called for 3 from web for triggered---------------------------');
        await SettingsModel.changeSettingsStatus();

        FlutterRestart.restartApp();
      }
    } catch (e) {}

    readAndWriteSettings();

    if (await bluetooth.isConnected) {
      if (!isPrintingNormalOrder) {
        if (!Static.isBusy) {
          readDataForNormalOrder();
        }
      }
      await Future.delayed(Duration(seconds: 2));
      if (!Static.isBusy) {
        readDataForTableBooking();
      }
    }
  }

  Future<int> readDataForNormalOrder() async {

    print("bluetooth------------44-----------------------------------${bluetooth}--");
    if (isPrintingNormalOrder) {
      return 1;
    }
    isPrintingNormalOrder = true;

    try {
      final file = await _localFile;

      String contents = await file.readAsString();

      if (contents != '-1') {
        final jsonResponse = jsonDecode(contents);
        List<dynamic> orderIdArray = jsonResponse;

        for (var orderId in orderIdArray) {
          int id = int.parse(orderId['id']);
          if (orderIdArray.length > 1) {
            for (var orderId in orderIdArray) {
              int id = int.parse(orderId['id']);
              if (!Static.NewIdlIST.contains(id.toString())) {
                Static.NewId = "1";
                Static.NewIdlIST.add(id.toString());
              }
            }
          } else {
            if (!Static.NewIdlIST.contains(id.toString())) {
              Static.NewId = "1";
              Static.NewIdlIST.add(id.toString());
            }
          }
        }

        for (var orderId in orderIdArray) {
          print(
              '-----------------------orderId--------readDataForNormalOrder-----------$orderId');

          int id = int.parse(orderId['id']);

          print(
              '--------------Static.orderIdList. in for loop 1 ----------------------readDataForNormalOrder---------------------------${Static.orderIdList.toString()}');

          if (!Static.orderIdList.contains(id.toString())) {
            if (!Static.isPopUpOn && await bluetooth.isConnected) {
              if (Static.autoPrintOrder) {
                Static.isBusy = true;
                // Static.orderIdList.add(id.toString());
                // Static.orderIdList.add(id.toString());
                print(
                    '-------------------orderId in for loop main---------------------------readDataForNormalOrder------------------------$id');
                print(
                    '-------------------Static.orderIdList. in for loop -----------------------------readDataForNormalOrder------------------------${Static.orderIdList.toString()}');
                print("getOrderDetails----------------------main");
                bool result = await OrderDetailsModel.getOrderDetails(id);

                print('result----------------------------$result');
                if (result) {
                  if (await bluetooth.isConnected) {
                    print(
                        "---------------------timer before printOrderType ------------------------readDataForNormalOrder----------$id");
                    await printOrderType(id);
                    print(
                        "print----------------------timer after printOrderType -----------------------------readDataForNormalOrder----------------------$id");
                    await Future.delayed(Duration(seconds: 5));
                    print(
                        "---------------------timer after 8 sec --------------------------------readDataForNormalOrder-----------------------$id");
                  }
                }
              }
            }
          }
        }

        Static.isBusy = false;
        print(
            "Static.isBusy-----------------------------readDataForNormalOrder-------------------${Static.isBusy}");
      } else {}
      isPrintingNormalOrder = false;
      print(
          "isReading-------3 -readDataForNormalOrder-------------------$isPrintingNormalOrder");
    } catch (e) {
      isPrintingNormalOrder = false;
      print(
          "isReading-------4 -readDataForNormalOrder----------------$isPrintingNormalOrder");
      return 0;
    }
  }

  Future<int> readDataForTableBooking() async {
    print(
        "print---------------------------------------readDataForTableBooking");

    try {
      final file = await _localFileBooking;
      String contents = await file.readAsString();

      if (contents != '-1') {
        final jsonResponse = jsonDecode(contents);
        List<dynamic> orderIdArray = jsonResponse;

        for (var orderId in orderIdArray) {
          int id = int.parse(orderId['id']);
          print(
              '-------------------orderId in for loop -----------------------readDataForTableBooking---------------------$id');

          print(
              'Static.autoPrintTableBookingReceipt---------------readDataForTableBooking-------------${Static.autoPrintTableBookingReceipt}');

          print(
              'tablebookinglist-------------------readDataForTableBooking-----------------${Static.tableOrderList}');
          print(
              'Static.autoAcceptTableBooking--------------------readDataForTableBooking----------------${Static.autoAcceptTableBooking}');

          if (!Static.tableOrderList.contains(id.toString())) {
            print(
                'lolo called------${Static.autoAcceptTableBooking}------------------autoPrintTableBookingReceipt-------------readDataForTableBooking----------${Static.autoPrintTableBookingReceipt}');
            if (await bluetooth.isConnected) {
              if (Static.autoAcceptTableBooking) {
                Static.isBusy = true;
                var result =
                    await TableBookingDetailsModel.getTableBookingDetails(
                        id.toString());
                if (result) {
                  if (Static.autoPrintTableBookingReceipt) {
                    await printOrderTableBooking(id.toString());
                  }

                  if (!Static.enableDeveloperMode) {
                    await TableBookingModel.tableBookingChangeStatus(
                        id.toString(), '2');
                  }
                  await Future.delayed(Duration(seconds: 3));
                } else {
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
                if (Static.autoPrintTableBookingReceipt) {
                  var result =
                      await TableBookingDetailsModel.getTableBookingDetails(
                          id.toString());
                  if (result) {
                    Static.isBusy = true;
                    await printOrderTableBooking(id.toString());
                  }
                }
              }
            }
            await Future.delayed(Duration(seconds: 3));
          }
        }
        Static.isBusy = false;
      }
    } catch (e) {
      return 0;
    }
  }

  Future printOrderType(int id) async {
    print(
        'printOrderType called -------------------------printOrderType-------------------id--------$id---------------Static.isPopUpOn-------${Static.isPopUpOn}');
    if (await bluetooth.isConnected) {
      if (!Static.isPopUpOn) {
        Static.orderIdList.add(id.toString());
        print(
            "Static.orderIdList----------------printOrderType-----------------${Static.orderIdList.toString()}");
        await printOrderFront(id);
        await Future.delayed(Duration(seconds: 3));
        print(
            "---------printOrderType--------!Static.kitchenReceiptSameAsFront && !Static.kitchenReceiptDefault--------- ${!Static.kitchenReceiptSameAsFront && !Static.kitchenReceiptDefault}------bluetooth.isConnected----${await bluetooth.isConnected}-------!Static.enableDeveloperMode---------${!Static.enableDeveloperMode}");

        if (!Static.kitchenReceiptSameAsFront &&
            !Static.kitchenReceiptDefault) {
          if (!Static.enableDeveloperMode) {
            String resp = await OrderModel.changeStatus(id.toString(), '2');
            print(
                "---------printOrderType--------------orderid----changeStatus---------$id---main----- changeStatus response------------------$resp");
          }
        } else {
          await printKitchenReceipt(id);
          await Future.delayed(Duration(seconds: 3));
        }
      } else {}
    }
  }

  Future printOrderFront(int id) async {
    print('printOrderFront called ----------------------$id');

    print('Static.autoPrintOrder-${Static.autoPrintOrder}--------------$id');

    print('Static.orderIdList -----${Static.orderIdList}');
    print('Static.Paper_Size -----${Static.Paper_Size}');
    if (Static.Paper_Size == "58mm") {
      await globalPrinting.printOrder58(id);
      print('front receipt triggered for 58mm--------------$id');
    } else {
      print('front receipt triggered for 80mm--------------$id');

      if(Static.Paper_Size=="80mm-large"){
        await globalPrinting.printOrder80Large(id);
      }
      else{
        await globalPrinting.printOrder80(id);
      }

    }

    print('Developer mode11 ----${Static.enableDeveloperMode}');
  }

  Future printKitchenReceipt(int id) async {
    if (!Static.isPopUpOn) {
      if (Static.disableKitchenPopUp == 'Yes') {
        if (!Static.enableDeveloperMode) {
          print(
              'Developer mode ---printKitchenReceipt---${Static.enableDeveloperMode}');
          if (await bluetooth.isConnected) {
            printkitchenrec(id);
            await Future.delayed(Duration(seconds: 1));
            String resp = await OrderModel.changeStatus(id.toString(), '2');

            print("resp-----------changeStatus-----$resp");
          }
        } else {
          globalPrinting.printKitchenReceipt(id);
        }
        print(
            'Static.disableKitchenPopUp--------------------- ${Static.disableKitchenPopUp}');
      } else {
        print(
           'Static.isPopUpOn------12q--------------------------------------------${Static.isPopUpOn}');
        if (mounted) {
          Static.isPopUpOn = true;
          print(
              'Static.isPopUpOn--------------------------------------------------${Static.isPopUpOn}');
          _showMyDialog(id);
        }

        print('auto cutter No ${Static.disableKitchenPopUp}');
      }
    }
  }

  Future printOrderTableBooking(String id) {
    print(
        'printOrderTableBooking: ------${Static.autoPrintTableBookingReceipt}');

    // if (Static.autoPrintTableBookingReceipt) {
    if (!Static.tableOrderList.contains(id)) {
      print('table called on ------------------58');
      Static.tableOrderList.add(id);

      print('tble list---------------${Static.tableOrderList}');
      tableBookingReceipt.tableReceipt();

      print(
          'Static.tableOrderList ok------------------${Static.tableOrderList}');
    }
    // }

    print(
        '-------------------printOrderTableBooking orderId--------------${id}');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('data/user/0/uk.co.ordervox.merchant/files/config.txt');
  }

  Future<File> get _localFileSettings async {
    final path = await _localPath;
    return File(
        'data/user/0/uk.co.ordervox.merchant/files/settings_status.txt');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    return file.writeAsString('$counter');
  }

  Future<String> get _localPathBooking async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFileBooking async {
    final path = await _localPathBooking;
    return File('data/user/0/uk.co.ordervox.merchant/files/configBooking.txt');
  }

  Future<File> writeCounterBooking(int counter) async {
    final file = await _localFileBooking;

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  _writePendingOrderSound(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file =
        File('/data/user/0/uk.co.ordervox.merchant/files/audio.txt');
    await file.writeAsString(text);
    print('-----------------directory----${file.path}');
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

  _writePrinterConnectionSound(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file =
        File('/data/user/0/uk.co.ordervox.merchant/files/printer.txt');
    await file.writeAsString(text);
    print('-----------------directory------${file.path}');
  }

  Future<void> _showMyDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!S
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Order ID : ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$id',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Do you want to print a Kitchen  Receipt?',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Text(''),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // background
                onPrimary: Colors.white, // foreground
              ),
              child: Text('Print'),
              onPressed: () async {
                print(
                    '-------------------printKitchenReceipt trigerred--------------$id');

                if (Provider.of<GlobalProvider>(context, listen: false)
                        .getPrinterConnectionStatus &&
                    await bluetooth.isConnected) {
                  Navigator.pop(context);
                  // globalPrinting.printKitchenReceipt(id);
                  print('kitchen receipt if');
                  if (!Static.enableDeveloperMode) {
                    if (await bluetooth.isConnected) {
                      printKitchen(id);
                      OrderModel.changeStatus(id.toString(), '2');
                          // .then((value) => );
                    }
                  } else {
                    globalPrinting.printKitchenReceipt(id);
                  }
                } else {
                  Navigator.pop(context);
                  print('kitchen receipt else');

                  Get.snackbar(
                    'Pinter Alert!',
                    'Something went wrong, please check your printer connection and try again',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red[400],
                    colorText: Colors.white,
                    duration: Duration(seconds: 5),
                  );
                }

                Static.isPopUpOn = false;
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // background
                onPrimary: Colors.white, // foreground
              ),
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context);

                if (!Static.enableDeveloperMode) {
                  OrderModel.changeStatus(id.toString(), '2')
                      .then((value) => Static.NewId = "1");
                }

                Static.isPopUpOn = false;
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogForRestart() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!S
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Do you want to Restart OrderE Merchant app?',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Text(''),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // background
                onPrimary: Colors.white, // foreground
              ),
              child: Text('Yes'),
              onPressed: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setString("datetime", dateTimeNow);
                  prefs.setString('pIsRestarted', "1");
                  Navigator.pop(context);
                  FlutterRestart.restartApp();
                });
                readFileCount = 5;
                "com.android.internal.intent.action.REQUEST_SHUTDOWN";
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // background
                onPrimary: Colors.white, // foreground
              ),
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> readAndWriteSettings() async {
    print(
        '----readAndWriteSettings ------------çalled -----------------+ ${Static.IsLoggedOut}');

    if (Static.IsLoggedOut == "0") {
      print(
          'Static.Unconfirmed_payment_button_Value-----${Static.Unconfirmed_payment_button_Value}');

      if (Static.Unconfirmed_payment_button_Value == 'Not paid') {
        if (Static.enableAwaitingNotPaidPaymentSound) {
          _writeAwaitingSound("n");
          print('n');
        } else {
          _writeAwaitingSound("0");
        }
      }
      _writeAwaitingSoundStopForServer("1");

      if (await bluetooth.isConnected) {
        _writePrinterConnectionSound("pcy");
        print('n');
      } else {
        _writePrinterConnectionSound("pcn");
      }

      if (Static.Unconfirmed_payment_button_Value == 'Awaiting') {
        if (Static.enableAwaitingNotPaidPaymentSound) {
          _writeAwaitingSound("a");
          print('a');
        } else {
          _writeAwaitingSound("0");
        }
      }

      if (Static.enablePendingOrderSound) {
        if (Static.Pending_order_sound_length_value == 'Short') {
          _writePendingOrderSound('1S');
        }
        if (Static.Pending_order_sound_length_value == 'Medium') {
          _writePendingOrderSound('1M');
        }
        if (Static.Pending_order_sound_length_value == 'Long') {
          _writePendingOrderSound('1L');
        }
      } else {
        _writePendingOrderSound('0');
      }
    } else {
      print('-----else--- matched in logged not 0}');
      _writePrinterConnectionSound("pcy");
      _writeAwaitingSound("0");
      _writeAwaitingSoundStopForServer("0");
      _writePendingOrderSound('0');
    }
  }

  getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Static.BusinessName = prefs.getString("BusinessName") ?? 'No name';

    // Static.enablePendingOrderSound =
    //     prefs.getBool('enablePendingOrderSound') ?? false;
    // Static.hideRestaurantAddressOnReceipt =
    //     prefs.getBool('hideRestaurantAddressOnReceipt') ?? false;
    // Static.displayOrderIdTable = prefs.getBool('displayOrderIdTable') ?? true;
    // Static.autoPrintTableBookingReceipt =
    //     prefs.getBool('autoPrintTableBookingReceipt') ?? false;
    // Static.autoPrintOrder = prefs.getBool('autoPrintOrder') ?? true;
    // Static.showOnlyCurrentDaysOrder =
    //     prefs.getBool('showOnlyCurrentDaysOrder') ?? false;
    // Static.kitchenReceiptDefault =
    //     prefs.getBool('kitchenReceiptDefault') ?? true;
    // Static.kitchenReceiptSameAsFront =
    //     prefs.getBool('kitchenReceiptSameAsFront') ?? false;
    // Static.displayOrderIdInReceipt =
    //     prefs.getBool('displayOrderIdInReceipt') ?? true;
    // Static.displayAwaitingNotPaidPayment =
    //     prefs.getBool('displayAwaitingNotPaidPayment') ?? false;
    // Static.enableAwaitingNotPaidPaymentSound =
    //     prefs.getBool('enableAwaitingNotPaidPaymentSound') ?? false;
    // Static.enableDeveloperMode =
    //     prefs.getBool('enableDeveloperMode') ?? false;
    //
    // Static.Unconfirmed_payment_button_Value =
    //     prefs.getString('Unconfirmed_payment_button_Value') ?? "Awaiting";
    // Static.Number_of_front_receipt_Value =
    //     prefs.getString('Number_of_front_receipt_Value') ?? "One";
    // Static.Number_of_kitchen_receipt_Value =
    //     prefs.getString('Number_of_kitchen_receipt_Value') ?? "One";
    // Static.Pending_order_sound_length_value =
    //     prefs.getString('Pending_order_sound_length_value') ?? "Long";
    // Static.Paper_Size = prefs.getString('Paper_size') ?? "80mm";
    // Static.disableKitchenPopUp = prefs.getString('disableKitchenPopUp') ?? "No";
  }

  timerForData() {
    const oneSec = const Duration(seconds: 15);
    periodicTimer =
        Timer.periodic(oneSec, (Timer t) => readAllDataFromKotlinFile());
  }

  setListToSharePref(
    String key,
    List<String> tableOrderList,
  ) {
    var s = json.encode(tableOrderList);

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(key, s);
    });
  }

  List<String> getListFromSharePref(String key) {
    var list;
    SharedPreferences.getInstance().then((prefs) {
      list = prefs.getString(key);

      if (list != null) {
        return json.decode(list);
      }
    });
  }

  void printKitchen(int id) {
    Static.NewId = "1";
    globalPrinting.printKitchenReceipt(id);
  }

  printkitchenrec(int id) {
    Static.NewId = "1";
    globalPrinting.printKitchenReceipt(id);
  }

  settingsChange(String settings) {
    if (settings == "x") {
      SettingsModel.getSettings().then((value) => setSettingsValToPrf());
    }
  }

  setSettingsValToPrf() {
    SharedPreferences.getInstance().then((prf) {
      prf.setString('setting', "0");
    }).then((value) => changeToDb());
  }

  changeToDb() {}

  void changeStatusOfSettings() {
    SettingsModel.changeSettingsStatus();
  }

  Future<void> printerProgressBar() async {
    if (await bluetooth.isConnected) {
      setState(() {
        isReconnecting = true;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        isReconnecting = false;
      });
    }
  }
}

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
