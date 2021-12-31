import 'package:flutter/material.dart';
import 'package:blue/model/menu_food_model.dart';
import 'package:blue/view/menu/edit_subitem_variance.dart';

class MenuSubItemVariancePage extends StatefulWidget {
  final subItemId;
  final subItemName;
  MenuSubItemVariancePage(this.subItemId, this.subItemName);

  @override
  _MenuSubItemVariancePageState createState() =>
      _MenuSubItemVariancePageState();
}

class _MenuSubItemVariancePageState extends State<MenuSubItemVariancePage> {
  @override
  void initState() {
    FoodModel.getSubItemVariance(widget.subItemId).then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subItemName}'),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: FoodModel.subitemVariances.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
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
                    '${FoodModel.subitemVariances[index].subItemVarianceName}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditItemSubVariance(
                                FoodModel.subitemVariances[index])));
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
