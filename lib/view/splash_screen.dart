import 'dart:async';
import 'dart:io';

import 'package:blue/global/constant.dart';
import 'package:blue/global_provider.dart';
import 'package:blue/main.dart';
import 'package:blue/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:provider/provider.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'printer_home.dart';

class SplashScreenPage extends StatefulWidget {
  BlueThermalPrinter bluetooth;

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  // BlueThermalPrinter  bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool openSettingBlueOn = false;
  String pathImage;
  // FrontReceipt frontReceipt;

  // BluetoothDevice _device;
  int isLogged;
  bool isOn = false;
  String deviceName;
  String deviceAdress;
  int deviceType;
  Timer periodicTimer;
  int timerCount=0;
  @override
  void initState() {
    super.initState();

    // Static.FirstTime="1";
    // print('Static.FirstTime splash------------------------ ${Static.FirstTime}');


    try {
      widget.bluetooth = BlueThermalPrinter.instance;
    } on PlatformException {
      print('------------------------------- ${widget.bluetooth}');
    }

    const oneSec = const Duration(seconds: 1);
    periodicTimer = Timer.periodic(oneSec, (Timer t) =>checkDelay() );



    SharedPreferences.getInstance().then((prefs)=>getAllPrefData(prefs));
  }

  Future<void> initPlatformState() async {
    bool isConnected = await widget.bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await widget.bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    widget.bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            // _connect();
            // Provider.of<BluetoothProvider>(context, listen: false).setGloballyConnectTrue();
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            // Provider.of<BluetoothProvider>(context, listen: false).setGloballyConnectFalse();
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            openSettingBlueOn = true;
            // Provider.of<BluetoothProvider>(context, listen: false).setGloballyConnectFalse();
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
        // Provider.of<BluetoothProvider>(context, listen: false).setGloballyConnectTrue();
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'OrderE - Merchant',
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            CircularProgressIndicator(
                       color:Colors.deepOrange
                      )
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Powered by OrderE'),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }

  // _connect() {
  //   if (_device == null) {
  //     show('No device Available,Pair inner device and try again.');
  //   } else {
  //     bluetooth.isConnected.then((isConnected) {
  //       if (!isConnected) {
  //         bluetooth.connect(_device).catchError((error) {
  //           setState(() => _connected = false);
  //         });
  //         setState(() => _connected = true);
  //       }
  //     });
  //   }
  // }
  // void _connect() {
  //   if (_device == null) {
  //     show('No device selected.');
  //   } else {
  //     widget.bluetooth.isConnected.then((isConnected) {
  //       if (!isConnected) {
  //         widget.bluetooth.connect(_device).catchError((error) {
  //           print("error--------------------$error");
  //           if (mounted) {
  //             Provider.of<GlobalProvider>(context, listen: false)
  //                 .setPrinterConnectFalse();
  //             setState(() => _connected = false);
  //           }
  //         });
  //
  //         Provider.of<GlobalProvider>(context, listen: false)
  //             .setPrinterConnectTrue();
  //         setState(() => _connected = true);
  //       }
  //     });
  //   }
  // }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  // Future show(
  //   String message, {
  //   Duration duration: const Duration(seconds: 3),
  // }) async {
  //   await new Future.delayed(new Duration(milliseconds: 100));
  //   Scaffold.of(context).showSnackBar(
  //     new SnackBar(
  //       content: new Text(
  //         message,
  //         style: new TextStyle(
  //           color: Colors.white,
  //         ),
  //       ),
  //       duration: duration,
  //     ),
  //   );
  // }

  // timer(int isLogged) {
  //   Timer(Duration(seconds: 2), () {
  //     if (!mounted) return;
  //     if (isLogged == 1) {
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (_) => MyApp()));
  //     } else {
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (_) => LoginPage()));
  //     }
  //   });
  // }

  getoutput() {
    print('ok dbnas-------------------------');
  }

  // Future<void> _showMyDialog(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Bluetooth is Off!',
  //           style: TextStyle(color: Colors.deepOrangeAccent),
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Please turn on your bluetooth'),
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
  //             child: Text('Ok'),
  //             onPressed: () {
  //               Provider.of<BluetoothProvider>(context, listen: false).bluetooth.openSettings;
  //
  //             },
  //           ),
  //           // ElevatedButton(
  //           //   style: ElevatedButton.styleFrom(
  //           //     primary: Color(Colors.), // background
  //           //     onPrimary: Colors.green, // foreground
  //           //   ),
  //           //   child: Text('No'),
  //           //   onPressed: () {
  //           //     Navigator.pop(context);
  //           //   },
  //           // ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Your Bluetooth is Off!',
            style: TextStyle(color: Colors.deepOrangeAccent),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please turn on your bluetooth and try again.'),

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
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
                Provider.of<GlobalProvider>(context, listen: false).setPrinterConnectFalse();
                if(isLogged==1){
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => MyApp()));

                }
                else{
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => LoginPage()));
                }

                // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                // Navigator.pushReplacement(
                //     context, MaterialPageRoute(builder: (context) => MyApp()));
                //
                //
                // Navigator.pushAndRemoveUntil(context, MyApp(), (route) => false);

                // if (Platform.isAndroid) {
                //
                // } else if (Platform.isIOS) {
                //
                // }
                // Future.delayed(const Duration(milliseconds: 1000), () {
                //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                // });
                // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     primary:Colors.green, // background
            //     onPrimary: Colors.white, // foreground
            //   ),
            //   child: Text('Go to Settings'),
            //   onPressed: () {
            //     widget.bluetooth.openSettings ;
            //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            //   },
            // ),
          ],
        );
      },
    );
  }

  intentAll() {
    print('getPrinterConnectionStatus---------------------------------------${ Provider.of<GlobalProvider>(context, listen: false)
        .getPrinterConnectionStatus}');
print('intent_All called----------------------------');
    if (Provider.of<GlobalProvider>(context, listen: false).bluetoothStatus) {


        if (!mounted) return;
        if (isLogged == 1) {
          if (deviceAdress == null) {

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => PrinterHome()));
          } else {
            // if(Provider.of<GlobalProvider>(context, listen: false).getPrinterConnectionStatus){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => MyApp()));

            // }
            // else{
            //   // Provider.of<GlobalProvider>(context, listen: false)
            //   //     .setPrinterConnectFalse();
            //   Navigator.pushReplacement(
            //       context, MaterialPageRoute(builder: (_) => MyApp()));
            // }

          }
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginPage()));
        }

      // Provider.of<GlobalProvider>(context, listen: false).setGloballyConnectTrue();
      print(
          'bluetoothStatus splash if-------------------------------------------${Provider.of<GlobalProvider>(context, listen: false).bluetoothStatus}');
    } else {
      _showMyDialog();
      print(
          'bluetoothStatus splash else-------------------------------------------${Provider.of<GlobalProvider>(context, listen: false).bluetoothStatus}');
    }

  }

  getAllPrefData(SharedPreferences prefs) {
    isLogged = prefs.getInt('logged') ?? 0;
    deviceName = prefs.getString('device_name') ?? null;
    deviceAdress = prefs.getString('device_address') ?? null;
    deviceType = prefs.getInt('device_type');

    BluetoothDevice de = BluetoothDevice(deviceName, deviceAdress);
    _device = de;
    // frontReceipt = FrontReceipt();


    // else{
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (_) => PrinterHome()));
    // }
    // if (deviceAdress != null) {
    //   Provider.of<GlobalProvider>(context, listen: false).setBluetoothDevice(de);
    //   initPlatformState().then((value) => _connect());
    // }

    Provider.of<GlobalProvider>(context, listen: false)
        .initPlatformState()
        .then((val) {
      print(
          'bluetoothStatus splash-------------------------------------------${Provider.of<GlobalProvider>(context, listen: false).bluetoothStatus}');

      Future.delayed(Duration(seconds: 5)).then((value) => intentAll());


    });

    print(
        'value of isLogged --------------------------------$isLogged ----+   ${_device.name}');
    print(
        'bluetooth device-------------------------------- ${deviceName}  +-----------------${deviceAdress}');




  }

  checkDelay() {
    timerCount++;
    print('timerCount--------------------$timerCount');
    if(timerCount==20){
      print('timer time == 20 --------------------$timerCount');
      // Future.delayed(const Duration(milliseconds: 1000), () {
      //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      // });

      periodicTimer.cancel();
      timerCount=0;
      if(mounted){
        if(isLogged!=1){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginPage()));
        }
        else{

        }

      }

    }
  }

}
