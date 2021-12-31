import 'package:blue/global/constant.dart';
import 'package:blue/model/order_details_model.dart';

import 'custom_front_receipt.dart';
import 'front_receipt.dart';
import 'kitchen_receipt.dart';

class GlobalPrinting {
  Future printOrder58(int id) async {
    if (OrderDetailsModel.customer.total == null) {
      print(' customerTotal Null----------------------');
      bool result = await OrderDetailsModel.getOrderDetails(id);

      if (result) {
        FrontReceipt frontReceipt = FrontReceipt();

        print('---------autoPrintOrder----------${Static.autoPrintOrder}');
        print(
            '---------Static.Number_of_front_receipt_Value----------${Static.Number_of_front_receipt_Value}');
        print(
            '---------Static.kitchenReceiptDefault----------${Static.kitchenReceiptDefault}');
        print(
            '---------Static.kitchenReceiptSameAsFront----------${Static.kitchenReceiptSameAsFront}');
        // if(Static.autoPrintOrder){
        if (Static.Number_of_front_receipt_Value == 'One') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
            frontReceipt.frontReceipt(0, id);}
        } else if (Static.Number_of_front_receipt_Value == 'Two') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
            for (int i = 0; i < 2; i++) {
              frontReceipt.frontReceipt(0, id);
            }}
        } else if (Static.Number_of_front_receipt_Value == 'Three') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
            for (int i = 0; i < 3; i++) {
              frontReceipt.frontReceipt(0, id);
            }}
        } else if (Static.Number_of_front_receipt_Value == 'Four') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
            for (int i = 0; i < 4; i++) {
              frontReceipt.frontReceipt(0, id);
            }}
        } else if (Static.Number_of_front_receipt_Value == 'Five') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
            for (int i = 0; i < 5; i++) {
              frontReceipt.frontReceipt(0, id);
            }}
        }
      }
    } else {
      FrontReceipt frontReceipt = FrontReceipt();

      print('---------autoPrintOrder----------${Static.autoPrintOrder}');
      print(
          '---------Static.Number_of_front_receipt_Value----------${Static.Number_of_front_receipt_Value}');
      print(
          '---------Static.kitchenReceiptDefault----------${Static.kitchenReceiptDefault}');
      print(
          '---------Static.kitchenReceiptSameAsFront----------${Static.kitchenReceiptSameAsFront}');
      // if(Static.autoPrintOrder){
      if (Static.Number_of_front_receipt_Value == 'One') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
          frontReceipt.frontReceipt(0, id);}
      } else if (Static.Number_of_front_receipt_Value == 'Two') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
          for (int i = 0; i < 2; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
      } else if (Static.Number_of_front_receipt_Value == 'Three') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
          for (int i = 0; i < 3; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
      } else if (Static.Number_of_front_receipt_Value == 'Four') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
          for (int i = 0; i < 4; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
      } else if (Static.Number_of_front_receipt_Value == 'Five') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
          for (int i = 0; i < 5; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
      }
    }
  }

  Future printOrder80(int id) async {

    FrontReceipt80 frontReceipt = FrontReceipt80();
    if (OrderDetailsModel.customer.total == null) {
      print(' customerTotal Null----------------------');
      bool result = await OrderDetailsModel.getOrderDetails(id);

      if (result) {
        //FrontReceipt80 frontReceipt = FrontReceipt80();


        print('---------autoPrintOrder----------${Static.autoPrintOrder}');
        print(
            '---------Static.Number_of_front_receipt_Value----------${Static.Number_of_front_receipt_Value}');
        print(
            '---------Static.kitchenReceiptDefault----------${Static.kitchenReceiptDefault}');
        print(
            '---------Static.kitchenReceiptSameAsFront----------${Static.kitchenReceiptSameAsFront}');
        // if(Static.autoPrintOrder){
        if (Static.Number_of_front_receipt_Value == 'One') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
          frontReceipt.frontReceipt(0, id);}
        } else if (Static.Number_of_front_receipt_Value == 'Two') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
          for (int i = 0; i < 2; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
        } else if (Static.Number_of_front_receipt_Value == 'Three') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
          for (int i = 0; i < 3; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
        } else if (Static.Number_of_front_receipt_Value == 'Four') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
          for (int i = 0; i < 4; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
        } else if (Static.Number_of_front_receipt_Value == 'Five') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
          for (int i = 0; i < 5; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
        }
      }
    } else {
      // CustomFrontReceipt frontReceipt = CustomFrontReceipt();

      print('---------autoPrintOrder----------${Static.autoPrintOrder}');
      print(
          '---------Static.Number_of_front_receipt_Value----------${Static.Number_of_front_receipt_Value}');
      print(
          '---------Static.kitchenReceiptDefault----------${Static.kitchenReceiptDefault}');
      print(
          '---------Static.kitchenReceiptSameAsFront----------${Static.kitchenReceiptSameAsFront}');
      // if(Static.autoPrintOrder){
      if (Static.Number_of_front_receipt_Value == 'One') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
        frontReceipt.frontReceipt(0, id);}
      } else if (Static.Number_of_front_receipt_Value == 'Two') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
        for (int i = 0; i < 2; i++) {
          frontReceipt.frontReceipt(0, id);
        }}
      } else if (Static.Number_of_front_receipt_Value == 'Three') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
        for (int i = 0; i < 3; i++) {
          frontReceipt.frontReceipt(0, id);
        }}
      } else if (Static.Number_of_front_receipt_Value == 'Four') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
        for (int i = 0; i < 4; i++) {
          frontReceipt.frontReceipt(0, id);
        }}
      } else if (Static.Number_of_front_receipt_Value == 'Five') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
        for (int i = 0; i < 5; i++) {
          frontReceipt.frontReceipt(0, id);
        }}
      }
    }
  }

  Future printOrder80Large(int id) async {
    CustomFrontReceipt frontReceipt = CustomFrontReceipt();
    if (OrderDetailsModel.customer.total == null) {
      print(' customerTotal Null----------------------');
      bool result = await OrderDetailsModel.getOrderDetails(id);

      if (result) {
        //FrontReceipt80 frontReceipt = FrontReceipt80();


        print('---------autoPrintOrder----------${Static.autoPrintOrder}');
        print(
            '---------Static.Number_of_front_receipt_Value----------${Static.Number_of_front_receipt_Value}');
        print(
            '---------Static.kitchenReceiptDefault----------${Static.kitchenReceiptDefault}');
        print(
            '---------Static.kitchenReceiptSameAsFront----------${Static.kitchenReceiptSameAsFront}');
        // if(Static.autoPrintOrder){
        if (Static.Number_of_front_receipt_Value == 'One') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
            frontReceipt.frontReceipt(0, id);}
        } else if (Static.Number_of_front_receipt_Value == 'Two') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
            for (int i = 0; i < 2; i++) {
              frontReceipt.frontReceipt(0, id);
            }}
        } else if (Static.Number_of_front_receipt_Value == 'Three') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
            for (int i = 0; i < 3; i++) {
              frontReceipt.frontReceipt(0, id);
            }}
        } else if (Static.Number_of_front_receipt_Value == 'Four') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
            for (int i = 0; i < 4; i++) {
              frontReceipt.frontReceipt(0, id);
            }}
        } else if (Static.Number_of_front_receipt_Value == 'Five') {
          if(!Static.printedOrders.contains(id.toString())){
            Static.printedOrders.add(id.toString());
            for (int i = 0; i < 5; i++) {
              frontReceipt.frontReceipt(0, id);
            }}
        }
      }
    } else {
      // CustomFrontReceipt frontReceipt = CustomFrontReceipt();

      print('---------autoPrintOrder----------${Static.autoPrintOrder}');
      print(
          '---------Static.Number_of_front_receipt_Value----------${Static.Number_of_front_receipt_Value}');
      print(
          '---------Static.kitchenReceiptDefault----------${Static.kitchenReceiptDefault}');
      print(
          '---------Static.kitchenReceiptSameAsFront----------${Static.kitchenReceiptSameAsFront}');
      // if(Static.autoPrintOrder){
      if (Static.Number_of_front_receipt_Value == 'One') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
          frontReceipt.frontReceipt(0, id);}
      } else if (Static.Number_of_front_receipt_Value == 'Two') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
          for (int i = 0; i < 2; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
      } else if (Static.Number_of_front_receipt_Value == 'Three') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
          for (int i = 0; i < 3; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
      } else if (Static.Number_of_front_receipt_Value == 'Four') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
          for (int i = 0; i < 4; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
      } else if (Static.Number_of_front_receipt_Value == 'Five') {
        if(!Static.printedOrders.contains(id.toString())){
          Static.printedOrders.add(id.toString());
          for (int i = 0; i < 5; i++) {
            frontReceipt.frontReceipt(0, id);
          }}
      }
    }
  }

  printKitchenReceipt(int id) async {
    // await OrderDetailsModel.getOrderDetails(id);
    if (OrderDetailsModel.customer.total == null) {
      print(' customerTotal Null----------------------');
      bool result = await OrderDetailsModel.getOrderDetails(id);

      if (result) {
        printType(id);
      }
    } else {
      printType(id);
    }
  }

  printType(int id) {
    FrontReceipt frontReceipt58 = FrontReceipt();
    FrontReceipt80 frontReceipt80 = FrontReceipt80();
    CustomFrontReceipt customFrontReceipt=CustomFrontReceipt();
    if (Static.kitchenReceiptDefault) {
      if (Static.Paper_Size == "58mm") {
        printKitchenOrderFinal58(id);
      } else {
        printKitchenOrderFinal80(id);
      }
    } else if (Static.kitchenReceiptSameAsFront) {
      if (Static.Paper_Size == "58mm") {
        frontReceipt58.frontReceipt(1, id);
      }
      else if(Static.Paper_Size=="80mm") {
        frontReceipt80.frontReceipt(1, id);
      }
      else{
        frontReceipt80.frontReceipt(1, id);
      }
    }
  }

  printKitchenOrderFinal58(int id) async {

    print("kitchen receipt--------------printKitchenOrderFinal58--------------id------$id--");
    KitchenReceipt kitchenReceipt = KitchenReceipt();
    if (OrderDetailsModel.customer.total == null) {
      print(' customerTotal Null----------------------');
      bool result = await OrderDetailsModel.getOrderDetails(id);

      if (result) {
        if (Static.Number_of_kitchen_receipt_Value == 'One') {
          if(!Static.printedOrdersKit.contains(id.toString())){
            Static.printedOrdersKit.add(id.toString());
            kitchenReceipt.kitchenReceipt(id);}
        } else if (Static.Number_of_kitchen_receipt_Value == 'Two') {
          if(!Static.printedOrdersKit.contains(id.toString())){
            Static.printedOrdersKit.add(id.toString());
            for (int i = 0; i < 2; i++) {
              kitchenReceipt.kitchenReceipt(id);
            }}
        } else if (Static.Number_of_kitchen_receipt_Value == 'Three') {
          if(!Static.printedOrdersKit.contains(id.toString())){
            Static.printedOrdersKit.add(id.toString());
            for (int i = 0; i < 3; i++) {
              kitchenReceipt.kitchenReceipt(id);
            }}
        } else if (Static.Number_of_kitchen_receipt_Value == 'Four') {
          if(!Static.printedOrdersKit.contains(id.toString())){
            Static.printedOrdersKit.add(id.toString());
            for (int i = 0; i < 4; i++) {
              kitchenReceipt.kitchenReceipt(id);
            }}
        } else if (Static.Number_of_kitchen_receipt_Value == 'Five') {
          if(!Static.printedOrdersKit.contains(id.toString())){
            Static.printedOrdersKit.add(id.toString());
            for (int i = 0; i < 5; i++) {
              kitchenReceipt.kitchenReceipt(id);
            }}
        }
      }
    } else {
      if (Static.Number_of_kitchen_receipt_Value == 'One') {
        if(!Static.printedOrdersKit.contains(id.toString())){
          Static.printedOrdersKit.add(id.toString());
          kitchenReceipt.kitchenReceipt(id);}
      } else if (Static.Number_of_kitchen_receipt_Value == 'Two') {
        if(!Static.printedOrdersKit.contains(id.toString())){
          Static.printedOrdersKit.add(id.toString());
          for (int i = 0; i < 2; i++) {
            kitchenReceipt.kitchenReceipt(id);
          }}
      } else if (Static.Number_of_kitchen_receipt_Value == 'Three') {
        if(!Static.printedOrdersKit.contains(id.toString())){
          Static.printedOrdersKit.add(id.toString());
          for (int i = 0; i < 3; i++) {
            kitchenReceipt.kitchenReceipt(id);
          }}
      } else if (Static.Number_of_kitchen_receipt_Value == 'Four') {
        if(!Static.printedOrdersKit.contains(id.toString())){
          Static.printedOrders.add(id.toString());
          for (int i = 0; i < 4; i++) {
            kitchenReceipt.kitchenReceipt(id);
          }}
      } else if (Static.Number_of_kitchen_receipt_Value == 'Five') {
        if(!Static.printedOrdersKit.contains(id.toString())){
          Static.printedOrdersKit.add(id.toString());
          for (int i = 0; i < 5; i++) {
            kitchenReceipt.kitchenReceipt(id);
          }}
      }
    }
  }

  printKitchenOrderFinal80(int id) async {
    KitchenReceipt80 kitchenReceipt = KitchenReceipt80();

    print(
        "Static.Number_of_kitchen_receipt_Value-------------------${Static.Number_of_kitchen_receipt_Value}");

    if (OrderDetailsModel.customer.total == null) {
      print(' customerTotal Null----------------------');
      bool result = await OrderDetailsModel.getOrderDetails(id);

      if (result) {
        if (Static.Number_of_kitchen_receipt_Value == 'One') {
          if(!Static.printedOrdersKit.contains(id.toString())){
            Static.printedOrdersKit.add(id.toString());
          kitchenReceipt.kitchenReceipt(id);}
        } else if (Static.Number_of_kitchen_receipt_Value == 'Two') {
          if(!Static.printedOrdersKit.contains(id.toString())){
            Static.printedOrdersKit.add(id.toString());
          for (int i = 0; i < 2; i++) {
            kitchenReceipt.kitchenReceipt(id);
          }}
        } else if (Static.Number_of_kitchen_receipt_Value == 'Three') {
          if(!Static.printedOrdersKit.contains(id.toString())){
            Static.printedOrdersKit.add(id.toString());
          for (int i = 0; i < 3; i++) {
            kitchenReceipt.kitchenReceipt(id);
          }}
        } else if (Static.Number_of_kitchen_receipt_Value == 'Four') {
          if(!Static.printedOrdersKit.contains(id.toString())){
            Static.printedOrdersKit.add(id.toString());
          for (int i = 0; i < 4; i++) {
            kitchenReceipt.kitchenReceipt(id);
          }}
        } else if (Static.Number_of_kitchen_receipt_Value == 'Five') {
          if(!Static.printedOrdersKit.contains(id.toString())){
            Static.printedOrdersKit.add(id.toString());
          for (int i = 0; i < 5; i++) {
            kitchenReceipt.kitchenReceipt(id);
          }}
        }
      }
    } else {
      if (Static.Number_of_kitchen_receipt_Value == 'One') {
        if(!Static.printedOrdersKit.contains(id.toString())){
          Static.printedOrdersKit.add(id.toString());
        kitchenReceipt.kitchenReceipt(id);}
      } else if (Static.Number_of_kitchen_receipt_Value == 'Two') {
        if(!Static.printedOrdersKit.contains(id.toString())){
          Static.printedOrdersKit.add(id.toString());
        for (int i = 0; i < 2; i++) {
          kitchenReceipt.kitchenReceipt(id);
        }}
      } else if (Static.Number_of_kitchen_receipt_Value == 'Three') {
        if(!Static.printedOrdersKit.contains(id.toString())){
          Static.printedOrdersKit.add(id.toString());
        for (int i = 0; i < 3; i++) {
          kitchenReceipt.kitchenReceipt(id);
        }}
      } else if (Static.Number_of_kitchen_receipt_Value == 'Four') {
        if(!Static.printedOrdersKit.contains(id.toString())){
          Static.printedOrdersKit.add(id.toString());
        for (int i = 0; i < 4; i++) {
          kitchenReceipt.kitchenReceipt(id);
        }}
      } else if (Static.Number_of_kitchen_receipt_Value == 'Five') {
        if(!Static.printedOrdersKit.contains(id.toString())){
          Static.printedOrdersKit.add(id.toString());
        for (int i = 0; i < 5; i++) {
          kitchenReceipt.kitchenReceipt(id);
        }}
      }
    }
  }
}
