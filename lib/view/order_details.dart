import 'dart:ui';

import 'package:blue/global/constant.dart';
import 'package:blue/receipt/custom_front_receipt.dart';
import 'package:blue/receipt/front_receipt.dart';
import 'package:blue/receipt/global_printing.dart';
import 'package:blue/receipt/kitchen_receipt.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blue/model/order_details_model.dart';
import 'package:blue/podo/food_item.dart';
import 'package:blue/podo/sub_item.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../global_provider.dart';
import 'package:blue/global_provider.dart';

import 'printer_credential.dart';

class OrderDetails extends StatefulWidget {
  final int id;
  final FrontReceipt frontReceipt = FrontReceipt();
  final GlobalPrinting globalPrinting = GlobalPrinting();

  OrderDetails(this.id);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoaded = false;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  bool onPressKitchen = true;
  bool onPressFront = true;
   FrontReceipt frontReceipt58 = FrontReceipt();
  CustomFrontReceipt _customFrontReceipt=CustomFrontReceipt();
  // CustomFrontReceipt58 frontReceipt58 = CustomFrontReceipt58();

  FrontReceipt80 frontReceipt80 = FrontReceipt80();
  KitchenReceipt kitchenReceipt = KitchenReceipt();
  KitchenReceipt80 kitchenReceipt80 = KitchenReceipt80();


