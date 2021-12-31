import 'dart:ffi';

import 'package:blue/global/constant.dart';
import 'package:blue/model/home_model.dart';
import 'package:blue/model/order_details_model.dart';
import 'package:blue/model/order_model.dart';
import 'package:blue/podo/food_item.dart';
import 'package:blue/podo/sub_item.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter_restart/flutter_restart.dart';



class FrontReceipt {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;


  static const int TOTAL_CHARACTER = 32;

  static const num SPACE_BEFORE_PRICE = 18;

  static const int NORMAL_SIZE_TEXT = 0;
  static const int BOLD_SIZE_TEXT = 10;
  // static const int MEDIUM_BOLD_SIZE_TEXT = 6;
  // static const int LARGE_BOLD_SIZE_TEXT = 3;
  static const int EXTRA_LARGE_BOLD_SIZE_TEXT = 16;

  static const int ESC_ALIGN_LEFT = 0;
  static const int ESC_ALIGN_CENTER = 1;
  static const int ESC_ALIGN_RIGHT = 2;




  frontReceipt(int type, int orderId) async {

    // if(OrderDetailsModel.customer.total==null){
    //   print(' customerTotal Null----------------------');
    // bool result=  await OrderDetailsModel.getOrderDetails(orderId);
    //
    // if(!result){
    //   FlutterRestart.restartApp();
    // }
    //
    // }
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

//     var response = await http.get("IMAGE_URL");
//     Uint8List bytes = response.bodyBytes;


    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        if (Static.kitchenReceiptSameAsFront && type == 1) {
          bluetooth.printCustom(
              '        Kitchen Receipt        ', EXTRA_LARGE_BOLD_SIZE_TEXT, 1);

          bluetooth.printCustom(
              '       ------------------       ', BOLD_SIZE_TEXT, 1);
          bluetooth.printNewLine();
        } else {
          bluetooth.printCustom(
              HomeModel.businessName, EXTRA_LARGE_BOLD_SIZE_TEXT, 1);
        }

        if (!Static.hideRestaurantAddressOnReceipt) {
          bluetooth.printCustom(HomeModel.businessAddress, BOLD_SIZE_TEXT, 1);
        }


        bluetooth.printCustom(HomeModel.businessPostCode, BOLD_SIZE_TEXT, 1);
        bluetooth.printCustom(
            'Tel:' + HomeModel.businessContact, BOLD_SIZE_TEXT, 1);
        bluetooth.printCustom(Api.BusinessUrl, BOLD_SIZE_TEXT, 1);

        String deliveryMethod = OrderDetailsModel.customer.deliveryType == 1
            ? "Delivery"
            : "Collection";

        bluetooth.printCustom("Web " + deliveryMethod, BOLD_SIZE_TEXT, 1);
        if (Static.displayOrderIdInReceipt) {
          bluetooth.printCustom(
              'Order ID - ${orderId.toString()}', BOLD_SIZE_TEXT, 1);
        }
        bluetooth.printNewLine();

        bluetooth.printCustom(
            OrderDetailsModel.customer.customerName, BOLD_SIZE_TEXT, 0);
        bluetooth.printCustom(
            OrderDetailsModel.customer.customerContact, BOLD_SIZE_TEXT, 0);
        if(OrderDetailsModel.customer.deliveryType==1) {
          bluetooth.printCustom(
              OrderDetailsModel.customer.deliveryAddress, BOLD_SIZE_TEXT, 0);
          bluetooth.printCustom(
              OrderDetailsModel.customer.postCode, BOLD_SIZE_TEXT, 0);
        }
        bluetooth.printNewLine();
        bluetooth.printCustom(writeDash(31), BOLD_SIZE_TEXT, 1);
        bluetooth.printLeftRight("Item", "Price (GBP)", 1);
        bluetooth.printCustom(writeDash(31), BOLD_SIZE_TEXT, 1);


        print("OrderDetailsModel.foodItems---------------${OrderDetailsModel.foodItems.length} $orderId");

        for (FoodItem foodItem in OrderDetailsModel.foodItems) {
          final itemName = (foodItem.itemName).replaceAll(RegExp("\’"), '');

          print("itemName----------------------$itemName");
          String breakT = breakText('${foodItem.quantity} X ', itemName,
              (foodItem.itemPrice).toStringAsFixed(2));
          bluetooth.printCustom(breakT, BOLD_SIZE_TEXT, 0);
          List<SubItem> subItems = foodItem.subItems;

          print("print process-----------------------------front receipt------------------------1-----------------------$orderId-----------OrderDetailsModel.foodItems-----${OrderDetailsModel.foodItems.length}");
          print("print process-----------------------------front receipt------------------------2------------------------$orderId------foodItem.itemName-----------${foodItem.itemName}");


          if (subItems != null) {
            print("print process-----------------------------front receipt------------------------3----------------------$orderId--------subItems.length------------${subItems.length}");
            for (SubItem subItem in subItems) {
              print("print process-----------------------------front receipt------------------------4-------------------$orderId---------subItem.subItemName---${subItem.subItemName}---------subItems----${subItems.length}");
              final subitemVar =
              (subItem.subItemVar).replaceAll(RegExp("\’"), '');
              final subItemName =
              (subItem.subItemName).replaceAll(RegExp("\’"), '');
              bluetooth.printCustom(
                  '   * $subItemName\n       $subitemVar', BOLD_SIZE_TEXT, 0);
            }
          }
          var specialReq = foodItem.specialRequest;
          if (specialReq != null) {
            bluetooth.printCustom(
                "+ Special Request: $specialReq", BOLD_SIZE_TEXT, 0);
          }
          bluetooth.printCustom(writeDash(31), BOLD_SIZE_TEXT, 1);
        }

        bluetooth.printNewLine();
        bluetooth.printLeftRight(
            "Total",
            (OrderDetailsModel.customer.total).toStringAsFixed(2),
            BOLD_SIZE_TEXT);

        if (OrderDetailsModel.customer.deliveryCharge !=0.00) {
          bluetooth.printLeftRight(
              "Delivery Charge",
              (OrderDetailsModel.customer.deliveryCharge).toStringAsFixed(2),
              BOLD_SIZE_TEXT);
        }

        if (OrderDetailsModel.customer.serviceCharge !=0.00) {
          bluetooth.printLeftRight(
              "Service Charge",
              (OrderDetailsModel.customer.serviceCharge).toStringAsFixed(2),
              BOLD_SIZE_TEXT);
        }
        if (OrderDetailsModel.customer.taxFee !=0) {
          bluetooth.printLeftRight(
              "Tax Fee",
              (OrderDetailsModel.customer.taxFee).toStringAsFixed(2),
              BOLD_SIZE_TEXT);
        }
        if (OrderDetailsModel.customer.bagCharge !=0) {
          bluetooth.printLeftRight(
              "Bag Charge",
              (OrderDetailsModel.customer.bagCharge).toStringAsFixed(2),
              BOLD_SIZE_TEXT);
        }

        if (OrderDetailsModel.customer.discount!=0.00) {
          bluetooth.printLeftRight(
              "Discount",
              "(-) " +(OrderDetailsModel.customer.discount).toStringAsFixed(2),
              BOLD_SIZE_TEXT);
        }

        bluetooth.printCustom(writeDash(31), BOLD_SIZE_TEXT, 1);
        bluetooth.printLeftRight(
            "Total To Pay",
            ' GBP ' +
                double.parse(OrderDetailsModel.customer.totalToPay)
                    .toStringAsFixed(2),
            BOLD_SIZE_TEXT);
        bluetooth.printNewLine();

        bluetooth.printCustom("Order placed at", BOLD_SIZE_TEXT, 0);
        bluetooth.printCustom((OrderDetailsModel.customer.orderDate).toString(),
            BOLD_SIZE_TEXT, 0);

        bluetooth.printCustom(
            "Wanted " + (OrderDetailsModel.customer.deliveryTime).toString(),
            BOLD_SIZE_TEXT,
            0);

        // bluetooth.printCustom((OrderDetailsModel.customer.).toString(), 0, 0);
        bluetooth.printCustom(
            "Payment Method: " + OrderDetailsModel.customer.paymentMethod,
            BOLD_SIZE_TEXT,
            0);
        if (OrderDetailsModel.customer.paymentMethod != "cash") {
          bluetooth.printCustom(
              "Payment Status: " + OrderDetailsModel.customer.paymentStatus,
              BOLD_SIZE_TEXT,
              0);
        }

        bluetooth.printNewLine();
        bluetooth.printCustom("Thank You", BOLD_SIZE_TEXT, 1);

        if(OrderDetailsModel.customer.deviceInfo!=null){
          bluetooth.printCustom("Order Placed From - ${OrderDetailsModel.customer.deviceInfo}", BOLD_SIZE_TEXT, 1);
        }

        Static.isPrintedLastLine=true;
        print('Static.isPrintedLastLine-----------------${Static.isPrintedLastLine}');



        bluetooth.printCustom("Powered by www.ordere.co.uk", BOLD_SIZE_TEXT, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom('', 0, 0);
        bluetooth.printCustom('', 0, 0);
        bluetooth.printCustom('', 0, 0);
        print('Static.isPrintedLastLine-----------------${Static.isPrintedLastLine}');

        bluetooth.paperCut();
      }
    });


  }

  static String breakText(String piece, String text, String price) {
    String formattedText = "$piece";
    String tempText = "$piece";
    List<String> parts = text.split(" ");
    int breakCount = 0;
    for (int i = 0; i < parts.length; i++) {

      formattedText += (parts[i] + " ");
      tempText += parts[i] + " ";
      print('lengthof ${tempText.length}');
      if ((tempText.length) >= 20) {
        breakCount++;
        if (breakCount == 1) {
          formattedText +=
          '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
          breakCount = 2;
        }
        formattedText += "\n";
        tempText = "";
      }
      // else {
      //   formattedText += (parts[i] + " ");
      //   tempText += parts[i] + " ";
      // }
    }
    if (breakCount == 0) {
      formattedText +=
      '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
    }

    print(
        'formattedText length-------------------------------${formattedText.length}-------');

    return formattedText;
  }

  static String writeSpace(int length) {
    print('length---------------------------------------$length');
    String space = "";
    for (int i = 0; i < length; i++) {
      space += " ";
    }
    return space;
  }

  static String writeDash(int length) {
    print('length---------------------------------------$length');
    String dash = "";
    for (int i = 0; i < length; i++) {
      dash += "-";
    }
    return dash;
  }
}
// class FrontReceipt {
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
//
//
//   static const int TOTAL_CHARACTER = 32;
//
//   static const num SPACE_BEFORE_PRICE = 18;
//
//   static const int NORMAL_SIZE_TEXT = 0;
//   static const int BOLD_SIZE_TEXT = 1;
//   static const int MEDIUM_BOLD_SIZE_TEXT = 2;
//   static const int LARGE_BOLD_SIZE_TEXT = 3;
//   static const int EXTRA_LARGE_BOLD_SIZE_TEXT = 3;
//
//   static const int ESC_ALIGN_LEFT = 0;
//   static const int ESC_ALIGN_CENTER = 1;
//   static const int ESC_ALIGN_RIGHT = 2;
//
//
//
//
//   frontReceipt(int type, int orderId) async {
//
//     // if(OrderDetailsModel.customer.total==null){
//     //   print(' customerTotal Null----------------------');
//     // bool result=  await OrderDetailsModel.getOrderDetails(orderId);
//     //
//     // if(!result){
//     //   FlutterRestart.restartApp();
//     // }
//     //
//     // }
//     //SIZE
//     // 0- normal size text
//     // 1- only bold text
//     // 2- bold with medium text
//     // 3- bold with large text
//     //ALIGN
//     // 0- ESC_ALIGN_LEFT
//     // 1- ESC_ALIGN_CENTER
//     // 2- ESC_ALIGN_RIGHT
//
// //     var response = await http.get("IMAGE_URL");
// //     Uint8List bytes = response.bodyBytes;
//
//
//     bluetooth.isConnected.then((isConnected) {
//       if (isConnected) {
//         if (Static.kitchenReceiptSameAsFront && type == 1) {
//           bluetooth.printCustom(
//               '        Kitchen Receipt        ', EXTRA_LARGE_BOLD_SIZE_TEXT, 1);
//
//           bluetooth.printCustom(
//               '       ------------------       ', BOLD_SIZE_TEXT, 1);
//           bluetooth.printNewLine();
//         } else {
//           bluetooth.printCustom(
//               HomeModel.businessName, EXTRA_LARGE_BOLD_SIZE_TEXT, 1);
//         }
//
//         if (!Static.hideRestaurantAddressOnReceipt) {
//           bluetooth.printCustom(HomeModel.businessAddress, BOLD_SIZE_TEXT, 1);
//         }
//
//
//         bluetooth.printCustom(HomeModel.businessPostCode, BOLD_SIZE_TEXT, 1);
//         bluetooth.printCustom(
//             'Tel:' + HomeModel.businessContact, BOLD_SIZE_TEXT, 1);
//         bluetooth.printCustom(Api.BusinessUrl, BOLD_SIZE_TEXT, 1);
//
//         String deliveryMethod = OrderDetailsModel.customer.deliveryType == 1
//             ? "Delivery"
//             : "Collection";
//
//         bluetooth.printCustom("Web " + deliveryMethod, BOLD_SIZE_TEXT, 1);
//         if (Static.displayOrderIdInReceipt) {
//           bluetooth.printCustom(
//               'Order ID - ${orderId.toString()}', BOLD_SIZE_TEXT, 1);
//         }
//         bluetooth.printNewLine();
//
//         bluetooth.printCustom(
//             OrderDetailsModel.customer.customerName, BOLD_SIZE_TEXT, 0);
//         bluetooth.printCustom(
//             OrderDetailsModel.customer.customerContact, BOLD_SIZE_TEXT, 0);
//         if(OrderDetailsModel.customer.deliveryType==1) {
//           bluetooth.printCustom(
//               OrderDetailsModel.customer.deliveryAddress, BOLD_SIZE_TEXT, 0);
//           bluetooth.printCustom(
//               OrderDetailsModel.customer.postCode, BOLD_SIZE_TEXT, 0);
//         }
//         bluetooth.printNewLine();
//         bluetooth.printCustom(writeDash(31), BOLD_SIZE_TEXT, 1);
//         bluetooth.printLeftRight("Item", "Price (GBP)", 1);
//         bluetooth.printCustom(writeDash(31), BOLD_SIZE_TEXT, 1);
//
//
//         print("OrderDetailsModel.foodItems---------------${OrderDetailsModel.foodItems.length} $orderId");
//
//         for (FoodItem foodItem in OrderDetailsModel.foodItems) {
//           final itemName = (foodItem.itemName).replaceAll(RegExp("\’"), '');
//
//           print("itemName----------------------$itemName");
//           String breakT = breakText('${foodItem.quantity} X ', itemName,
//               (foodItem.itemPrice).toStringAsFixed(2));
//           bluetooth.printCustom(breakT, BOLD_SIZE_TEXT, 0);
//           List<SubItem> subItems = foodItem.subItems;
//
//           print("print process-----------------------------front receipt------------------------1-----------------------$orderId-----------OrderDetailsModel.foodItems-----${OrderDetailsModel.foodItems.length}");
//           print("print process-----------------------------front receipt------------------------2------------------------$orderId------foodItem.itemName-----------${foodItem.itemName}");
//
//
//           if (subItems != null) {
//             print("print process-----------------------------front receipt------------------------3----------------------$orderId--------subItems.length------------${subItems.length}");
//             for (SubItem subItem in subItems) {
//               print("print process-----------------------------front receipt------------------------4-------------------$orderId---------subItem.subItemName---${subItem.subItemName}---------subItems----${subItems.length}");
//               final subitemVar =
//               (subItem.subItemVar).replaceAll(RegExp("\’"), '');
//               final subItemName =
//               (subItem.subItemName).replaceAll(RegExp("\’"), '');
//               bluetooth.printCustom(
//                   '   * $subItemName\n       $subitemVar', 1, 0);
//             }
//           }
//           var specialReq = foodItem.specialRequest;
//           if (specialReq != null) {
//             bluetooth.printCustom(
//                 "+ Special Request: $specialReq", BOLD_SIZE_TEXT, 0);
//           }
//           bluetooth.printCustom(writeDash(31), BOLD_SIZE_TEXT, 1);
//         }
//
//         bluetooth.printNewLine();
//         bluetooth.printLeftRight(
//             "Total",
//             (OrderDetailsModel.customer.total).toStringAsFixed(2),
//             BOLD_SIZE_TEXT);
//
//         if (OrderDetailsModel.customer.deliveryCharge !=0.00) {
//           bluetooth.printLeftRight(
//               "Delivery Charge",
//               (OrderDetailsModel.customer.deliveryCharge).toStringAsFixed(2),
//               BOLD_SIZE_TEXT);
//         }
//
//         if (OrderDetailsModel.customer.serviceCharge !=0.00) {
//           bluetooth.printLeftRight(
//               "Service Charge",
//               (OrderDetailsModel.customer.serviceCharge).toStringAsFixed(2),
//               BOLD_SIZE_TEXT);
//         }
//         if (OrderDetailsModel.customer.taxFee !=0) {
//           bluetooth.printLeftRight(
//               "Tax Fee",
//               (OrderDetailsModel.customer.taxFee).toStringAsFixed(2),
//               BOLD_SIZE_TEXT);
//         }
//         if (OrderDetailsModel.customer.bagCharge !=0) {
//           bluetooth.printLeftRight(
//               "Bag Charge",
//               (OrderDetailsModel.customer.bagCharge).toStringAsFixed(2),
//               BOLD_SIZE_TEXT);
//         }
//
//         if (OrderDetailsModel.customer.discount!=0.00) {
//           bluetooth.printLeftRight(
//               "Discount",
//               "(-) " +(OrderDetailsModel.customer.discount).toStringAsFixed(2),
//               BOLD_SIZE_TEXT);
//         }
//
//         bluetooth.printCustom(writeDash(31), BOLD_SIZE_TEXT, 1);
//         bluetooth.printLeftRight(
//             "Total To Pay",
//             ' GBP ' +
//                 double.parse(OrderDetailsModel.customer.totalToPay)
//                     .toStringAsFixed(2),
//             BOLD_SIZE_TEXT);
//         bluetooth.printNewLine();
//
//         bluetooth.printCustom("Order placed at", BOLD_SIZE_TEXT, 0);
//         bluetooth.printCustom((OrderDetailsModel.customer.orderDate).toString(),
//             BOLD_SIZE_TEXT, 0);
//
//         bluetooth.printCustom(
//             "Wanted " + (OrderDetailsModel.customer.deliveryTime).toString(),
//             BOLD_SIZE_TEXT,
//             0);
//
//         // bluetooth.printCustom((OrderDetailsModel.customer.).toString(), 0, 0);
//         bluetooth.printCustom(
//             "Payment Method: " + OrderDetailsModel.customer.paymentMethod,
//             BOLD_SIZE_TEXT,
//             0);
//         if (OrderDetailsModel.customer.paymentMethod != "cash") {
//           bluetooth.printCustom(
//               "Payment Status: " + OrderDetailsModel.customer.paymentStatus,
//               BOLD_SIZE_TEXT,
//               0);
//         }
//
//         bluetooth.printNewLine();
//         bluetooth.printCustom("Thank You", 2, 1);
//
//         if(OrderDetailsModel.customer.deviceInfo!=null){
//           bluetooth.printCustom("Order Placed From - ${OrderDetailsModel.customer.deviceInfo}", BOLD_SIZE_TEXT, 1);
//         }
//
//         Static.isPrintedLastLine=true;
//         print('Static.isPrintedLastLine-----------------${Static.isPrintedLastLine}');
//
//
//
//         bluetooth.printCustom("Powered by www.ordere.co.uk", BOLD_SIZE_TEXT, 1);
//         bluetooth.printNewLine();
//         bluetooth.printCustom('', 0, 0);
//         bluetooth.printCustom('', 0, 0);
//         bluetooth.printCustom('', 0, 0);
//         print('Static.isPrintedLastLine-----------------${Static.isPrintedLastLine}');
//
//         bluetooth.paperCut();
//       }
//     });
//
//
//   }
//
//   static String breakText(String piece, String text, String price) {
//     String formattedText = "$piece";
//     String tempText = "$piece";
//     List<String> parts = text.split(" ");
//     int breakCount = 0;
//     for (int i = 0; i < parts.length; i++) {
//
//       formattedText += (parts[i] + " ");
//       tempText += parts[i] + " ";
//       print('lengthof ${tempText.length}');
//       if ((tempText.length) >= 20) {
//         breakCount++;
//         if (breakCount == 1) {
//           formattedText +=
//               '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
//           breakCount = 2;
//         }
//         formattedText += "\n";
//         tempText = "";
//       }
//       // else {
//       //   formattedText += (parts[i] + " ");
//       //   tempText += parts[i] + " ";
//       // }
//     }
//     if (breakCount == 0) {
//       formattedText +=
//           '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
//     }
//
//     print(
//         'formattedText length-------------------------------${formattedText.length}-------');
//
//     return formattedText;
//   }
//
//   static String writeSpace(int length) {
//     print('length---------------------------------------$length');
//     String space = "";
//     for (int i = 0; i < length; i++) {
//       space += " ";
//     }
//     return space;
//   }
//
//   static String writeDash(int length) {
//     print('length---------------------------------------$length');
//     String dash = "";
//     for (int i = 0; i < length; i++) {
//       dash += "-";
//     }
//     return dash;
//   }
// }

