import 'package:flutter/material.dart';
import 'package:blue/model/menu_food_model.dart';

class MenuItemVariancePage extends StatefulWidget {
  final catId;
  final itemId;
  final String itemName;

  MenuItemVariancePage(this.catId, this.itemId, this.itemName);

  @override
  _MenuItemVariancePageState createState() => _MenuItemVariancePageState();
}

class _MenuItemVariancePageState extends State<MenuItemVariancePage> {
  @override
  void initState() {
    FoodModel.getFoodItemVariance(widget.catId, '${widget.itemId}')
        .then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemName),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: FoodModel.foodItemVariances.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => null)),
              child: Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                  color: Colors.grey[50],
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '${FoodModel.foodItemVariances[index].varianceName}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                        '${FoodModel.foodItemVariances[index].variancePrice}'),
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
