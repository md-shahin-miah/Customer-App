
import 'package:blue/model/tablebookiing_details_model.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

class TableBookingReceipt {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  static const int TOTAL_CHARACTER = 32;

  static const num SPACE_BEFORE_PRICE = 18;

  static const int NORMAL_SIZE_TEXT = 0;
  static const int BOLD_SIZE_TEXT = 12;
  static const int MEDIUM_BOLD_SIZE_TEXT = 2;
  static const int LARGE_BOLD_SIZE_TEXT = 12;
  static const int EXTRA_LARGE_BOLD_SIZE_TEXT = 30;

  static const int ESC_ALIGN_LEFT = 0;
  static const int ESC_ALIGN_CENTER = 1;
  static const int ESC_ALIGN_RIGHT = 2;

  tableReceipt() async {
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

        bluetooth.printCustom(
            ' Table Booking Receipt', EXTRA_LARGE_BOLD_SIZE_TEXT, 1);

        bluetooth.printCustom(
            '----------------------', BOLD_SIZE_TEXT, 1);

        bluetooth.printCustom(
            'Order ID - ${TableBookingDetailsModel.customer.orderId}', 2, 1);

        bluetooth.printCustom(
            "", 2, 1);
        bluetooth.printCustom(
            TableBookingDetailsModel.customer.customerName, BOLD_SIZE_TEXT, 0);
        bluetooth.printCustom(
            TableBookingDetailsModel.customer.customerContact, BOLD_SIZE_TEXT, 0);
        bluetooth.printCustom(
            TableBookingDetailsModel.customer.customerEmail, BOLD_SIZE_TEXT, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom('Date- ${TableBookingDetailsModel.customer.orderDate}', BOLD_SIZE_TEXT, 0);
        bluetooth.printCustom('Time- ${TableBookingDetailsModel.customer.orderTime}', BOLD_SIZE_TEXT, 0);
        bluetooth.printCustom('Booking placed at', BOLD_SIZE_TEXT, 0);
        bluetooth.printCustom('${TableBookingDetailsModel.customer.tableBookingPlacementTime}', BOLD_SIZE_TEXT, 0);

        bluetooth.printCustom(
            'Number of guests- ${TableBookingDetailsModel.customer.numberOfGuest}', BOLD_SIZE_TEXT, 0);


        var specialReq=TableBookingDetailsModel.customer.specialReq;
        print('Special Request--------------------------------$specialReq');
        if(specialReq!=null&&specialReq!=''){
          bluetooth.printCustom("Special Request: $specialReq", BOLD_SIZE_TEXT, 0);
        }

        bluetooth.printNewLine();

        bluetooth.printNewLine();
        bluetooth.printCustom("Thank You", 2, 1);
        bluetooth.printCustom("Powered by www.ordere.co.uk", 1, 1);
        // bluetooth.printNewLine();
        // bluetooth.printQRcode(StaticReceipt.BUSINESS_QRCODE, 200, 200, 1);
        // bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("", 2, 1);
        bluetooth.printCustom("", 2, 1);
        bluetooth.printCustom("", 2, 1);
        bluetooth.printCustom("", 2, 1);
        bluetooth.printCustom("", 2, 1);
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
      if ((tempText.length + parts[i].length) > 20) {
        breakCount++;
        if (breakCount == 1) {
          formattedText +=
          '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
          breakCount = 2;
        }
        formattedText += "\n";
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
}


// class TableBookingReceipt80 {
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
//
//   static const int TOTAL_CHARACTER = 47;
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
//   tableReceipt() async {
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
//     bluetooth.isConnected.then((isConnected) {
//
//
//       if (isConnected) {
//
//         bluetooth.printCustom(
//             ' Table Booking Receipt', EXTRA_LARGE_BOLD_SIZE_TEXT, 1);
//
//         bluetooth.printCustom(
//             '---------------------', BOLD_SIZE_TEXT, 1);
//
//         bluetooth.printCustom(
//             'Order ID - ${TableBookingDetailsModel.customer.orderId}', 2, 1);
//
//         bluetooth.printCustom(
//             "", 2, 1);
//         bluetooth.printCustom(
//             TableBookingDetailsModel.customer.customerName, BOLD_SIZE_TEXT, 0);
//         bluetooth.printCustom(
//             TableBookingDetailsModel.customer.customerContact, BOLD_SIZE_TEXT, 0);
//         bluetooth.printCustom(
//             TableBookingDetailsModel.customer.customerEmail, BOLD_SIZE_TEXT, 0);
//         bluetooth.printNewLine();
//         bluetooth.printCustom('Date- ${TableBookingDetailsModel.customer.orderDate}', BOLD_SIZE_TEXT, 0);
//         bluetooth.printCustom('Time- ${TableBookingDetailsModel.customer.orderTime}', BOLD_SIZE_TEXT, 0);
//
//         bluetooth.printCustom(
//             'Number of guests- ${TableBookingDetailsModel.customer.numberOfGuest}', BOLD_SIZE_TEXT, 0);
//         bluetooth.printNewLine();
//
//         bluetooth.printNewLine();
//         bluetooth.printCustom("Thank You", 2, 1);
//         bluetooth.printCustom("Powered by www.ordere.co.uk", 1, 1);
//         // bluetooth.printNewLine();
//         // bluetooth.printQRcode(StaticReceipt.BUSINESS_QRCODE, 200, 200, 1);
//         // bluetooth.printNewLine();
//         bluetooth.printCustom("", 2, 1);
//         bluetooth.printCustom("", 2, 1);
//         bluetooth.printCustom("", 2, 1);
//         bluetooth.printCustom("", 2, 1);
//
//         bluetooth.printNewLine();
//         bluetooth.paperCut();
//
//       }
//     });
//   }
//
//   static String breakText(String piece, String text, String price) {
//     String formattedText = "$piece";
//     String tempText = "";
//     List<String> parts = text.split(" ");
//     int breakCount = 0;
//     for (int i = 0; i < parts.length; i++) {
//       if ((tempText.length + parts[i].length) > 20) {
//         breakCount++;
//         if (breakCount == 1) {
//           formattedText +=
//           '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
//           breakCount = 2;
//         }
//         formattedText += "\n";
//         tempText = "";
//       } else {
//         formattedText += (parts[i] + " ");
//         tempText += parts[i] + " ";
//       }
//     }
//     if (breakCount == 0) {
//       formattedText +=
//       '${writeSpace(TOTAL_CHARACTER - (formattedText.length + price.length))}$price';
//     }
//
//     print(
//         'formattedText length-------------------------------${formattedText.length}');
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
//   static String writeDash(int length) {
//     print('length---------------------------------------$length');
//     String dash = "";
//     for (int i = 0; i < length; i++) {
//       dash += "-";
//     }
//     return dash;
//   }
//
// }
