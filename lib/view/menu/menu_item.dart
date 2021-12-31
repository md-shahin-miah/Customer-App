import 'package:flutter/material.dart';
import 'package:blue/model/menu_food_model.dart';

import 'menu_item_details.dart';

class MenuItemPage extends StatefulWidget {
  final catId;
  final String categoryName;

  MenuItemPage(this.catId, this.categoryName);

  @override
  _MenuItemPageState createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  @override
  void initState() {
    FoodModel.getFoodItems(widget.catId).then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: FoodModel.foodItems.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          MenuItemDetails(FoodModel.foodItems[index]))),
              child: Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(2, 2), // changes position of shadow
                    ),
                  ],
                  color: Colors.grey[50],
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '${FoodModel.foodItems[index].itemName}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child:
                        Text('${FoodModel.foodItems[index].itemDescription}'),
                  ),
                  isThreeLine: true,
                ),
              ),
            );
          }),
    );
  }
}
