import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:blue/global/tracker.dart';
import 'package:blue/model/menu_food_model.dart';
import 'package:blue/podo/menu/menu_subitem.dart';
import 'package:blue/view/loader.dart';

class EditSubItemPage extends StatefulWidget {
  final MenuSubItem subItem;
  final String itemName;
  EditSubItemPage(this.itemName, this.subItem);

  @override
  _EditSubItemPageState createState() => _EditSubItemPageState();
}

class _EditSubItemPageState extends State<EditSubItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController tecSubItemName = TextEditingController();
  TextEditingController tecMinimum = TextEditingController();
  TextEditingController tecMaximum = TextEditingController();
  String requredDropdownValue = "Yes";
  String visibilityDropdownValue = "Yes";
  List<String> requireds = ["Yes", "No"];
  List<String> visibilities = ["Yes", "No"];
  bool isAddEatinPrice = false;

  @override
  void initState() {
    tecSubItemName.text = widget.subItem.subItemName;
    tecMinimum.text = '${widget.subItem.optionMin}';
    tecMaximum.text = '${widget.subItem.optionMax}';
    requredDropdownValue = widget.subItem.subItemRequired == 0 ? "No" : "Yes";
    visibilityDropdownValue = widget.subItem.visibility == 0 ? "No" : "Yes";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.itemName),
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Subitem Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.grey[300],
                    width: 1.0,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: tecSubItemName,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Subitem Name'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Minimum',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.grey[300],
                    width: 1.0,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: tecMinimum,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Minimum'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Maximum',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.grey[300],
                    width: 1.0,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: tecMaximum,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Maximum'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Required',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.grey[300],
                    width: 1.0,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: requredDropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: SizedBox(),
                      onChanged: (String data) {
                        setState(() {
                          requredDropdownValue = data;
                        });
                      },
                      items: requireds
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Visibility',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.grey[300],
                    width: 1.0,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: visibilityDropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: SizedBox(),
                      onChanged: (String data) {
                        setState(() {
                          visibilityDropdownValue = data;
                        });
                      },
                      items: visibilities
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 60, right: 60),
            child: RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.deepOrange)),
              color: Colors.deepOrange,
              onPressed: () async {
                MenuSubItem subItemPodo = MenuSubItem();

                subItemPodo.itemId = widget.subItem.itemId;
                subItemPodo.subItemId = widget.subItem.subItemId;
                subItemPodo.subItemName = tecSubItemName.text;
                subItemPodo.subItemRequired =
                    requredDropdownValue == "Yes" ? 1 : 0;
                subItemPodo.optionMin = int.parse(tecMinimum.text);
                subItemPodo.optionMax = int.parse(tecMaximum.text);
                subItemPodo.visibility =
                    visibilityDropdownValue == "Yes" ? 1 : 0;
                final overlay = LoadingOverlay.of(context);
                final response =
                    await overlay.during(FoodModel.updateSubItem(subItemPodo));

                if (response == 'success') {
                  setState(() {
                    AppStateTracker.isSubItemReload = true;
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: Text('Subitem updated successfully.')));
                  });
                }
              },
            ),
          )
        ]));
  }
}