class FrontReceipt80 {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  static const int TOTAL_CHARACTER = 45;

  static const int NORMAL_SIZE_TEXT = 0;
  static const int BOLD_SIZE_TEXT = 12;
  static const int MEDIUM_BOLD_SIZE_TEXT = 2;
  static const int LARGE_BOLD_SIZE_TEXT = 3;
  static const int EXTRA_LARGE_BOLD_SIZE_TEXT = 24;

  static const int ESC_ALIGN_LEFT = 0;
  static const int ESC_ALIGN_CENTER = 1;
  static const int ESC_ALIGN_RIGHT = 2;

  frontReceipt(int type, int orderId) async {
    // if(OrderDetailsModel.customer.total==null){
    //   print(' customerTotal Null----------------------');
    //   bool result =  await OrderDetailsModel.getOrderDetails(orderId);
    //
    //   if(!result){
    //     FlutterRestart.restartApp();
    //   }
    //
    // }
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

//     var response = await http.get("IMAGE_URL");
//     Uint8List bytes = response.bodyBytes;


    print("Static.printedOrders.contains(orderId.toString())---------------------${Static.printedOrders.contains(orderId.toString())}");

    bluetooth.isConnected.then((isConnected) async {
      if (isConnected) {
        if (Static.kitchenReceiptSameAsFront && type == 1) {
          bluetooth.printCustom(
              '        Kitchen Receipt        ', EXTRA_LARGE_BOLD_SIZE_TEXT, 1);

          bluetooth.printCustom(
              '       ------------------       ', BOLD_SIZE_TEXT, 1);
          bluetooth.printNewLine();
        } else {
          bluetooth.printCustom(
              HomeModel.businessName, EXTRA_LARGE_BOLD_SIZE_TEXT, 1);
        }

        if (!Static.hideRestaurantAddressOnReceipt) {
          bluetooth.printCustom(HomeModel.businessAddress, BOLD_SIZE_TEXT, 1);
        }

        bluetooth.printCustom(HomeModel.businessPostCode, BOLD_SIZE_TEXT, 1);
        bluetooth.printCustom(
            'Tel:' + HomeModel.businessContact, BOLD_SIZE_TEXT, 1);
        bluetooth.printCustom(Api.BusinessUrl, BOLD_SIZE_TEXT, 1);

        String deliveryMethod = OrderDetailsModel.customer.deliveryType == 1
            ? "Delivery"
            : "Collection";

        bluetooth.printCustom("Web " + deliveryMethod, BOLD_SIZE_TEXT, 1);
        if (Static.displayOrderIdInReceipt) {
          bluetooth.printCustom(
              'Order ID - ${orderId.toString()}', BOLD_SIZE_TEXT, 1);
        }

        bluetooth.printNewLine();
        bluetooth.printCustom(" ", 2, 1);
        bluetooth.printCustom(
            OrderDetailsModel.customer.customerName, BOLD_SIZE_TEXT, 0);
        bluetooth.printCustom(
            OrderDetailsModel.customer.customerContact, BOLD_SIZE_TEXT, 0);
        if(OrderDetailsModel.customer.deliveryType==1) {
          bluetooth.printCustom(
              OrderDetailsModel.customer.deliveryAddress, BOLD_SIZE_TEXT, 0);
          bluetooth.printCustom(
              OrderDetailsModel.customer.postCode, BOLD_SIZE_TEXT, 0);
        }
        bluetooth.printCustom(" ", 0, 1);
        bluetooth.printCustom(writeDash(47), BOLD_SIZE_TEXT, 1);

        bluetooth.printCustom(
            "Item" + writeSpace(30) + "Price (GBP)", BOLD_SIZE_TEXT, 1);
        // bluetooth.printLeftRight("Item", "Price (GBP)", 1);
        bluetooth.printCustom(writeDash(47), BOLD_SIZE_TEXT, 1);

        print("OrderDetailsModel.foodItems---------------${OrderDetailsModel.foodItems.length}---------------$orderId");

        for (FoodItem foodItem in OrderDetailsModel.foodItems) {
          String breakT = breakText('${foodItem.quantity} X ',
              foodItem.itemName, (foodItem.itemPrice).toStringAsFixed(2));
          bluetooth.printCustom(breakT, BOLD_SIZE_TEXT, 0);
          print("itemName----------------------${foodItem.itemName}");

          List<SubItem> subItems = foodItem.subItems;
          print("print process-----------------------------front receipt------------------------1--------------------$orderId-----OrderDetailsModel.foodItems-----${OrderDetailsModel.foodItems.length}");
          print("print process-----------------------------front receipt------------------------2--------------------$orderId------foodItem.itemName-----------${foodItem.itemName}");
          if (subItems != null) {
            print("print process-----------------------------front receipt------------------------3------------------$orderId--------subItems.length----------${subItems.length}");
            for (SubItem subItem in subItems) {
              print("print process-----------------------------front receipt------------------------4----------------$orderId--------subItem.subItemName---${subItem.subItemName}---------subItems----${subItems.length}");
              bluetooth.printCustom(
                  ' * ${subItem.subItemName}\n       ${subItem.subItemVar}',
                  BOLD_SIZE_TEXT,
                  0);
            }
          }

          var specialReq = foodItem.specialRequest;
          if (specialReq != null) {
            bluetooth.printCustom(
                "+ Special Request: $specialReq", BOLD_SIZE_TEXT, 0);
          }

          bluetooth.printCustom(writeDash(47), BOLD_SIZE_TEXT, 1);
        }

        double total = OrderDetailsModel.customer.total ?? 0.00;
        bluetooth.printCustom(" ", 2, 1);

        bluetooth.printCustom(
            'Total ' + writeSpace(33) + (total).toStringAsFixed(2),
            BOLD_SIZE_TEXT,
            1);

        if (OrderDetailsModel.customer.deliveryCharge !=0.00) {
          bluetooth.printCustom(
              'Delivery Charge ' +
                  writeSpace(24) +
                  (OrderDetailsModel.customer.deliveryCharge)
                      .toStringAsFixed(2),
              BOLD_SIZE_TEXT,
              1);
        }




        // ignore: unrelated_type_equality_checks
        if (OrderDetailsModel.customer.serviceCharge!=0.00) {
          bluetooth.printCustom(
              'Service Charge ' +
                  writeSpace(25) +
                  (OrderDetailsModel.customer.serviceCharge).toStringAsFixed(2),
              BOLD_SIZE_TEXT,
              1);
        }

        if (OrderDetailsModel.customer.taxFee!=0.00) {
          bluetooth.printCustom(
              'Tax Fee ' +
                  writeSpace(32) +
                  (OrderDetailsModel.customer.taxFee).toStringAsFixed(2),
              BOLD_SIZE_TEXT,
              1);
        }
        if (OrderDetailsModel.customer.bagCharge!=0.00) {
          bluetooth.printCustom(
              'Bag Charge ' +
                  writeSpace(28) +
                  (OrderDetailsModel.customer.bagCharge).toStringAsFixed(2),
              BOLD_SIZE_TEXT,
              1);
        }

        // if (OrderDetailsModel.customer.taxFee !=0) {
        //   bluetooth.printCustom(
        //       'Tax Fee ' +
        //           writeSpace(24) +
        //           (OrderDetailsModel.customer.taxFee)
        //               .toStringAsFixed(2),
        //       BOLD_SIZE_TEXT,
        //       1);
        // }
        // if (OrderDetailsModel.customer.bagCharge !=0) {
        //   bluetooth.printCustom(
        //       'Bag Charge ' +
        //           writeSpace(24) +
        //           (OrderDetailsModel.customer.bagCharge)
        //               .toStringAsFixed(2),
        //       BOLD_SIZE_TEXT,
        //       1);
        // }





        if (OrderDetailsModel.customer.discount !=0.00) {
          bluetooth.printCustom(
              'Discount ' +
                  writeSpace(27) +
                  "(-) " +(OrderDetailsModel.customer.discount).toStringAsFixed(2),
              BOLD_SIZE_TEXT,
              1);
        }


        bluetooth.printCustom(writeDash(47), BOLD_SIZE_TEXT, 1);

        bluetooth.printCustom(
            'Total To Pay' +
                writeSpace(24) +
                'GBP ' +
                double.parse(OrderDetailsModel.customer.totalToPay)
                    .toStringAsFixed(2),
            BOLD_SIZE_TEXT,
            1);

        bluetooth.printCustom(" ", 2, 1);

        bluetooth.printCustom(
            "Order placed at " +
                (OrderDetailsModel.customer.orderDate).toString(),
            BOLD_SIZE_TEXT,
            0);
        bluetooth.printCustom(
            "Wanted " + (OrderDetailsModel.customer.deliveryTime).toString(),
            BOLD_SIZE_TEXT,
            0);
        bluetooth.printCustom(
            "Payment Method: " + OrderDetailsModel.customer.paymentMethod,
            BOLD_SIZE_TEXT,
            0);
        if (OrderDetailsModel.customer.paymentMethod != "cash") {
          bluetooth.printCustom(
              "Payment Status: " + OrderDetailsModel.customer.paymentStatus,
              BOLD_SIZE_TEXT,
              0);
        }

        bluetooth.printCustom(" ", 2, 1);
        bluetooth.printCustom(" ", 2, 1);
        bluetooth.printCustom("Thank You", 2, 1);

        if(OrderDetailsModel.customer.deviceInfo!=null){
          bluetooth.printCustom("Order Placed From - ${OrderDetailsModel.customer.deviceInfo}", BOLD_SIZE_TEXT, 1);
        }


        bluetooth.printCustom("Powered by www.ordere.co.uk", BOLD_SIZE_TEXT, 1);

        bluetooth.printCustom(" ", 2, 1);
        bluetooth.printCustom(" ", 2, 1);
        bluetooth.printCustom(" ", 2, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();



        bluetooth.paperCut();
        bluetooth.printNewLine();

      }
    });
  }

  // static String breakText(String piece, String text, String price) {
  //   String formattedText = "$piece";
  //   String tempText = "";
  //   List<String> parts = text.split(" ");
  //   int breakCount = 0;
  //   for (int i = 0; i < parts.length; i++) {
  //     if ((tempText.length + parts[i].length) > 20) {
  //       breakCount++;
  //       if (breakCount == 1) {
  //         formattedText +=
  //             '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
  //         breakCount = 2;
  //       }
  //       formattedText += "\n";
  //       tempText = "";
  //     } else {
  //       formattedText += (parts[i] + " ");
  //       tempText += parts[i] + " ";
  //     }
  //   }
  //   if (breakCount == 0) {
  //     formattedText +=
  //         '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
  //   }
  //
  //   print(
  //       'formattedText length-------------------------------${formattedText.length}');
  //
  //   return formattedText;
  // }



  static String breakText(String piece, String text, String price) {
    String formattedText = "$piece";
    String tempText = "$piece";
    List<String> parts = text.split(" ");
    int breakCount = 0;
    for (int i = 0; i < parts.length; i++) {
      formattedText += (parts[i] + " ");
      tempText += parts[i] + " ";
      print('lengthof ${tempText.length}');
      if ((tempText.length) >= 24) {
        breakCount++;
        if (breakCount == 1) {
          formattedText +=
          '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
          breakCount = 2;
        }
        formattedText += "\n";
        tempText = "";
      }

    }
    if (breakCount == 0) {
      formattedText +=
      '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
    }

    print(
        'formattedText length-------------------------------${formattedText.length}');

    return formattedText;
  }
  static String writeSpace(int length) {
    print('length---------------------------------------$length');
    String space = "";
    for (int i = 0; i < length; i++) {
      space += " ";
    }
    return space;
  }

  static String writeDash(int length) {
    print('length---------------------------------------$length');
    String dash = "-";
    for (int i = 0; i < length; i++) {
      dash += "-";
    }
    return dash;
  }
}