  @override
  void initState() {
    OrderDetailsModel.getOrderDetails(widget.id).then((value) {
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> orderItems = List();
    int line = 0;
    for (FoodItem foodItem in OrderDetailsModel.foodItems) {
      List<Widget> orderSubItems = List();
      List<SubItem> subItems = foodItem.subItems;

      if (subItems != null) {
        for (SubItem subItem in subItems) {
          orderSubItems.add(Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 8),
            child: Text(
              '~ ${subItem.subItemName}\n    ${subItem.subItemVar}',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ));
        }
      }

      orderItems.add(Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 4),
        child: Row(
          children: [
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${foodItem.quantity} X ${foodItem.itemName}',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    orderSubItems == null
                        ? SizedBox(
                            width: 2,
                            height: 1,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: orderSubItems),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Text(
                  '£${foodItem.itemTotal}',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.right,
                ))
          ],
        ),
      ));
      line++;
      if (line != OrderDetailsModel.foodItems.length) {
        orderItems.add(Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: FDottedLine(
            color: Colors.grey[200],
            width: double.infinity,
            strokeWidth: 1.0,
            dottedLength: 1.0,
            space: 0.0,
          ),
        ));
      }
    }
    final providerGlobal = Provider.of<GlobalProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: [
          providerGlobal.getPrinterConnectionStatus
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrinterCredential()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.print,
                      color: Colors.deepOrange,
                      size: 40,
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrinterCredential()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.print_disabled,
                      color: Colors.deepOrange,
                      size: 40,
                    ),
                  ),
                ),
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.0,
        title: Text(
          'Order Details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(
                const Radius.circular(12.0),
              )),
          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: isLoaded
              ? ListView(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: OrderDetailsModel.customer.deliveryType == 1
                              ? SvgPicture.asset(
                                  'assets/icons/delivery.svg',
                                )
                              : SvgPicture.asset('assets/icons/collection.svg'),
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child:
                            Text('${OrderDetailsModel.customer.customerName}'),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text('${OrderDetailsModel.customer.customerEmail}'),
                          SizedBox(
                            height: 5,
                          ),
                          Text('${OrderDetailsModel.customer.customerContact}')
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order id: ${widget.id}'),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                              'Order placed at : ${OrderDetailsModel.customer.orderDate}'),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                              'Wanted : ${OrderDetailsModel.customer.deliveryTime}'),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            OrderDetailsModel.customer.deliveryType == 1
                                ? 'Delivery Address'
                                : 'Collection Address',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 64.0),
                            child: Text(
                                '${OrderDetailsModel.customer.deliveryAddress} ${OrderDetailsModel.customer.postCode}'),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Payment Method : ${OrderDetailsModel.customer.paymentMethod}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          OrderDetailsModel.customer.paymentMethod != 'cash'
                              ? OrderDetailsModel.customer.paymentStatus == null
                                  ? Text('Not paid')
                                  : Text(
                                      'Payment Status : ${OrderDetailsModel.customer.paymentStatus}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    )
                              : SizedBox()
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 1),
                          child: FDottedLine(
                            color: Colors.grey[300],
                            width: double.infinity,
                            strokeWidth: 1.0,
                            dottedLength: 3.0,
                            space: 2.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: const Offset(-6.0, 0.0),
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                            Spacer(),
                            Transform.translate(
                              offset: const Offset(6.0, 0.0),
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.grey[200],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 4),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text(
                                ' Item',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                'Price',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ))
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: orderItems,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 1),
                          child: FDottedLine(
                            color: Colors.grey[300],
                            width: double.infinity,
                            strokeWidth: 1.0,
                            dottedLength: 3.0,
                            space: 2.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: const Offset(-6.0, 0.0),
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                            Spacer(),
                            Transform.translate(
                              offset: const Offset(6.0, 0.0),
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.grey[200],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                              '£${OrderDetailsModel.customer.total.toStringAsFixed(2)==null?"null":OrderDetailsModel.customer.total.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Charge',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                              '£${OrderDetailsModel.customer.deliveryCharge.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Service Charge',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                              '£${OrderDetailsModel.customer.serviceCharge.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 16.0, right: 16, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tax Fee',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                              '£${OrderDetailsModel.customer.taxFee.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 16.0, right: 16, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bag Charge',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                              '£${OrderDetailsModel.customer.bagCharge.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text('(-) £${OrderDetailsModel.customer.discount}',
                              style: TextStyle(fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, top: 4, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total to pay',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text('£${OrderDetailsModel.customer.totalToPay}',
                              style: TextStyle(fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        onPressFront
                            ? Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 2, top: 4, bottom: 20),
                                    child: RaisedButton(
                                        color: Colors.green,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Text(
                                            'Print Front Receipt',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            onPressFront = false;
                                          });

                                          if (await bluetooth.isConnected) {
                                              Future.delayed(
                                                      Duration(seconds: 3))
                                                  .then((value) {
                                                    if(mounted){
                                                      setState(() {
                                                        onPressFront = true;
                                                      });
                                                    }

                                              });
                                              print(
                                                  '---------${Static.Paper_Size}');
                                              if (Static.Paper_Size == "58mm") {
                                                frontReceipt58.frontReceipt(0, widget.id);
                                              } else if (Static.Paper_Size=="80mm"){
                                                frontReceipt80.frontReceipt(0, widget.id);
                                              }
                                              else{
                                                _customFrontReceipt.frontReceipt(0, widget.id);
                                              }
                                              // bluetooth.printCustom("", 6, 0);
                                            } else {
                                              setState(() {
                                                onPressFront = true;
                                              });
                                              Get.snackbar(
                                                "Printer alert!",
                                                "Something went wrong, please check your printer connection",
                                                snackPosition:
                                                    SnackPosition.TOP,
                                                backgroundColor:
                                                    Colors.red[300],
                                                colorText: Colors.white,
                                                duration: Duration(seconds: 5),
                                              );
                                            }

                                        })),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 50, right: 50, top: 4, bottom: 20),
                                child: CircularProgressIndicator(
                                    color: Colors.deepOrange),
                              ),
                        onPressKitchen
                            ? Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2, right: 0, top: 4, bottom: 20),
                                    child: RaisedButton(
                                        color: Colors.deepOrange,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Text(
                                            'Print Kitchen Receipt',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            onPressKitchen = false;
                                            print(
                                                'onPressKitchen----$onPressKitchen');
                                          });

                                            if (await bluetooth.isConnected) {
                                              Future.delayed(
                                                      Duration(seconds: 3))
                                                  .then((value) {
                                                    if(mounted){
                                                      setState(() {
                                                        onPressKitchen = true;
                                                      });
                                                    }

                                              });

                                              print(
                                                  '---------${Static.Paper_Size}');
                                              if (Static
                                                  .kitchenReceiptSameAsFront) {
                                                if (Static.Paper_Size ==
                                                    "58mm") {
                                                  frontReceipt58.frontReceipt(
                                                      1, widget.id);
                                                } else if(Static.Paper_Size=="80mm-large") {
                                                 _customFrontReceipt.frontReceipt(
                                                     1, widget.id);
                                                }
                                                else{
                                                  frontReceipt80.frontReceipt(
                                                      1, widget.id);
                                                }
                                              } else {
                                                if (Static.Paper_Size ==
                                                    "58mm") {
                                                  kitchenReceipt.kitchenReceipt(
                                                      widget.id);
                                                } else {
                                                  kitchenReceipt80
                                                      .kitchenReceipt(
                                                          widget.id);
                                                }
                                              }
                                            } else {
                                              setState(() {
                                                onPressKitchen = true;
                                                print(
                                                    'onPressKitchen----$onPressKitchen');
                                              });
                                              Get.snackbar(
                                                "Printer alert!",
                                                "Something went wrong, please check your printer connection",
                                                snackPosition:
                                                    SnackPosition.TOP,
                                                backgroundColor:
                                                    Colors.red[300],
                                                colorText: Colors.white,
                                                duration: Duration(seconds: 5),
                                              );
                                            }

                                        })))
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 50, right: 50, top: 4, bottom: 20),
                                child: CircularProgressIndicator(
                                    color: Colors.deepOrange),
                              )
                      ],
                    )

                  ],
                )
              : Column(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[300],
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.grey[200],
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child:
                                    OrderDetailsModel.customer.deliveryType == 1
                                        ? SvgPicture.asset(
                                            'assets/icons/delivery.svg')
                                        : SvgPicture.asset(
                                            'assets/icons/collection.svg'),
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('Loading...'),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Loading...'),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Loading...')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: Center(
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey[200],
                              highlightColor: Colors.grey[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                      color: Colors.deepOrange),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Please wait..',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ))),
                    )
                  ],
                )),
    );
  }
}
