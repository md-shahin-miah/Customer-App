import 'dart:ui';

// import 'package:audioplayers/audio_cache.dart';

import 'package:blue/receipt/front_receipt.dart';
import 'package:blue/receipt/global_printing.dart';
import 'package:flutter/material.dart';
import 'package:blue/model/order_details_model.dart';
import 'package:blue/view/order_details.dart';

// import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';

class NotificationPage extends StatefulWidget {
  final int id;

  NotificationPage(this.id);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const int BREAK_TEXT_LENGTH = 15;

  // static AudioCache player = new AudioCache();
  static const alarmAudioPath = "hello.wav";

  // PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  // List<PrinterBluetooth> _devices = [];
  // PrinterBluetooth _device;
  bool isPrinterFound = true;
  FrontReceipt frontReceipt;
  // KitchenReceipt kitchenReceipt;
  GlobalPrinting globalPrinting;

  @override
  void initState() {
    super.initState();

    frontReceipt = FrontReceipt();
    // kitchenReceipt = KitchenReceipt();

    OrderDetailsModel.getOrderDetails(widget.id).then((value) {
      print('Order Data Found------------------${widget.id}');
      // print(
      //     'Order Data customerName------------------${OrderDetailsModel.customer.customerName}');
      // print(
      //     'Static.Number_of_front_receipt_Value ------------------------${Static.Number_of_front_receipt_Value}');
      // globalPrinting=GlobalPrinting();



      // globalPrinting.printOrder(widget.id);


      // if(Static.autoPrintOrder){
      //   if (Static.Number_of_front_receipt_Value == 'One') {
      //     frontReceipt.frontReceipt();
      //
      //
      //     if(Static.kitchenReceiptDefault){
      //       printKitchenReceipt();
      //     }
      //     if(Static.kitchenReceiptSameAsFront){
      //       frontReceipt.frontReceipt();
      //     }
      //
      //   } else if (Static.Number_of_front_receipt_Value == 'Two') {
      //     for (int i = 0; i < 2; i++) {
      //       frontReceipt.frontReceipt();
      //       if (i == 1) {
      //         if(Static.kitchenReceiptDefault){
      //           printKitchenReceipt();
      //         }
      //         if(Static.kitchenReceiptSameAsFront){
      //           frontReceipt.frontReceipt();
      //         }
      //       }
      //     }
      //   } else if (Static.Number_of_front_receipt_Value == 'Three') {
      //     for (int i = 0; i < 3; i++) {
      //       frontReceipt.frontReceipt();
      //       if (i == 2) {
      //         if(Static.kitchenReceiptDefault){
      //           printKitchenReceipt();
      //         }
      //         if(Static.kitchenReceiptSameAsFront){
      //           frontReceipt.frontReceipt();
      //         }
      //       }
      //     }
      //   } else if (Static.Number_of_front_receipt_Value == 'Four') {
      //     for (int i = 0; i < 4; i++) {
      //       frontReceipt.frontReceipt();
      //       if (i == 3) {
      //         if(Static.kitchenReceiptDefault){
      //           printKitchenReceipt();
      //         }
      //         if(Static.kitchenReceiptSameAsFront){
      //           frontReceipt.frontReceipt();
      //         }
      //       }
      //     }
      //   } else if (Static.Number_of_front_receipt_Value == 'Five') {
      //     for (int i = 0; i < 5; i++) {
      //       frontReceipt.frontReceipt();
      //       if (i == 4) {
      //         if(Static.kitchenReceiptDefault){
      //           printKitchenReceipt();
      //         }
      //         if(Static.kitchenReceiptSameAsFront){
      //           frontReceipt.frontReceipt();
      //         }
      //       }
      //     }
      //   }
      // }



      // print('connected device-------------------${PrinterHome.connected}');
      // if(PrinterHome.connected){
      //   print('connected device-------------------${PrinterHome.device}');
      //   frontReceipt.sample();
      // }
      // else{
      //   print('no connected device -----------------------------  ${PrinterHome.device}');
      // }
      // else{
      //   print('connected device-------------------${PrinterHome.device}');
      //   frontReceipt.sample();
      // }
      // SharedPreferences.getInstance().then((prefs) {
      //   String printerAddress = prefs.getString('printer_address') ?? '-1';
      //   String printerName = prefs.getString('printer_name');
      //   int printerType = prefs.getInt("printer_type");
      //
      //   if (printerAddress == "-1") {
      //     printerManager.scanResults.listen((devices) async {
      //       setState(() {
      //         _devices = devices;
      //       });
      //     });
      //   } else {
      //     BluetoothDevice de = BluetoothDevice();
      //     de.name = printerName;
      //     de.address = printerAddress;
      //     de.type = printerType;
      //     PrinterBluetooth bl = PrinterBluetooth(de);
      //     _printReceipt(bl);
      //   }
      // });
    });
  }

