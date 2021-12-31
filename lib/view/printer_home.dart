import 'dart:async';
import 'dart:io';

import 'package:blue/global/constant.dart';
import 'package:blue/global_provider.dart';
import 'package:blue/main.dart';
import 'package:blue/receipt/front_receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterHome extends StatefulWidget {
  @override
  _PrinterHomeState createState() => new _PrinterHomeState();
}

class _PrinterHomeState extends State<PrinterHome> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;
  FrontReceipt frontReceipt;
  bool isConnecting = false;

  Timer periodicTimer;
  int timerCount = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    frontReceipt = FrontReceipt();
  }

  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Paired Devices'),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                // Provider.of<GlobalProvider>(context, listen: false)
                //     .setPrinterConnectFalse();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => MyApp()),
                    (route) => false);
                // Navigator.pushNamedAndRemoveUntil(
                //     context, MaterialPageRoute(builder: (_) => MyApp()));
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: RefreshIndicator(
            onRefresh: initPlatformState,
            backgroundColor: Colors.deepOrange,
            color: Colors.white,
            displacement: 150,
            strokeWidth: 4,
            child: Column(
              children: [
                Container(
                  child: !isConnecting
                      ? ListView.builder(
                          itemCount: _devices.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, int index) {
                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  isConnecting = true;
                                });
                                print(
                                    'isConnecting-------------------------------$isConnecting');
                                // await Future.delayed(Duration(seconds: 1));
                                await _connect(_devices[index], index);

                                //
                                //
                                //
                                // // }
                                //
                                //
                                // // Provider.of<GlobalProvider>(context, listen: false)
                                // //     .setBluetoothDevice(_devices[index]);
                                //
                                //
                                // print(
                                //     '_devices onTap ---------------------------------------${_devices[index]}');
                              },
                              child: ListTile(
                                // leading: FlutterLogo(),
                                title: Text(_devices[index].name),
                                subtitle: Text(_devices[index].address),
                              ),
                            );
                          })
                      : Container(),
                ),
                if (isConnecting)
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                      color: Colors.red,
                    )),
                  ),
              ],
            )));
  }

  Future _connect(BluetoothDevice device, int index) {
    const oneSec = const Duration(seconds: 1);
    periodicTimer =
        Timer.periodic(oneSec, (Timer t) => checkDelay(device, index));
    if (device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) async {
        if (!isConnected) {
          bluetooth.connect(device).catchError((error) {
            Provider.of<GlobalProvider>(context, listen: false)
                .setPrinterConnectFalse();

            _writePrinterConnectionSound("pcn");

            Get.snackbar(
              'Pinter Alert!',
              'Printer Connection Failed, Please make sure your printer is on and paired',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.blueGrey,
              colorText: Colors.white,
              duration: Duration(seconds: 5),
            );

            setState(() {
              _connected = false;
              isConnecting = false;
            });
          });
          // await Future.delayed(Duration(seconds: 8));
          print(
              "bluetooth.isConnected---------------------------main ${await bluetooth.isConnected}");

          for (int i = 0; i < 8; i++) {
            print(
                "isConnected---------------------------for ll   ${await bluetooth.isConnected}");

            if (await bluetooth.isConnected) {
              if (mounted) {
                Provider.of<GlobalProvider>(context, listen: false)
                    .setPrinterConnectTrue();
              }
              _writePrinterConnectionSound("pcy");

              if (mounted) {
                setState(() {
                  _connected = true;
                  isConnecting = false;
                });
              }

              print(
                  "isConnected---------------------------return ${await bluetooth.isConnected}");

              print(
                  "bluetooth.isConnected1-------------------${await bluetooth.isConnected}");

              await Future.delayed(Duration(seconds: 2));

              // if(await bluetooth.isConnected){
              Static.DEVICE_NAME = _devices[index].name;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('device_name', (_devices[index]).name);
              await prefs.setString(
                  'device_address', (_devices[index]).address);
              prefs
                  .setInt('device_type', (_devices[index]).type)
                  .then((value) => Provider.of<GlobalProvider>(
                          _scaffoldKey.currentContext,
                          listen: false)
                      .setBluetoothDevice(_devices[index]))
                  .then((value) => intent());
              return;
            } else {
              await Future.delayed(Duration(seconds: 2));
            }
          }
        }
      });
    }
  }

  checkDelay(BluetoothDevice device, int index) {
    timerCount++;
    print('timerCount--------------------$timerCount');
    if (timerCount == 10) {
      print('timer time == 10 --------------------$timerCount');
      // Future.delayed(const Duration(milliseconds: 1000), () {
      //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      // });
      //
      // _connect(device, index);
      periodicTimer.cancel();
      timerCount = 0;

      if (mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => MyApp()), (route) => false);
      }
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

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

  intent() {
    if (_connected && mounted) {
      // Provider.of<GlobalProvider>(context, listen: false)
      //     .setPrinterConnectTrue();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => MyApp()), (route) => false);
    }
    // else{
    //   Scaffold.of(context).showSnackBar(
    //     new SnackBar(
    //       content: new Text(
    //         'Device not connected',
    //         style: new TextStyle(
    //           color: Colors.white,
    //         ),
    //       ),
    //       duration:const Duration(seconds: 1),
    //     ),
    //   );
    //
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (_) => MyApp()));
    // }
  }
}

_writePrinterConnectionSound(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();

  final File file =
      File('/data/user/0/uk.co.ordervox.merchant/files/printer.txt');
  await file.writeAsString(text);
  print('-----------------directory------${file.path}');
}

Future show(
  String message, {
  Duration duration: const Duration(seconds: 3),
}) async {
  await new Future.delayed(new Duration(milliseconds: 100));
}
