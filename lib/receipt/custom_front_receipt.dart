import 'dart:ffi';

import 'package:blue/global/constant.dart';
import 'package:blue/model/home_model.dart';
import 'package:blue/model/order_details_model.dart';
import 'package:blue/model/order_model.dart';
import 'package:blue/podo/food_item.dart';
import 'package:blue/podo/sub_item.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter_restart/flutter_restart.dart';

class CustomFrontReceipt {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  static const int TOTAL_CHARACTER = 23;
  // static const int SUB_CHARACTER = 30;

 // static const int NORMAL_SIZE_TEXT = 0;
  static const int CUSTOM_SIZE_TEXT = 46;
  static const int ADDRESS_SIZE_TEXT = 35;
  static const int SMALL_SIZE_TEXT = 9;
  static const int CUSTOM_HEAD_TEXT = 62;
  static const int CUSTOM_SUBTITLE_TEXT = 30;
  static const int CUSTOM_TITLE_TEXT = 14;
 // static const int MEDIUM_CUSTOM_SIZE_TEXT = 2;
 // static const int LARGE_CUSTOM_SIZE_TEXT = 3;
  static const int EXTRA_LARGE_CUSTOM_SIZE_TEXT = 3;

  static const int ESC_ALIGN_LEFT = 0;
  static const int ESC_ALIGN_CENTER = 1;
  static const int ESC_ALIGN_RIGHT = 2;
  static const int BREAK_POINT = 12;
  static const int SUB_BREAK_POINT = 16;

  frontReceipt(int type, int orderId) async {

    //SIZE
    // 0 - normal size text
    // 1 - only bold text
    // 2 - bold with medium text
    // 3 - bold with large text
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
              '        Kitchen Receipt        ', CUSTOM_HEAD_TEXT, 1);