  // void _printReceipt(PrinterBluetooth printer) async {
  //   printerManager.selectPrinter(printer);
  //
  //   const PaperSize paper = PaperSize.mm58;
  //
  //   final PosPrintResult res = await printerManager
  //       .printTicket(await demoReceipt(paper), queueSleepTimeMs: 50);
  //
  //   print(res.msg);
  // }
  //
  // Future<Ticket> demoReceipt(PaperSize paper) async {
  //   final Ticket ticket = Ticket(paper);
  //
  //   ticket.text(MyUtils.breakText(HomeModel.businessName, 10),
  //       styles: PosStyles(
  //         align: PosAlign.center,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ),
  //       linesAfter: 1);
  //
  //   ticket.text('${HomeModel.businessAddress}',
  //       styles: PosStyles(align: PosAlign.center));
  //   ticket.text('${HomeModel.businessPostCode}',
  //       styles: PosStyles(align: PosAlign.center));
  //   ticket.text('Tel: ${HomeModel.businessContact}',
  //       styles: PosStyles(align: PosAlign.center));
  //   ticket.text(
  //       OrderDetailsModel.customer.deliveryType == 1
  //           ? 'Web Delivery'
  //           : 'Web Collection',
  //       styles: PosStyles(align: PosAlign.center),
  //       linesAfter: 1);
  //
  //   ticket.text(OrderDetailsModel.customer.customerName,
  //       styles: PosStyles(align: PosAlign.left));
  //   ticket.text(OrderDetailsModel.customer.customerContact,
  //       styles: PosStyles(align: PosAlign.left));
  //
  //   ticket.text(
  //       '${OrderDetailsModel.customer.deliveryAddress}\n${OrderDetailsModel.customer.postCode}',
  //       styles: PosStyles(
  //         align: PosAlign.left,
  //       ),
  //       linesAfter: 1);
  //
  //   ticket.row([
  //     PosColumn(text: 'Item', width: 8, styles: PosStyles(bold: true)),
  //     PosColumn(
  //         text: 'Price',
  //         width: 4,
  //         styles: PosStyles(align: PosAlign.right, bold: true)),
  //   ]);
  //
  //   ticket.hr(ch: ' ', linesAfter: 1);
  //
  //   for (FoodItem foodItem in OrderDetailsModel.foodItems) {
  //     bool isLongName = false;
  //
  //     String itemName = MyUtils.breakText(foodItem.itemName, BREAK_TEXT_LENGTH);
  //
  //     if (itemName.length > BREAK_TEXT_LENGTH + 5) {
  //       isLongName = true;
  //     }
  //
  //     ticket.row([
  //       PosColumn(
  //           text: '${foodItem.quantity} x $itemName',
  //           width: 3,
  //           styles: PosStyles(align: PosAlign.left)),
  //       PosColumn(text: ' ', width: 3, styles: PosStyles(align: PosAlign.left)),
  //       PosColumn(
  //           text: '${foodItem.itemTotal.toStringAsFixed(2)}',
  //           width: 6,
  //           styles: PosStyles(align: PosAlign.right)),
  //     ]);
  //
  //     List<SubItem> subItems = foodItem.subItems;
  //
  //     if (subItems != null) {
  //       if (isLongName) ticket.hr(ch: ' ', linesAfter: 1);
  //       for (SubItem subItem in subItems) {
  //         ticket.row([
  //           PosColumn(
  //               text:
  //                   '   ~ ${subItem.subItemName}\n       ${subItem.subItemVar}',
  //               width: 12,
  //               styles: PosStyles(align: PosAlign.left)),
  //         ]);
  //       }
  //     }
  //     ticket.hr(ch: '-', linesAfter: 1);
  //   }
  //   ticket.row([
  //     PosColumn(
  //         text: 'Total', width: 6, styles: PosStyles(align: PosAlign.left)),
  //     PosColumn(
  //         text: '${OrderDetailsModel.customer.total.toStringAsFixed(2)}',
  //         width: 6,
  //         styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //
  //   ticket.row([
  //     PosColumn(
  //         text: 'Delivery Charge',
  //         width: 6,
  //         styles: PosStyles(align: PosAlign.left)),
  //     PosColumn(
  //         text:
  //             '${OrderDetailsModel.customer.deliveryCharge.toStringAsFixed(2)}',
  //         width: 6,
  //         styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //
  //   ticket.row([
  //     PosColumn(
  //         text: 'Service Charge',
  //         width: 6,
  //         styles: PosStyles(align: PosAlign.left)),
  //     PosColumn(
  //         text:
  //             '${OrderDetailsModel.customer.serviceCharge.toStringAsFixed(2)}',
  //         width: 6,
  //         styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   ticket.row([
  //     PosColumn(
  //         text: 'Discount', width: 6, styles: PosStyles(align: PosAlign.left)),
  //     PosColumn(
  //         text: '${OrderDetailsModel.customer.discount.toStringAsFixed(2)}',
  //         width: 6,
  //         styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //
  //   ticket.row([
  //     PosColumn(
  //         text: 'Total to pay',
  //         width: 6,
  //         styles: PosStyles(align: PosAlign.left, bold: true)),
  //     PosColumn(
  //         text: '${OrderDetailsModel.customer.totalToPay}',
  //         width: 6,
  //         styles: PosStyles(align: PosAlign.right, bold: true)),
  //   ]);
  //   ticket.hr(ch: "_", linesAfter: 1);
  //
  //   ticket.text('Order placed at\n${OrderDetailsModel.customer.orderDate}',
  //       styles: PosStyles(align: PosAlign.left));
  //
  //   ticket.text('Wanted ${OrderDetailsModel.customer.deliveryTime}',
  //       styles: PosStyles(align: PosAlign.left));
  //
  //   ticket.text('Payment Method : ${OrderDetailsModel.customer.paymentMethod}',
  //       styles: PosStyles(align: PosAlign.left));
  //
  //   if (OrderDetailsModel.customer.paymentMethod == "online") {
  //     ticket.text(
  //         OrderDetailsModel.customer.paymentStatus == null
  //             ? 'Payment Status : Not paid'
  //             : 'Payment Status  ${OrderDetailsModel.customer.paymentStatus}',
  //         styles: PosStyles(align: PosAlign.left));
  //   }
  //
  //   ticket.hr(ch: ' ', linesAfter: 1);
  //   ticket.text('Thank you',
  //       styles: PosStyles(align: PosAlign.center, bold: true));
  //
  //   ticket.feed(1);
  //   ticket.cut();
  //   return ticket;
  // }

