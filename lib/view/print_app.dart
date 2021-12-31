// import 'dart:async';
//
// // import 'package:esc_pos_utils/esc_pos_utils.dart';
// // import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:flutter/material.dart' hide Image;
// import 'package:blue/model/home_model.dart';
// import 'package:blue/model/order_details_model.dart';
// import 'package:blue/podo/food_item.dart';
// import 'package:blue/podo/sub_item.dart';
// import 'package:blue/util/my_util.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class PrintApp extends StatefulWidget {
//   @override
//   _PrintAppState createState() => _PrintAppState();
// }
//
// class _PrintAppState extends State<PrintApp> {
//   static const int BREAK_TEXT_LENGTH = 15;
//   // PrinterBluetoothManager printerManager = PrinterBluetoothManager();
//   // List<PrinterBluetooth> _devices = [];
//   // PrinterBluetooth _device;
//   bool isPrinterFound = true;
//
//   @override
//   void initState() {
//     super.initState();
//     // _startScanDevices();
//   }
//
//   void _startScanDevices() {
//     setState(() {
//       _devices = [];
//     });
//     printerManager.startScan(Duration(seconds: 1));
//
//     Timer(Duration(seconds: 4), () {
//       SharedPreferences.getInstance().then((prefs) {
//         String printerAddress = prefs.getString('printer_address') ?? '-1';
//
//         printerManager.scanResults.listen((devices) async {
//           _devices = devices;
//           if (printerAddress == '-1') {
//             isPrinterFound = true;
//             setState(() {});
//           } else {
//             for (PrinterBluetooth printer in devices) {
//               if (printer.address == printerAddress) {
//                 _device = printer;
//                 break;
//               }
//             }
//
//             _testPrint(_device);
//           }
//         });
//       });
//     });
//   }
//
//   void _stopScanDevices() {
//     printerManager.stopScan();
//   }
//
//   Future<Ticket> demoReceipt(PaperSize paper) async {
//     final Ticket ticket = Ticket(paper);
//
//     ticket.text(MyUtils.breakText(HomeModel.businessName, 10),
//         styles: PosStyles(
//           align: PosAlign.center,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//         linesAfter: 1);
//
//     ticket.text('${HomeModel.businessAddress}',
//         styles: PosStyles(align: PosAlign.center));
//     ticket.text('${HomeModel.businessPostCode}',
//         styles: PosStyles(align: PosAlign.center));
//     ticket.text('Tel: ${HomeModel.businessContact}',
//         styles: PosStyles(align: PosAlign.center));
//     ticket.text(
//         OrderDetailsModel.customer.deliveryType == 1
//             ? 'Web Delivery'
//             : 'Web Collection',
//         styles: PosStyles(align: PosAlign.center),
//         linesAfter: 1);
//
//     ticket.text(OrderDetailsModel.customer.customerName,
//         styles: PosStyles(align: PosAlign.left));
//     ticket.text(OrderDetailsModel.customer.customerContact,
//         styles: PosStyles(align: PosAlign.left));
//
//     ticket.text(
//         '${OrderDetailsModel.customer.deliveryAddress}\n${OrderDetailsModel.customer.postCode}',
//         styles: PosStyles(
//           align: PosAlign.left,
//         ),
//         linesAfter: 1);
//
//     ticket.row([
//       PosColumn(text: 'Item', width: 8, styles: PosStyles(bold: true)),
//       PosColumn(
//           text: 'Price',
//           width: 4,
//           styles: PosStyles(align: PosAlign.right, bold: true)),
//     ]);
//
//     ticket.hr(ch: ' ', linesAfter: 1);
//
//     for (FoodItem foodItem in OrderDetailsModel.foodItems) {
//       bool isLongName = false;
//
//       String itemName = MyUtils.breakText(foodItem.itemName, BREAK_TEXT_LENGTH);
//
//       if (itemName.length > BREAK_TEXT_LENGTH + 5) {
//         isLongName = true;
//       }
//
//       ticket.row([
//         PosColumn(
//             text: '${foodItem.quantity} x $itemName',
//             width: 3,
//             styles: PosStyles(align: PosAlign.left)),
//         PosColumn(text: ' ', width: 3, styles: PosStyles(align: PosAlign.left)),
//         PosColumn(
//             text: '${foodItem.itemTotal.toStringAsFixed(2)}',
//             width: 6,
//             styles: PosStyles(align: PosAlign.right)),
//       ]);
//
//       List<SubItem> subItems = foodItem.subItems;
//
//       if (subItems != null) {
//         if (isLongName) ticket.hr(ch: ' ', linesAfter: 1);
//         for (SubItem subItem in subItems) {
//           ticket.row([
//             PosColumn(
//                 text:
//                     '   ~ ${subItem.subItemName}\n       ${subItem.subItemVar}',
//                 width: 12,
//                 styles: PosStyles(align: PosAlign.left)),
//           ]);
//         }
//       }
//       ticket.hr(ch: '-', linesAfter: 1);
//     }
//     ticket.row([
//       PosColumn(
//           text: 'Total', width: 6, styles: PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: '${OrderDetailsModel.customer.total.toStringAsFixed(2)}',
//           width: 6,
//           styles: PosStyles(align: PosAlign.right)),
//     ]);
//
//     ticket.row([
//       PosColumn(
//           text: 'Delivery Charge',
//           width: 6,
//           styles: PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text:
//               '${OrderDetailsModel.customer.deliveryCharge.toStringAsFixed(2)}',
//           width: 6,
//           styles: PosStyles(align: PosAlign.right)),
//     ]);
//
//     ticket.row([
//       PosColumn(
//           text: 'Service Charge',
//           width: 6,
//           styles: PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text:
//               '${OrderDetailsModel.customer.serviceCharge.toStringAsFixed(2)}',
//           width: 6,
//           styles: PosStyles(align: PosAlign.right)),
//     ]);
//     ticket.row([
//       PosColumn(
//           text: 'Discount', width: 6, styles: PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: '${OrderDetailsModel.customer.discount.toStringAsFixed(2)}',
//           width: 6,
//           styles: PosStyles(align: PosAlign.right)),
//     ]);
//
//     ticket.row([
//       PosColumn(
//           text: 'Total to pay',
//           width: 6,
//           styles: PosStyles(align: PosAlign.left, bold: true)),
//       PosColumn(
//           text: '${OrderDetailsModel.customer.totalToPay}',
//           width: 6,
//           styles: PosStyles(align: PosAlign.right, bold: true)),
//     ]);
//     ticket.hr(ch: "_", linesAfter: 1);
//
//     ticket.text('Order placed at\n${OrderDetailsModel.customer.orderDate}',
//         styles: PosStyles(align: PosAlign.left));
//
//     ticket.text('Wanted ${OrderDetailsModel.customer.deliveryTime}',
//         styles: PosStyles(align: PosAlign.left));
//
//     ticket.text('Payment Method : ${OrderDetailsModel.customer.paymentMethod}',
//         styles: PosStyles(align: PosAlign.left));
//
//     if (OrderDetailsModel.customer.paymentMethod == "online") {
//       ticket.text(
//           OrderDetailsModel.customer.paymentStatus = null
//               ? 'Payment Status : Not paid'
//               : 'Payment Status  ${OrderDetailsModel.customer.paymentMethod}',
//           styles: PosStyles(align: PosAlign.left));
//     }
//
//     ticket.hr(ch: ' ', linesAfter: 1);
//     ticket.text('Thank you',
//         styles: PosStyles(align: PosAlign.center, bold: true));
//
//     ticket.feed(1);
//     ticket.cut();
//     return ticket;
//   }
//
//   void _testPrint(PrinterBluetooth printer) async {
//     print('test print called');
//     printerManager.selectPrinter(printer);
//
//     const PaperSize paper = PaperSize.mm58;
//
//     final PosPrintResult res =
//         await printerManager.printTicket(await demoReceipt(paper));
//
//     print(res.msg);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("PRINT"),
//       ),
//       body: ListView.builder(
//           itemCount: _devices.length,
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () async {
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 await prefs.setString(
//                     'printer_address', _devices[index].address);
//                 _testPrint(_devices[index]);
//               },
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     height: 60,
//                     padding: EdgeInsets.only(left: 10),
//                     alignment: Alignment.centerLeft,
//                     child: Row(
//                       children: <Widget>[
//                         Icon(Icons.print),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Text(_devices[index].name ?? ''),
//                               Text(_devices[index].address),
//                               Text(
//                                 'Click to print receipt',
//                                 style: TextStyle(color: Colors.grey[700]),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Divider(),
//                 ],
//               ),
//             );
//           }),
//       floatingActionButton: StreamBuilder<bool>(
//         stream: printerManager.isScanningStream,
//         initialData: false,
//         builder: (c, snapshot) {
//           if (snapshot.data) {
//             return FloatingActionButton(
//               child: Icon(Icons.stop),
//               onPressed: _stopScanDevices,
//               backgroundColor: Colors.red,
//             );
//           } else {
//             return FloatingActionButton(
//               child: Icon(Icons.search),
//               onPressed: _startScanDevices,
//             );
//           }
//         },
//       ),
//     );
//   }
// }
