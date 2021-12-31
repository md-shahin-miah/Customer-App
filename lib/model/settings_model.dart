import 'dart:convert';
import 'package:blue/global/constant.dart';
import 'package:http/http.dart' as http;

class SettingsModel {


  static Future<String> getSettings() async {
    String url = Static.Domain;
    var response = await http.post(
        'https://superadmin.ordere.co.uk/API/Merchant/getSettings/',
        body: {"domain": url, "key": "4a85a366-9d2d-4d65-a443-8cef021010a8"});
    print('getsetting jsonResponse---------------${response.body}');

    final jsonResponse = jsonDecode(response.body);
    print('jsonResponse jsonResponse---------------$jsonResponse');

    Map<String, dynamic> info = jsonResponse;
    if (info['settings'] != null) {
      final setting = jsonDecode(info['settings']);

      Static.enablePendingOrderSound =
          setting["enablePendingOrderSound"] == 'true';

      Static.hideRestaurantAddressOnReceipt =
          setting["hideRestaurantAddressOnReceipt"] == 'true';

      Static.displayOrderIdTable = setting["displayOrderIdTable"] == 'true';

      Static.autoPrintTableBookingReceipt =
          setting["autoPrintTableBookingReceipt"] == 'true';
      Static.autoPrintOrder = setting["autoPrintOrder"] == 'true';
      Static.showOnlyCurrentDaysOrder =
          setting["showOnlyCurrentDaysOrder"] == 'true';

      Static.kitchenReceiptDefault = setting["kitchenReceiptDefault"] == 'true';

      Static.kitchenReceiptSameAsFront =
          setting["kitchenReceiptSameAsFront"] == 'true';

      Static.displayOrderIdInReceipt =
          setting["displayOrderIdInReceipt"] == 'true';

      Static.displayAwaitingNotPaidPayment =
          setting["displayAwaitingNotPaidPayment"] == 'true';

      Static.enableAwaitingNotPaidPaymentSound =
          setting["enableAwaitingNotPaidPaymentSound"] == 'true';

      Static.enableDeveloperMode = setting["enableDeveloperMode"] == 'true';

      Static.Unconfirmed_payment_button_Value =
          setting["unconfirmed_payment_button_value"];

      Static.Paper_Size = setting["paper_size"];

      Static.disableKitchenPopUp = setting["autoCutter"];

      Static.Number_of_front_receipt_Value =
          setting["number_of_front_receipt_value"];

      Static.Number_of_kitchen_receipt_Value =
          setting["number_of_kitchen_receipt_value"];

      Static.Pending_order_sound_length_value =
          setting["pending_order_sound_length_value"];
      String autoAcceptTableBooking = setting["autoAcceptTableBooking"];

      if (autoAcceptTableBooking == "on") {
        Static.autoAcceptTableBooking = true;
      } else {
        Static.autoAcceptTableBooking = false;
      }

      print(
          'response get settings- Static.enablePendingOrderSound  ${setting["enablePendingOrderSound"]} =${Static.enablePendingOrderSound} +   Static.hideRestaurantAddressOnReceipt =${Static.hideRestaurantAddressOnReceipt} + Static.displayOrderIdTable =${Static.displayOrderIdTable} +Static.autoPrintTableBookingReceipt = ${Static.autoPrintTableBookingReceipt}  +Static.autoPrintOrder + ${Static.autoPrintOrder}  + Static.showOnlyCurrentDaysOrder =${Static.showOnlyCurrentDaysOrder} + Static.kitchenReceiptDefault =${Static.kitchenReceiptDefault} + Static.kitchenReceiptSameAsFront =${Static.kitchenReceiptSameAsFront} + Static.displayOrderIdInReceipt =${Static.displayOrderIdInReceipt} + Static.displayAwaitingNotPaidPayment =${Static.displayAwaitingNotPaidPayment} + Static.enableAwaitingNotPaidPaymentSound = ${Static.enableAwaitingNotPaidPaymentSound} + Static.enableDeveloperMode =${Static.enableDeveloperMode} + Static.Unconfirmed_payment_button_Value  =${Static.Unconfirmed_payment_button_Value} + Static.Paper_Size =${Static.Paper_Size} +Static.disableKitchenPopUp =${Static.disableKitchenPopUp} + Static.Number_of_front_receipt_Value = ${Static.Number_of_kitchen_receipt_Value} + Static.Pending_order_sound_length_value =${Static.Pending_order_sound_length_value} autoAcceptedTableBooking-----$autoAcceptTableBooking');
      return "yes";
    } else {

      return "no";
    }
  }

  static changeSettingsStatus() async {

    var response =
        await http.post('${Api.businessBaseUrl}setInstallStatus/', body: {
      'state': "0",
    });
    Static.NewId = "1";
    print(
        'changeSettingsStatus-------------------------------------------${response.body}');
    print('status has changed----------------------------------------------------------');
    return response.body;
  }

  static Future UpDateSettings(
      bool enablePendingOrderSound,
      bool hideRestaurantAddressOnReceipt,
      bool displayOrderIdTable,
      bool autoPrintTableBookingReceipt,
      bool autoPrintOrder,
      bool showOnlyCurrentDaysOrder,
      bool kitchenReceiptDefault,
      bool kitchenReceiptSameAsFront,
      bool displayOrderIdInReceipt,
      bool displayAwaitingNotPaidPayment,
      bool enableAwaitingNotPaidPaymentSound,
      bool enableDeveloperMode,
      String unconfirmed_payment_button_value,
      String paper_size,
      String autoCutter,
      String number_of_front_receipt_value,
      String number_of_kitchen_receipt_value,
      String pending_order_sound_length_value,
      String auto_accepted_table_booking,
      String version) async {

    String url = Api.BusinessUrl.replaceAll('www.', '');
    var response = await http.post(
        'https://superadmin.ordere.co.uk/API/Merchant/updateSettings/',
        body: {
          "domain": url,
          "key": "4a85a366-9d2d-4d65-a443-8cef021010a8",
          "enablePendingOrderSound": enablePendingOrderSound.toString(),
          "hideRestaurantAddressOnReceipt":
              hideRestaurantAddressOnReceipt.toString(),
          "displayOrderIdTable": displayOrderIdTable.toString(),
          "autoPrintTableBookingReceipt":
              autoPrintTableBookingReceipt.toString(),
          "autoPrintOrder": autoPrintOrder.toString(),
          "showOnlyCurrentDaysOrder": showOnlyCurrentDaysOrder.toString(),
          "kitchenReceiptDefault": kitchenReceiptDefault.toString(),
          "kitchenReceiptSameAsFront": kitchenReceiptSameAsFront.toString(),
          "displayOrderIdInReceipt": displayOrderIdInReceipt.toString(),
          "displayAwaitingNotPaidPayment":
              displayAwaitingNotPaidPayment.toString(),
          "enableAwaitingNotPaidPaymentSound":
              enableAwaitingNotPaidPaymentSound.toString(),
          "enableDeveloperMode": enableDeveloperMode.toString(),
          "unconfirmed_payment_button_value": unconfirmed_payment_button_value,
          "paper_size": paper_size,
          "autoCutter": autoCutter,
          "number_of_front_receipt_value": number_of_front_receipt_value,
          "number_of_kitchen_receipt_value": number_of_kitchen_receipt_value,
          "pending_order_sound_length_value": pending_order_sound_length_value,
          "autoAcceptTableBooking": auto_accepted_table_booking,
          "version": version
        });


  }
}
