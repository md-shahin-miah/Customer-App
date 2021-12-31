import 'package:flutter/cupertino.dart';

class MyColors {
  static const colorPending = const Color(0xffF69C5D);
  static const colorAccepted = const Color(0xff2BB828);
  static const colorCancelled = const Color(0xffEF4B4B);
  static const colorNotPaid = const Color(0xff3CCCC3);
  static const colorTitle = const Color(0xffFF6A02);
  static const colorActiveIcon = const Color(0xffF06F15);
  static const colorActiveSwitch = const Color(0xff1fb538);
  static const colorFadeIcon = const Color(0xff808080);
}

class Api {
  static const SUPER_BASE_URL = 'https://superadmin.ordere.co.uk/API/Merchant/';
  static String LAST_HIT_URL = '';
  static String businessBaseUrl = '';

  static const KEY_ONLINE_ORDER = 'store_maintenance';

  static const KEY_TABLE_BOOKING = 'booktable_status';

  static const KEY_DEL_COL = 'delivery_coll_status';

  static const KEY_EAT_IN = '';

  static String BusinessUrl = '';
}

class Static {
  static String DEVICE_NAME = '';
  static String BusinessName = '';
  static String Domain = '';
  static int typeLast=1;
  static int typeLastOrder=1;

  static bool isPrintedLastLine=true;

  static String FirstTime = '0';

  static bool isBusy = false;

  static List<String> orderIdList = [];
  static List<String> printedOrders = [];
  static List<String> printedOrdersKit = [];
  static List<String> tableOrderList = [];
  static List<String> NewIdlIST = [];
  static String NewId = '0';

  static bool enablePendingOrderSound = true;
  static bool hideRestaurantAddressOnReceipt = false;
  static bool displayOrderIdTable = true;
  static bool autoPrintTableBookingReceipt = false;
  static bool autoPrintOrder = true;
  static bool showOnlyCurrentDaysOrder = false;
  static bool kitchenReceiptDefault = true;
  static bool kitchenReceiptSameAsFront = false;
  static bool displayOrderIdInReceipt = true;
  static bool displayAwaitingNotPaidPayment = false;
  static bool enableAwaitingNotPaidPaymentSound = false;
  static bool enableDeveloperMode = false;
  static bool autoAcceptTableBooking = false;

  // ignore: non_constant_identifier_names

  static String Unconfirmed_payment_button_Value = 'Awaiting';
  static String Paper_Size = '80mm-large';
  static String disableKitchenPopUp = 'No';
  static String IsLoggedOut = '0';

  // ignore: non_constant_identifier_names
  static String Number_of_front_receipt_Value = 'One';

  // ignore: non_constant_identifier_names
  static String Number_of_kitchen_receipt_Value = 'One';

  // ignore: non_constant_identifier_names
  static String Pending_order_sound_length_value = 'Long';

  static const String privacyPolicy = 'Privacy policy';

  static const String logOut = 'Logout';

  static String ORDER_ID = '';

  static bool isPopUpOn = false;
}
