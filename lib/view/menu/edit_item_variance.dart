import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:blue/global/tracker.dart';
import 'package:blue/model/menu_food_model.dart';
import 'package:blue/podo/menu/menu_food_variance.dart';
import 'package:blue/view/loader.dart';

class EditItemVariance extends StatefulWidget {
  final categoryId, itemId;
  final MenuFoodVariance variance;
  final itemName;

  EditItemVariance(this.categoryId, this.itemId, this.variance, this.itemName);

  @override
  _EditItemVarianceState createState() => _EditItemVarianceState();
}

class _EditItemVarianceState extends State<EditItemVariance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController tecVarianceName = TextEditingController();
  TextEditingController tecVariancePrice = TextEditingController();
  TextEditingController tecVarianceEatInPrice = TextEditingController();
  String visibilityDropdownValue = "Show";
  List<String> visibilities = ["Show", "Hide"];
  bool isAddEatinPrice = false;

  @override
  void initState() {
    tecVarianceName.text = widget.variance.varianceName;
    tecVariancePrice.text = '${widget.variance.variancePrice}';
    tecVarianceEatInPrice.text = '${widget.variance.eatinVariancePrice}';
    visibilityDropdownValue = widget.variance.vsibility == 1 ? "Show" : "Hide";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('${widget.variance.varianceName} ${widget.itemName}'),
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
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
                    'Variance Name',
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
                      controller: tecVarianceName,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Variance Name'),
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
                    'Variance Price',
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
                      controller: tecVariancePrice,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Variance Price'),
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
          widget.variance.eatinVariancePrice == -10
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Colors.green,
                          onPressed: () {
                            setState(() {
                              isAddEatinPrice = true;
                            });
                          },
                          child: Text(
                            'Add Eatin price',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      isAddEatinPrice
                          ? Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.grey[300],
                                width: 1.0,
                              )),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Variance Eatin Price'),
                                      ),
                                    ),
                                    Flexible(
                                      child: IconButton(
                                        icon: Icon(Icons.close),
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          setState(() {
                                            isAddEatinPrice = false;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Variance Eatin Price',
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
                            controller: tecVarianceEatInPrice,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Variance Eatin Price'),
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
                MenuFoodVariance variancePodo = widget.variance;

                variancePodo.varianceName = tecVarianceName.text;
                variancePodo.variancePrice =
                    double.parse(tecVariancePrice.text);
                variancePodo.eatinVariancePrice =
                    double.parse(tecVarianceEatInPrice.text);

                variancePodo.vsibility =
                    visibilityDropdownValue == "Show" ? 1 : 0;

                final overlay = LoadingOverlay.of(context);
                final response = await overlay
                    .during(FoodModel.updateFoodVariance(variancePodo));

                if (response == 'success') {
                  setState(() {
                    AppStateTracker.isMenuDetailsVarianceReload = true;
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: Text('Varaince updated successfully.')));
                  });
                }
              },
            ),
          )
        ]));
  }
}