  @override
  Widget build(BuildContext context) {
    // player.play(alarmAudioPath);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Icon(
              Icons.notifications,
              size: 70,
              color: Colors.deepOrange,
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'New order has been arrived!',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    color: Colors.redAccent[200],
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.green[400],
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => OrderDetails(widget.id)));
                    },
                    child: Text(
                      'View',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // printKitchenReceipt() {
  //   if (Static.Number_of_kitchen_receipt_Value == 'One') {
  //     kitchenReceipt.kitchenReceipt(widget.id);
  //   } else if (Static.Number_of_kitchen_receipt_Value == 'Two') {
  //     for (int i = 0; i < 2; i++) {
  //       kitchenReceipt.kitchenReceipt(widget.id);
  //     }
  //   } else if (Static.Number_of_kitchen_receipt_Value == 'Three') {
  //     for (int i = 0; i < 3; i++) {
  //       kitchenReceipt.kitchenReceipt(widget.id);
  //     }
  //   } else if (Static.Number_of_kitchen_receipt_Value == 'Four') {
  //     for (int i = 0; i < 4; i++) {
  //       kitchenReceipt.kitchenReceipt(widget.id);
  //     }
  //   } else if (Static.Number_of_kitchen_receipt_Value == 'Five') {
  //     for (int i = 0; i < 5; i++) {
  //       kitchenReceipt.kitchenReceipt(widget.id);
  //     }
  //   }
  // }
}
