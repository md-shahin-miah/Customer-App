import 'package:blue/podo/sub_item.dart';

class FoodItem {
  int itemId;
  String itemName;
  double itemPrice;
  int quantity;
  double itemTotal;
  String specialRequest;
  List<SubItem> subItems;

  FoodItem(this.itemId,this.itemName, this.itemPrice, this.quantity, this.itemTotal,
      this.specialRequest, this.subItems);
}
