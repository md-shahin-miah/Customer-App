import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:blue/global/tracker.dart';
import 'package:blue/model/menu_category_model.dart';
import 'package:blue/podo/menu/menu_category.dart';
import 'package:blue/view/loader.dart';

class EditCategoryPage extends StatefulWidget {
  final MenuCategory category;
  EditCategoryPage(this.category);

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController tecCategoryName = TextEditingController();
  TextEditingController tecCategoryDescription = TextEditingController();

  bool saturday = false;
  bool sunday = false;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;

  List<String> activeDayList;

  @override
  void initState() {
    tecCategoryName.text = widget.category.categoryName;
    tecCategoryDescription.text = widget.category.description;
    activeDayList = widget.category.activeDays.split(",");
    for (int i = 0; i < activeDayList.length; i++) {
      if (activeDayList[i] == "6") {
        saturday = true;
      }
      if (activeDayList[i] == "0") {
        sunday = true;
      }
      if (activeDayList[i] == "1") {
        monday = true;
      }
      if (activeDayList[i] == "2") {
        tuesday = true;
      }
      if (activeDayList[i] == "3") {
        wednesday = true;
      }
      if (activeDayList[i] == "4") {
        thursday = true;
      }
      if (activeDayList[i] == "5") {
        friday = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.category.categoryName),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Category Name',
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
                      controller: tecCategoryName,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Category Name'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Category Description',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    //                   <--- left side
                    color: Colors.grey[300],
                    width: 1.0,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: tecCategoryDescription,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Category Description'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Container(
              margin: EdgeInsets.only(top: 8),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.grey[300])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Active Days',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('Sunday'),
                    secondary: const Icon(Icons.web),
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    selected: sunday,
                    value: sunday,
                    onChanged: (bool value) {
                      setState(() {
                        sunday = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Monday'),
                    secondary: const Icon(Icons.web),
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    selected: monday,
                    value: monday,
                    onChanged: (bool value) {
                      setState(() {
                        monday = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Tuesday'),
                    secondary: const Icon(Icons.web),
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    selected: tuesday,
                    value: tuesday,
                    onChanged: (bool value) {
                      setState(() {
                        tuesday = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Wednesday'),
                    secondary: const Icon(Icons.web),
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    selected: wednesday,
                    value: wednesday,
                    onChanged: (bool value) {
                      setState(() {
                        wednesday = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Thursday'),
                    secondary: const Icon(Icons.web),
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    selected: thursday,
                    value: thursday,
                    onChanged: (bool value) {
                      setState(() {
                        thursday = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Friday'),
                    secondary: const Icon(Icons.web),
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    selected: friday,
                    value: friday,
                    onChanged: (bool value) {
                      setState(() {
                        friday = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Saturday'),
                    secondary: const Icon(Icons.web),
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    selected: saturday,
                    value: saturday,
                    onChanged: (bool value) {
                      setState(() {
                        saturday = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 64.0, right: 64),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.deepOrange)),
              onPressed: () async {
                MenuCategory categoryPodo = MenuCategory();
                categoryPodo.id = widget.category.id;
                categoryPodo.categoryName = tecCategoryName.text;
                categoryPodo.description = tecCategoryDescription.text;

                String activeDays = "";
                if (saturday) {
                  activeDays += "6,";
                }
                if (sunday) {
                  activeDays += "0,";
                }
                if (monday) {
                  activeDays += "1,";
                }
                if (tuesday) {
                  activeDays += "2,";
                }
                if (wednesday) {
                  activeDays += "3,";
                }
                if (thursday) {
                  activeDays += "4,";
                }
                if (friday) {
                  activeDays += "5,";
                }

                if (activeDays.endsWith(",")) {
                  activeDays = activeDays.substring(0, activeDays.length - 1);
                }

                categoryPodo.activeDays = activeDays;

                final overlay = LoadingOverlay.of(context);
                final response = await overlay
                    .during(MenuCategoryModel.updateCategory(categoryPodo));

                if (response == 'success') {
                  setState(() {
                    AppStateTracker.isMenuReload = true;
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: Text('Category updated successfully.')));
                  });
                }
              },
              color: Colors.deepOrange,
              textColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 32.0, right: 32, top: 12, bottom: 12),
                child: Text("Update", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