          bluetooth.printCustom(
              '       ------------------       ', CUSTOM_SIZE_TEXT, 1);
          bluetooth.printNewLine();
        } else {
          bluetooth.printCustom(
              HomeModel.businessName, CUSTOM_HEAD_TEXT, 1);
        }

        bluetooth.printNewLine();

        if (!Static.hideRestaurantAddressOnReceipt) {
          bluetooth.printCustom(HomeModel.businessAddress, CUSTOM_SIZE_TEXT, 1);
        }

        bluetooth.printCustom(HomeModel.businessPostCode, CUSTOM_SIZE_TEXT, 1);
        bluetooth.printCustom(
            'Tel:' + HomeModel.businessContact, CUSTOM_TITLE_TEXT, 1);
        bluetooth.printCustom(Api.BusinessUrl, CUSTOM_TITLE_TEXT, 1);

        String deliveryMethod = OrderDetailsModel.customer.deliveryType == 1
            ? "Delivery"
            : "Collection";

        bluetooth.printCustom("Web " + deliveryMethod, CUSTOM_TITLE_TEXT, 1);

        if (Static.displayOrderIdInReceipt) {
          bluetooth.printCustom(
              'Order ID - ${orderId.toString()}', CUSTOM_SIZE_TEXT, 1);
        }
        bluetooth.printNewLine();
        bluetooth.printCustom(" ", 2, 1);

        bluetooth.printCustom(
            OrderDetailsModel.customer.customerName, CUSTOM_SIZE_TEXT, 0);
        bluetooth.printCustom(
            OrderDetailsModel.customer.customerContact, CUSTOM_SIZE_TEXT, 0);
        if(OrderDetailsModel.customer.deliveryType==1) {
          bluetooth.printCustom(
              OrderDetailsModel.customer.deliveryAddress, CUSTOM_SIZE_TEXT, 0);
          bluetooth.printCustom(
              OrderDetailsModel.customer.postCode, CUSTOM_SIZE_TEXT, 0);
        }
        bluetooth.printCustom(" ", 0, 1);
        bluetooth.printCustom(writeDash(), CUSTOM_SIZE_TEXT, 1);

        bluetooth.printCustom(
            addSpaceInMid("Item","Price (GBP)"), CUSTOM_SIZE_TEXT, 1);
        // bluetooth.printLeftRight("Item", "Price (GBP)", 1);
        bluetooth.printCustom(writeDash(), CUSTOM_SIZE_TEXT, 1);

        print("OrderDetailsModel.foodItems---------------${OrderDetailsModel.foodItems.length}---------------$orderId");

        for (FoodItem foodItem in OrderDetailsModel.foodItems) {
          String breakT = breakText('${foodItem.quantity} X ',
              foodItem.itemName, (foodItem.itemPrice).toStringAsFixed(2));
          bluetooth.printCustom(breakT, CUSTOM_SIZE_TEXT, 0);
          print("itemName----------------------${foodItem.itemName}");

          List<SubItem> subItems = foodItem.subItems;
          print("print process-----------------------------front receipt------------------------1-------------------- $orderId -----OrderDetailsModel.foodItems-----${OrderDetailsModel.foodItems.length}");
          print("print process-----------------------------front receipt------------------------2-------------------- $orderId ------foodItem.itemName-----------${foodItem.itemName}");
          if (subItems != null) {
            print("print process-----------------------------front receipt------------------------3------------------ $orderId --------subItems.length----------${subItems.length}");
            for (SubItem subItem in subItems) {
              print("print process-----------------------------front receipt------------------------4---------------- $orderId --------subItem.subItemName---${subItem.subItemName}---------subItems----${subItems.length}");
              bluetooth.printCustom(
                  ' * ${subItem.subItemName}\n${breakSubText(subItem.subItemVar)}',
                  CUSTOM_SIZE_TEXT,
                  0);
            }
          }

          var specialReq = foodItem.specialRequest;
          if (specialReq != null) {
            bluetooth.printCustom(
                "+ Special Request: $specialReq", CUSTOM_SIZE_TEXT, 0);
          }

          bluetooth.printCustom(writeDash(), CUSTOM_SIZE_TEXT, 1);
        }

        double total = OrderDetailsModel.customer.total ?? 0.00;
        // bluetooth.printCustom(" ", 2, 1);

        bluetooth.printCustom(
             addSpaceInMid('Total ',(total).toStringAsFixed(2)) ,
            CUSTOM_SIZE_TEXT,
            1);

        if (OrderDetailsModel.customer.deliveryCharge !=0.00) {
          bluetooth.printCustom(
            addSpaceInMid('Delivery Charge ', (OrderDetailsModel.customer.deliveryCharge)
                .toStringAsFixed(2)),
              CUSTOM_SIZE_TEXT,
              1);
        }




        // ignore: unrelated_type_equality_checks
        if (OrderDetailsModel.customer.serviceCharge!=0.00) {
          bluetooth.printCustom(
            addSpaceInMid('Service Charge ', (OrderDetailsModel.customer.serviceCharge).toStringAsFixed(2)),
              CUSTOM_SIZE_TEXT,
              1);
          // bluetooth.printCustom(" ", 2, 1);
        }

        if (OrderDetailsModel.customer.taxFee!=0.00) {
          bluetooth.printCustom(
             addSpaceInMid( 'Tax Fee ' , (OrderDetailsModel.customer.taxFee).toStringAsFixed(2)),
              CUSTOM_SIZE_TEXT,
              1);
        }
        if (OrderDetailsModel.customer.bagCharge!=0.00) {
          bluetooth.printCustom(
              addSpaceInMid('Bag Charge ',  (OrderDetailsModel.customer.bagCharge).toStringAsFixed(2)) ,
              CUSTOM_SIZE_TEXT,
              1);
        }

        // if (OrderDetailsModel.customer.taxFee !=0) {
        //   bluetooth.printCustom(
        //       'Tax Fee ' +
        //           writeSpace(24) +
        //           (OrderDetailsModel.customer.taxFee)
        //               .toStringAsFixed(2),
        //       CUSTOM_SIZE_TEXT,
        //       1);
        // }
        // if (OrderDetailsModel.customer.bagCharge !=0) {
        //   bluetooth.printCustom(
        //       'Bag Charge ' +
        //           writeSpace(24) +
        //           (OrderDetailsModel.customer.bagCharge)
        //               .toStringAsFixed(2),
        //       CUSTOM_SIZE_TEXT,
        //       1);
        // }





        if (OrderDetailsModel.customer.discount !=0.00) {

          bluetooth.printCustom(
              addSpaceInMid( 'Discount '+"(-) ", (OrderDetailsModel.customer.discount).toStringAsFixed(2)),

              CUSTOM_SIZE_TEXT,
              1);
        }


        bluetooth.printCustom(writeDash(), CUSTOM_SIZE_TEXT, 1);

        bluetooth.printCustom(
          addSpaceInMid( 'Total To Pay ', 'GBP ' +
              double.parse(OrderDetailsModel.customer.totalToPay)
                  .toStringAsFixed(2))

                ,
            CUSTOM_SIZE_TEXT,
            1);

        bluetooth.printCustom(" ", 2, 1);

        bluetooth.printCustom(
            "Order placed at \n" +
                (OrderDetailsModel.customer.orderDate).toString(),
            CUSTOM_SIZE_TEXT,
            0);
        bluetooth.printCustom(
            "Wanted " + (OrderDetailsModel.customer.deliveryTime).toString(),
            CUSTOM_SIZE_TEXT,
            0);
        bluetooth.printCustom(
            "Payment Method: " + OrderDetailsModel.customer.paymentMethod,
            CUSTOM_SIZE_TEXT,
            0);
        if (OrderDetailsModel.customer.paymentMethod != "cash") {
          bluetooth.printCustom(
              "Payment Status: " + OrderDetailsModel.customer.paymentStatus,
              CUSTOM_SIZE_TEXT,
              0);
        }

        bluetooth.printCustom(" ", 2, 1);
        bluetooth.printCustom(" ", 2, 1);
        bluetooth.printCustom("Thank You", CUSTOM_TITLE_TEXT, 1);

        if(OrderDetailsModel.customer.deviceInfo!=null){
          bluetooth.printCustom("Order Placed From - ${OrderDetailsModel.customer.deviceInfo}", CUSTOM_TITLE_TEXT, 1);
        }


        bluetooth.printCustom("Powered by www.ordere.co.uk", CUSTOM_TITLE_TEXT, 1);

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
      if ((tempText.length) >= BREAK_POINT) {
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
  static String breakSubText(String text) {
    String formattedText = "    ";
    String tempText = "    ";
    List<String> parts = text.split(" ");

    for (int i = 0; i < parts.length; i++) {
      formattedText += (parts[i] + " ");
      tempText += parts[i] + " ";
      print('lengthof ${tempText.length}');
      if ((tempText.length) >= SUB_BREAK_POINT) {
        formattedText += "\n    ";
        tempText = "   ";
      }

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

  static String addSpaceInMid(String part1,String part2){

    int length = TOTAL_CHARACTER - (part1.length+part2.length);
    String space = "";
    for (int i = 0; i < length; i++) {
      space += " ";
    }
    return part1+space+part2;


  }


  // static String addSpaceInMidPRICE(String part1,String part2){
  //
  //   int length = SUB_CHARACTER - (part1.length+part2.length);
  //   String space = "";
  //   for (int i = 0; i < length; i++) {
  //     space += " ";
  //   }
  //   return part1+space+part2;
  //
  //
  // }

  static String writeDash() {
    int length = TOTAL_CHARACTER;
    print('length---------------------------------------$length');
    String dash = "-";
    for (int i = 0; i < length; i++) {
      dash += "-";
    }
    return dash;
  }
}
class CustomFrontReceipt58 {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  static const int TOTAL_CHARACTER = 15;
  // static const int SUB_CHARACTER = 30;

 // static const int NORMAL_SIZE_TEXT = 0;
  static const int CUSTOM_SIZE_TEXT = 46;
  static const int ADDRESS_SIZE_TEXT = 35;
  static const int SMALL_SIZE_TEXT = 9;
  static const int CUSTOM_HEAD_TEXT = 46;
  static const int CUSTOM_SUBTITLE_TEXT = 30;
  static const int CUSTOM_TITLE_TEXT = 14;
 // static const int MEDIUM_CUSTOM_SIZE_TEXT = 2;
 // static const int LARGE_CUSTOM_SIZE_TEXT = 3;
  static const int EXTRA_LARGE_CUSTOM_SIZE_TEXT = 3;

  static const int ESC_ALIGN_LEFT = 0;
  static const int ESC_ALIGN_CENTER = 1;
  static const int ESC_ALIGN_RIGHT = 2;
  static const int BREAK_POINT = 12;
  static const int SUB_BREAK_POINT = 16;

  frontReceipt(int type, int orderId) async {

    //SIZE
    // 0 - normal size text
    // 1 - only bold text
    // 2 - bold with medium text
    // 3 - bold with large text
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
              '        Kitchen Receipt        ', CUSTOM_HEAD_TEXT, 1);

          bluetooth.printCustom(
              '       ------------------       ', CUSTOM_SIZE_TEXT, 1);
          bluetooth.printNewLine();
        } else {
          bluetooth.printCustom(
              HomeModel.businessName, CUSTOM_HEAD_TEXT, 1);
        }

        bluetooth.printNewLine();

        if (!Static.hideRestaurantAddressOnReceipt) {
          bluetooth.printCustom(HomeModel.businessAddress, CUSTOM_SIZE_TEXT, 1);
        }

        bluetooth.printCustom(HomeModel.businessPostCode, CUSTOM_SIZE_TEXT, 1);
        bluetooth.printCustom(
            'Tel:' + HomeModel.businessContact, CUSTOM_TITLE_TEXT, 1);
        bluetooth.printCustom(Api.BusinessUrl, CUSTOM_TITLE_TEXT, 1);

        String deliveryMethod = OrderDetailsModel.customer.deliveryType == 1
            ? "Delivery"
            : "Collection";

        bluetooth.printCustom("Web " + deliveryMethod, CUSTOM_TITLE_TEXT, 1);

        if (Static.displayOrderIdInReceipt) {
          bluetooth.printCustom(
              'Order ID - ${orderId.toString()}', CUSTOM_SIZE_TEXT, 1);
        }
        bluetooth.printNewLine();
        bluetooth.printCustom(" ", 2, 1);

        bluetooth.printCustom(
            OrderDetailsModel.customer.customerName, CUSTOM_SIZE_TEXT, 0);
        bluetooth.printCustom(
            OrderDetailsModel.customer.customerContact, CUSTOM_SIZE_TEXT, 0);
        if(OrderDetailsModel.customer.deliveryType==1) {
          bluetooth.printCustom(
              OrderDetailsModel.customer.deliveryAddress, CUSTOM_SIZE_TEXT, 0);
          bluetooth.printCustom(
              OrderDetailsModel.customer.postCode, CUSTOM_SIZE_TEXT, 0);
        }
        bluetooth.printCustom(" ", 0, 1);
        bluetooth.printCustom(writeDash(), CUSTOM_SIZE_TEXT, 1);

        bluetooth.printCustom(
            addSpaceInMid("Item","Price (GBP)"), CUSTOM_SIZE_TEXT, 1);
        // bluetooth.printLeftRight("Item", "Price (GBP)", 1);
        bluetooth.printCustom(writeDash(), CUSTOM_SIZE_TEXT, 1);

        print("OrderDetailsModel.foodItems---------------${OrderDetailsModel.foodItems.length}---------------$orderId");

        for (FoodItem foodItem in OrderDetailsModel.foodItems) {
          String breakT = breakText('${foodItem.quantity} X ',
              foodItem.itemName, (foodItem.itemPrice).toStringAsFixed(2));
          bluetooth.printCustom(breakT, CUSTOM_SIZE_TEXT, 0);
          print("itemName----------------------${foodItem.itemName}");

          List<SubItem> subItems = foodItem.subItems;
          print("print process-----------------------------front receipt------------------------1-------------------- $orderId -----OrderDetailsModel.foodItems-----${OrderDetailsModel.foodItems.length}");
          print("print process-----------------------------front receipt------------------------2-------------------- $orderId ------foodItem.itemName-----------${foodItem.itemName}");
          if (subItems != null) {
            print("print process-----------------------------front receipt------------------------3------------------ $orderId --------subItems.length----------${subItems.length}");
            for (SubItem subItem in subItems) {
              print("print process-----------------------------front receipt------------------------4---------------- $orderId --------subItem.subItemName---${subItem.subItemName}---------subItems----${subItems.length}");
              bluetooth.printCustom(
                  ' * ${subItem.subItemName}\n${breakSubText(subItem.subItemVar)}',
                  CUSTOM_SIZE_TEXT,
                  0);
            }
          }

          var specialReq = foodItem.specialRequest;
          if (specialReq != null) {
            bluetooth.printCustom(
                "+ Special Request: $specialReq", CUSTOM_SIZE_TEXT, 0);
          }

          bluetooth.printCustom(writeDash(), CUSTOM_SIZE_TEXT, 1);
        }

        double total = OrderDetailsModel.customer.total ?? 0.00;
        // bluetooth.printCustom(" ", 2, 1);

        bluetooth.printCustom(
             addSpaceInMid('Total ',(total).toStringAsFixed(2)) ,
            CUSTOM_SIZE_TEXT,
            1);

        if (OrderDetailsModel.customer.deliveryCharge !=0.00) {
          bluetooth.printCustom(
            addSpaceInMid('Delivery Charge ', (OrderDetailsModel.customer.deliveryCharge)
                .toStringAsFixed(2)),
              CUSTOM_SIZE_TEXT,
              1);
        }




        // ignore: unrelated_type_equality_checks
        if (OrderDetailsModel.customer.serviceCharge!=0.00) {
          bluetooth.printCustom(
            addSpaceInMid('Service Charge ', (OrderDetailsModel.customer.serviceCharge).toStringAsFixed(2)),
              CUSTOM_SIZE_TEXT,
              1);
          // bluetooth.printCustom(" ", 2, 1);
        }

        if (OrderDetailsModel.customer.taxFee!=0.00) {
          bluetooth.printCustom(
             addSpaceInMid( 'Tax Fee ' , (OrderDetailsModel.customer.taxFee).toStringAsFixed(2)),
              CUSTOM_SIZE_TEXT,
              1);
        }
        if (OrderDetailsModel.customer.bagCharge!=0.00) {
          bluetooth.printCustom(
              addSpaceInMid('Bag Charge ',  (OrderDetailsModel.customer.bagCharge).toStringAsFixed(2)) ,
              CUSTOM_SIZE_TEXT,
              1);
        }

        // if (OrderDetailsModel.customer.taxFee !=0) {
        //   bluetooth.printCustom(
        //       'Tax Fee ' +
        //           writeSpace(24) +
        //           (OrderDetailsModel.customer.taxFee)
        //               .toStringAsFixed(2),
        //       CUSTOM_SIZE_TEXT,
        //       1);
        // }
        // if (OrderDetailsModel.customer.bagCharge !=0) {
        //   bluetooth.printCustom(
        //       'Bag Charge ' +
        //           writeSpace(24) +
        //           (OrderDetailsModel.customer.bagCharge)
        //               .toStringAsFixed(2),
        //       CUSTOM_SIZE_TEXT,
        //       1);
        // }





        if (OrderDetailsModel.customer.discount !=0.00) {

          bluetooth.printCustom(
              addSpaceInMid( 'Discount '+"(-) ", (OrderDetailsModel.customer.discount).toStringAsFixed(2)),

              CUSTOM_SIZE_TEXT,
              1);
        }


        bluetooth.printCustom(writeDash(), CUSTOM_SIZE_TEXT, 1);

        // bluetooth.printCustom(
        //   addSpaceInMid( 'Total To Pay ', 'GBP ' +
        //       double.parse(OrderDetailsModel.customer.totalToPay)
        //           .toStringAsFixed(2))
        //
        //         ,
        //     CUSTOM_TITLE_TEXT,
        //     1);


        bluetooth.printLeftRight(
            'Total To Pay ',
            'GBP '+"${(OrderDetailsModel.customer.total).toStringAsFixed(2)}",
            CUSTOM_SUBTITLE_TEXT);

        bluetooth.printCustom(" ", 2, 1);

        bluetooth.printCustom(
            "Order placed at \n" +
                (OrderDetailsModel.customer.orderDate).toString(),
            CUSTOM_SIZE_TEXT,
            0);
        bluetooth.printCustom(
            "Wanted " + (OrderDetailsModel.customer.deliveryTime).toString(),
            CUSTOM_SIZE_TEXT,
            0);
        bluetooth.printCustom(
            "Payment Method: " + OrderDetailsModel.customer.paymentMethod,
            CUSTOM_SIZE_TEXT,
            0);
        if (OrderDetailsModel.customer.paymentMethod != "cash") {
          bluetooth.printCustom(
              "Payment Status: " + OrderDetailsModel.customer.paymentStatus,
              CUSTOM_SIZE_TEXT,
              0);
        }

        bluetooth.printCustom(" ", 2, 1);
        bluetooth.printCustom(" ", 2, 1);
        bluetooth.printCustom("Thank You", CUSTOM_TITLE_TEXT, 1);

        if(OrderDetailsModel.customer.deviceInfo!=null){
          bluetooth.printCustom("Order Placed From - ${OrderDetailsModel.customer.deviceInfo}", CUSTOM_TITLE_TEXT, 1);
        }


        bluetooth.printCustom("Powered by www.ordere.co.uk", CUSTOM_TITLE_TEXT, 1);

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
      if ((tempText.length) >= BREAK_POINT) {
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

  static String breakSubText(String text) {
    String formattedText = "    ";
    String tempText = "    ";
    List<String> parts = text.split(" ");

    for (int i = 0; i < parts.length; i++) {
      formattedText += (parts[i] + " ");
      tempText += parts[i] + " ";
      print('lengthof ${tempText.length}');
      if ((tempText.length) >= SUB_BREAK_POINT) {
        formattedText += "\n    ";
        tempText = "   ";
      }

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

  static String addSpaceInMid(String part1,String part2){

    int length = TOTAL_CHARACTER - (part1.length+part2.length);
    String space = "";
    for (int i = 0; i < length; i++) {
      space += " ";
    }
    return part1+space+part2;


  }


  // static String addSpaceInMidPRICE(String part1,String part2){
  //
  //   int length = SUB_CHARACTER - (part1.length+part2.length);
  //   String space = "";
  //   for (int i = 0; i < length; i++) {
  //     space += " ";
  //   }
  //   return part1+space+part2;
  //
  //
  // }

  static String writeDash() {
    int length = TOTAL_CHARACTER;
    print('length---------------------------------------$length');
    String dash = "-";
    for (int i = 0; i < length; i++) {
      dash += "-";
    }
    return dash;
  }
}
