// import 'dart:async';
//
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:flutter/material.dart';
// import 'package:blue/main.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
//
// class PrinterSetting extends StatefulWidget {
//   @override
//   _PrinterSettingState createState() => _PrinterSettingState();
// }
//
// class _PrinterSettingState extends State<PrinterSetting> {
//   PrinterBluetoothManager printerManager = PrinterBluetoothManager();
//   List<PrinterBluetooth> _devices = [];
//   PrinterBluetooth _device;
//   bool isPrinterFound = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     SharedPreferences.getInstance().then((prefs) {
//       String printerAddress = prefs.getString('printer_address') ?? '-1';
//       String printerName = prefs.getString('printer_name');
//       int printerType = prefs.getInt("printer_type");
//
//       if (printerAddress != "hello") {
//         printerManager.scanResults.listen((devices) async {
//           setState(() {
//             _devices = devices;
//           });
//         });
//       } else {
//         BluetoothDevice de = BluetoothDevice();
//         de.name = printerName;
//         de.address = printerAddress;
//         de.type = printerType;
//         PrinterBluetooth bl = PrinterBluetooth(de);
//       }
//     });
//   }
//
//   void _testPrint(PrinterBluetooth printer) async {
//     print(printer);
//     printerManager.selectPrinter(printer);
//
//     const PaperSize paper = PaperSize.mm58;
//
//     final PosPrintResult res = await printerManager
//         .printTicket(await demoReceipt(paper), queueSleepTimeMs: 50);
//
//     print(res.msg);
//   }
//
//   Future<Ticket> demoReceipt(PaperSize paper) async {
//     final Ticket ticket = Ticket(paper);
//
//     ticket.text('Thank you',
//         styles: PosStyles(align: PosAlign.center, bold: true));
//
//     //ticket.feed(0);
//     ticket.cut();
//     return ticket;
//   }
//
//   void _startScanDevices() {
//     setState(() {
//       _devices = [];
//     });
//     printerManager.startScan(Duration(seconds: 4));
//   }
//
//   void _stopScanDevices() {
//     printerManager.stopScan();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('printer'),
//       ),
//
//       body: StreamBuilder<bool>(
//         stream: printerManager.isScanningStream,
//         initialData: false,
//         builder: (c, snapshot) {
//           if (snapshot.data) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(32.0),
//                   child: Text('Please wait....'),
//                 ),
//                 Center(
//                   child: FloatingActionButton(
//                     child: Icon(Icons.stop),
//                     onPressed: _stopScanDevices,
//                     backgroundColor: Colors.red,
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             print('device length: ${_devices.length}');
//             _devices.length > 0
//                 ? isPrinterFound = true
//                 : isPrinterFound = false;
//             return isPrinterFound
//                 ? ListView.builder(
//                     itemCount: _devices.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return InkWell(
//                         onTap: () async {
//                           SharedPreferences prefs =
//                               await SharedPreferences.getInstance();
//                           await prefs.setString(
//                               'printer_address', _devices[index].address);
//
//                           await prefs.setString(
//                               'printer_name', _devices[index].name);
//
//                           await prefs.setInt(
//                               'printer_type', _devices[index].type);
//
//                           Navigator.pushReplacement(context,
//                               MaterialPageRoute(builder: (_) => MyApp()));
//                         },
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               height: 60,
//                               padding: EdgeInsets.only(left: 10),
//                               alignment: Alignment.centerLeft,
//                               child: Row(
//                                 children: <Widget>[
//                                   Icon(Icons.print),
//                                   SizedBox(width: 10),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         Text(_devices[index].name ?? ''),
//                                         Text(_devices[index].address),
//                                         Text(
//                                           'Click select this printer.',
//                                           style: TextStyle(
//                                               color: Colors.grey[700]),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Divider(),
//                           ],
//                         ),
//                       );
//                     })
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(32.0),
//                         child: Text(
//                             'No printer found.\n1.Please turn on your bluetooth printer\n2.Turn on your device bluetooth\n3.Press the search button.'),
//                       ),
//                       Center(
//                         child: FloatingActionButton(
//                           child: Icon(Icons.search),
//                           onPressed: _startScanDevices,
//                         ),
//                       ),
//                     ],
//                   );
//           }
//         },
//       ),
//
//     );
//   }
// }
