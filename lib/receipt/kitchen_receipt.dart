import 'package:blue/global/constant.dart';
import 'package:blue/model/order_details_model.dart';
import 'package:blue/podo/food_item.dart';
import 'package:blue/podo/sub_item.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

import 'static_receipt.dart';

class KitchenReceipt {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  static const int TOTAL_CHARACTER = 16;

  static const num SPACE_BEFORE_PRICE = 18;

  static const int NORMAL_SIZE_TEXT = 0;
  static const int BOLD_SIZE_TEXT = 30;
  static const int MEDIUM_BOLD_SIZE_TEXT = 40;
  static const int LARGE_BOLD_SIZE_TEXT = 3;
  static const int EXTRA_LARGE_BOLD_SIZE_TEXT = 30;

  static const int ESC_ALIGN_LEFT = 0;
  static const int ESC_ALIGN_CENTER = 1;
  static const int ESC_ALIGN_RIGHT = 2;

  kitchenReceipt(int orderId) async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    print("Static.printedOrders.contains(orderId.toString())-------kitchen--------------${Static.printedOrders.contains(orderId.toString())}");


      bluetooth.isConnected.then((isConnected) async {
        if (isConnected) {
          bluetooth.printCustom(
              '        Kitchen Receipt        ', EXTRA_LARGE_BOLD_SIZE_TEXT, 1);

          bluetooth.printCustom(
              '       ------------------       ', NORMAL_SIZE_TEXT, 1);
          String deliveryMethod = OrderDetailsModel.customer.deliveryType == 1
              ? "Delivery"
              : "Collection";

          bluetooth.printCustom("Web " + deliveryMethod, BOLD_SIZE_TEXT, 1);
          if (Static.displayOrderIdInReceipt) {
            bluetooth.printCustom('Order ID - ${orderId.toString()}',
                BOLD_SIZE_TEXT, 1);
          }
          bluetooth.printCustom(writeDash(31), BOLD_SIZE_TEXT, 0);
          // bluetooth.printLeftRight("Item", "Price (GBP)", 1);
          bluetooth.printCustom("  Item", LARGE_BOLD_SIZE_TEXT, 0);
          bluetooth.printCustom(writeDash(31), BOLD_SIZE_TEXT, 0);

          for (FoodItem foodItem in OrderDetailsModel.foodItems) {
            final itemName = (foodItem.itemName).replaceAll(RegExp("\’"), '');
            String breakT = breakText('${foodItem.quantity} X ', itemName, "");
            bluetooth.printCustom(breakT, MEDIUM_BOLD_SIZE_TEXT, 0);
            List<SubItem> subItems = foodItem.subItems;
            print(
                "print process-----------------------------kitchen receipt------------------------1----------------$orderId------------OrderDetailsModel.foodItems-----${OrderDetailsModel.foodItems.length}");
            print(
                "print process-----------------------------kitchen receipt------------------------2----------------$orderId------------foodItem.itemName-----------${foodItem.itemName}");

            if (subItems != null) {
              print(
                  "print process-----------------------------kitchen receipt------------------------3--------------$orderId-----------------subItems.length---${subItems.length}---------subItems----${subItems.toString()}");

              for (SubItem subItem in subItems) {
                print(
                    "print process-----------------------------kitchen receipt------------------------4-------------$orderId----------------subItem.subItemName---${subItem.subItemName}---------subItems----${subItems.toString()}");
                final subitemVar =
                    (subItem.subItemVar).replaceAll(RegExp("\’"), '');
                final subItemName =
                    (subItem.subItemName).replaceAll(RegExp("\’"), '');

                String brtx = breakTextSub('', subitemVar, "");
                bluetooth.printCustom(
                    ' *${subItemName}\n  $brtx', MEDIUM_BOLD_SIZE_TEXT, 0);
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
          bluetooth.printCustom("Order placed at", BOLD_SIZE_TEXT, 0);
          bluetooth.printCustom(
              (OrderDetailsModel.customer.orderDate).toString(),
              BOLD_SIZE_TEXT,
              0);

          bluetooth.printCustom(
              "Wanted " + (OrderDetailsModel.customer.deliveryTime).toString(),
              BOLD_SIZE_TEXT,
              0);

          // bluetooth.printCustom((OrderDetailsModel.customer.).toString(), 0, 0);
          bluetooth.printCustom(
              "Payment Method: " + OrderDetailsModel.customer.paymentMethod,
              BOLD_SIZE_TEXT,
              0);
          // if(OrderDetailsModel.customer.paymentMethod!="cash"){
          //   bluetooth.printCustom(
          //       "Payment Status: " + OrderDetailsModel.customer.paymentStatus,
          //       BOLD_SIZE_TEXT,
          //       0);
          // }

          bluetooth.printCustom("", LARGE_BOLD_SIZE_TEXT, 0);
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.paperCut();
        }
      });

  }

  static String breakText(String piece, String text, String price) {
    String formattedText = "$piece";
    String tempText = "";
    List<String> parts = text.split(" ");
    int breakCount = 0;
    for (int i = 0; i < parts.length; i++) {
      print(
          'length ooo--------------------------  ${tempText.length + parts[i].length} oo-- i--- $i----formattedText---$formattedText');
      if ((tempText.length + parts[i].length) > 10) {
        formattedText += "\n" + " " + (parts[i] + " ");
        tempText = "";
      } else {
        formattedText += (parts[i] + " ");
        tempText += parts[i] + " ";
      }
    }
    // if (breakCount == 0) {
    //   formattedText +=
    //   '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
    // }

    print(
        'formattedText length-------------------------------${formattedText.length}');

    return formattedText.trim();
  }

  static String breakTextSub(String piece, String text, String price) {
    String formattedText = "$piece";
    String tempText = "";
    List<String> parts = text.split(" ");
    int breakCount = 0;
    for (int i = 0; i < parts.length; i++) {
      print(
          'length ooo--------------------------  ${tempText.length + parts[i].length} oo-- i--- $i----formattedText---$formattedText');
      if ((tempText.length + parts[i].length) > 10) {
        formattedText += "\n" + "  " + (parts[i] + " ");
        tempText = "";
      } else {
        formattedText += (parts[i] + " ");
        tempText += parts[i] + " ";
      }
    }
    if (breakCount == 0) {
      formattedText +=
          '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
    }

    print(
        'formattedText length-------------------------------${formattedText.length}');

    return formattedText.trim();
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

class KitchenReceipt80 {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  static const int TOTAL_CHARACTER = 14;

  static const num SPACE_BEFORE_PRICE = 18;

  static const int NORMAL_SIZE_TEXT = 0;
  static const int BOLD_SIZE_TEXT = 30;
  static const int MEDIUM_BOLD_SIZE_TEXT = 40;
  static const int LARGE_BOLD_SIZE_TEXT = 3;
  static const int EXTRA_LARGE_BOLD_SIZE_TEXT = 30;

  static const int ESC_ALIGN_LEFT = 0;
  static const int ESC_ALIGN_CENTER = 1;
  static const int ESC_ALIGN_RIGHT = 2;

  kitchenReceipt(int orderId) async {

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

    print("Static.printedOrders.contains(orderId.toString())-------kitchen--------------${Static.printedOrders.contains(orderId.toString())}");

      bluetooth.isConnected.then((isConnected) {
        if (isConnected) {
          bluetooth.printCustom(
              'Kitchen Receipt', EXTRA_LARGE_BOLD_SIZE_TEXT, 1);


          String deliveryMethod = OrderDetailsModel.customer.deliveryType == 1
              ? "Delivery"
              : "Collection";

          bluetooth.printCustom("Web " + deliveryMethod, BOLD_SIZE_TEXT, 1);

          if (Static.displayOrderIdInReceipt) {
            bluetooth.printCustom(
                'Order ID - ${orderId.toString()}', BOLD_SIZE_TEXT, 1);
          }

          bluetooth.printNewLine();

          bluetooth.printCustom(writeDash(47), BOLD_SIZE_TEXT, 1);
          bluetooth.printCustom("Item", MEDIUM_BOLD_SIZE_TEXT, 0);
          bluetooth.printCustom(writeDash(47), BOLD_SIZE_TEXT, 1);

          for (FoodItem foodItem in OrderDetailsModel.foodItems) {
            var breakT =
                breakText('${foodItem.quantity} X ', foodItem.itemName, "");
            bluetooth.printCustom(breakT, MEDIUM_BOLD_SIZE_TEXT, 0);
            List<SubItem> subItems = foodItem.subItems;

            print(
                "print process-----------------------------kitchen receipt ------------------------1------------------- $orderId ---------------OrderDetailsModel.foodItems-----${OrderDetailsModel.foodItems.length}");
            print(
                "print process-----------------------------kitchen receipt ------------------------2------------------- $orderId ---------------foodItem.itemName-----------${foodItem.itemName}");

            if (subItems != null) {
              print(
                  "print process-----------------------------kitchen receipt------------------------3-----------------$orderId----------------subItems.length---${subItems.length}---------subItems----${subItems.toString()}");
              for (SubItem subItem in subItems) {
                print(
                    "print process-----------------------------kitchen receipt------------------------4-----------------$orderId-----------subItem.subItemName---${subItem.subItemName}---------subItems----${subItems.toString()}");
                bluetooth.printCustom(
                    ' *${subItem.subItemName}\n    ${subItem.subItemVar}',
                    MEDIUM_BOLD_SIZE_TEXT,
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

          bluetooth.printNewLine();

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
          bluetooth.printNewLine();
          bluetooth.printCustom('', 0, 0);
          bluetooth.printCustom('', 0, 0);
          bluetooth.printCustom('', 0, 0);
          bluetooth.printCustom('', 0, 0);
          bluetooth.printCustom('', 0, 0);
          bluetooth.printCustom('', 0, 0);

          bluetooth.paperCut();
        }
      });

  }

  static String breakText(String piece, String text, String price) {
    String formattedText = "$piece";
    String tempText = "";
    List<String> parts = text.split(" ");
    int breakCount = 0;
    for (int i = 0; i < parts.length; i++) {
      print(
          'length ooo--------------------------  ${tempText.length + parts[i].length} oo-- i--- $i----formattedText---$formattedText');
      if ((tempText.length + parts[i].length) > 34) {
        formattedText += "\n" + (parts[i] + " ");
        tempText = "";
      } else {
        formattedText += (parts[i] + " ");
        tempText += parts[i] + " ";
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
