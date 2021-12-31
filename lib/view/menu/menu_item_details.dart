import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:blue/global/tracker.dart';
import 'package:blue/model/menu_category_model.dart';
import 'package:blue/model/menu_food_model.dart';
import 'package:blue/podo/menu/menu_category.dart';
import 'package:blue/podo/menu/menu_food_item.dart';
import 'package:blue/podo/menu/menu_food_variance.dart';
import 'package:blue/podo/menu/menu_subitem.dart';
import 'package:blue/view/loader.dart';
import 'package:blue/view/menu/edit_item_variance.dart';
import 'package:blue/view/menu/edit_subitem.dart';
import 'package:blue/view/menu/menu_sub_item_variance.dart';
import 'package:need_resume/need_resume.dart';

class MenuItemDetails extends StatefulWidget {
  final MenuFoodItem foodItem;
  MenuItemDetails(this.foodItem);
  @override
  _MenuItemDetailsState createState() => _MenuItemDetailsState();
}

class _MenuItemDetailsState extends ResumableState<MenuItemDetails> {
  TextEditingController tecItemName = TextEditingController();
  TextEditingController tecItemDescription = TextEditingController();
  TextEditingController tecPerson = TextEditingController();
  TextEditingController tecPrice = TextEditingController();
  TextEditingController tecEatInPrice = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int selectedCategoryId;
  String categoryDropdownValue = 'Popular';
  String orderTypeDropdownValue = "Both";
  String visibilityDropdownValue = "Show";
  String subMenuDropdownValue = "Yes";
  String offerDropdownValue = "Yes";
  double spiceLevel = 0;

  List<String> categories = List();
  Map<String, int> catIds = Map();
  List<String> orderTypes = ["Delivery", "Collection", "Both", "Only Eat-in"];
  List<String> visibilityTypes = ["Show", "Hide"];
  List<String> subMenus = ["Yes", "No"];
  List<String> offers = ["Yes", "No"];

  bool isVegan = false;
  bool isNutAllergy = false;
  bool isVegeterian = false;
  bool isGultenFree = false;
  bool isHalal = false;

  List<Widget> subItems = List();
  List<Widget> variances = List();

  @override
  void initState() {

    tecItemName.text = widget.foodItem.itemName;
    tecItemDescription.text = widget.foodItem.itemDescription;
    tecPerson.text = '${widget.foodItem.itemPerson}';
    tecPrice.text = '${widget.foodItem.itemPrice}';
    tecEatInPrice.text = '${widget.foodItem.eatinItemPrice}';



    print("widget.foodItem.eatinAvailable init---${widget.foodItem.eatinAvailable}");

    subMenuDropdownValue = widget.foodItem.getSubItem == 1 ? "Yes" : "No";

    for (MenuCategory category in MenuCategoryModel.categories) {
      if (widget.foodItem.itemCategoryId == category.id) {
        categoryDropdownValue = category.categoryName;
        selectedCategoryId = category.id;
      }
      categories.add(category.categoryName);
      catIds.putIfAbsent(category.categoryName, () => category.id);
    }
    spiceLevel = widget.foodItem.spicyLevel.toDouble();

    if (widget.foodItem.itemDelCol == 1) {
      orderTypeDropdownValue = "Delivery";
    } else if (widget.foodItem.itemDelCol == 2) {
      orderTypeDropdownValue = "Collection";
    } else if (widget.foodItem.itemDelCol == 3) {
      orderTypeDropdownValue = "Both";
    } else if (widget.foodItem.itemDelCol == 30) {
      orderTypeDropdownValue = "Only Eat-in";
    }

    if (widget.foodItem.visibility == 1) {
      visibilityDropdownValue = "Show";
    } else if (widget.foodItem.visibility == 0) {
      visibilityDropdownValue = "Hide";
    }

    if (widget.foodItem.hasVariance) {
      FoodModel.foodItemVariances.clear();
      FoodModel.getFoodItemVariance(
              '${widget.foodItem.itemCategoryId}', '${widget.foodItem.itemId}')
          .then((value) {
        for (MenuFoodVariance variance in FoodModel.foodItemVariances) {
          variances.add(
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  '${variance.varianceName}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('${variance.variancePrice}'),
              ),
              isThreeLine: true,
              trailing: IconButton(
                onPressed: () {
                  push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditItemVariance(
                              '${widget.foodItem.itemCategoryId}',
                              '${widget.foodItem.itemId}',
                              variance,
                              widget.foodItem.itemName)));
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ),
            ),
          );
          variances.add(Divider());
        }
      });
    }

    if (widget.foodItem.getSubItem == 1) {
      FoodModel.getSubItem('${widget.foodItem.itemId}').then((value) {
        for (MenuSubItem subItem in FoodModel.subitems) {
          subItems.add(
            GestureDetector(
              onTap: () {
                push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MenuSubItemVariancePage(
                            '${subItem.subItemId}', '${subItem.subItemName}')));
              },
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    '${subItem.subItemName}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditSubItemPage(
                                '${widget.foodItem.itemName}', subItem)));
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
          subItems.add(Divider());
        }
      });
    }

    List<String> alergyList = widget.foodItem.allergyLevel.split(",");
    if (alergyList.contains("1")) {
      isVegan = true;
    } else if (alergyList.contains("2")) {
      isNutAllergy = true;
    } else if (alergyList.contains("3")) {
      isHalal = true;
    } else if (alergyList.contains("4")) {
      isVegeterian = true;
    } else if (alergyList.contains("5")) {
      isGultenFree = true;
    }
    setState(() {});

    super.initState();
  }

  @override
  void onResume() {
    print('onResume Called()');
    if (AppStateTracker.isMenuDetailsVarianceReload) {
      if (widget.foodItem.hasVariance) {
        FoodModel.foodItemVariances.clear();
        variances.clear();
        FoodModel.getFoodItemVariance('${widget.foodItem.itemCategoryId}',
                '${widget.foodItem.itemId}')
            .then((value) {
          for (MenuFoodVariance variance in FoodModel.foodItemVariances) {
            variances.add(
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    '${variance.varianceName}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('${variance.variancePrice}'),
                ),
                isThreeLine: true,
                trailing: IconButton(
                  onPressed: () {
                    push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditItemVariance(
                                '${widget.foodItem.itemCategoryId}',
                                '${widget.foodItem.itemId}',
                                variance,
                                widget.foodItem.itemName)));
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            );
            variances.add(Divider());
          }
          setState(() {});
        });
      }
    }

    if (AppStateTracker.isSubItemReload) {
      print('onResume Called() 2');
      if (widget.foodItem.getSubItem == 1) {
        print('onResume Called() 3');
        FoodModel.subitems.clear();
        subItems.clear();
        AppStateTracker.isSubItemReload = false;

        FoodModel.getSubItem('${widget.foodItem.itemId}').then((value) {
          for (MenuSubItem subItem in FoodModel.subitems) {
            subItems.add(
              GestureDetector(
                onTap: () {
                  push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MenuSubItemVariancePage(
                              '${subItem.subItemId}',
                              '${subItem.subItemName}')));
                },
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '${subItem.subItemName}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditSubItemPage(
                                  '${widget.foodItem.itemName}', subItem)));
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
            subItems.add(Divider());
          }
          setState(() {});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${widget.foodItem.itemName}'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Item Name',
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
                      controller: tecItemName,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Item Name'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          widget.foodItem.hasVariance
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Price',
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
                            controller: tecPrice,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Price'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          widget.foodItem.hasVariance
              ? SizedBox()
              : widget.foodItem.eatinAvailable==30 ?  Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Eatin Price',
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
                            controller: tecEatInPrice,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Eatin Price'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ):Container(),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Category',
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
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: categoryDropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: SizedBox(),
                      onChanged: (String data) {
                        setState(() {
                          categoryDropdownValue = data;
                          selectedCategoryId = catIds[data];
                        });
                      },
                      items: categories
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
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Item Description',
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
                      controller: tecItemDescription,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Item Description'),
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
                    'Person',
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
                      controller: tecPerson,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Person'),
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
                    'Order Type',
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
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: orderTypeDropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: SizedBox(),
                      onChanged: (String data) {
                        setState(() {
                          orderTypeDropdownValue = data;
                        });
                      },
                      items: orderTypes
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
                    //                   <--- left side
                    color: Colors.grey[300],
                    width: 1.0,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
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
                      items: visibilityTypes
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
                    'Sub Menu',
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
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: subMenuDropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: SizedBox(),
                      onChanged: (String data) {
                        setState(() {
                          subMenuDropdownValue = data;
                        });
                      },
                      items: subMenus
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
                    'Offer Include',
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
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: offerDropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: SizedBox(),
                      onChanged: (String data) {
                        setState(() {
                          offerDropdownValue = data;
                        });
                      },
                      items:
                          offers.map<DropdownMenuItem<String>>((String value) {
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
                    'Spice level',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.grey[300],
                    width: 1.0,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Center(
                      child: RatingBar.builder(
                        initialRating: spiceLevel,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 3,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                        ),
                        onRatingUpdate: (rating) {
                          spiceLevel = rating;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                //                   <--- left side
                color: Colors.grey[300],
                width: 1.0,
              )),
              child: ExpansionTile(
                title: Text(
                  'Alergy sign',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                title: Text('Vegan'),
                                secondary: Image.asset(
                                  'assets/icons/vegan.png',
                                  height: 30,
                                ),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                selected: isVegan,
                                value: isVegan,
                                onChanged: (bool value) {
                                  setState(() {
                                    isVegan = value;
                                  });
                                },
                              ),
                              Divider(),
                              CheckboxListTile(
                                title: Text('Nut Allergy'),
                                secondary: Image.asset(
                                  'assets/icons/nut_allergy.png',
                                  height: 30,
                                ),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                selected: isNutAllergy,
                                value: isNutAllergy,
                                onChanged: (bool value) {
                                  setState(() {
                                    isNutAllergy = value;
                                  });
                                },
                              ),
                              Divider(),
                              CheckboxListTile(
                                title: Text('Halal'),
                                secondary: Image.asset(
                                  'assets/icons/halal.png',
                                  height: 30,
                                ),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                selected: isHalal,
                                value: isHalal,
                                onChanged: (bool value) {
                                  setState(() {
                                    isHalal = value;
                                  });
                                },
                              ),
                              Divider(),
                              CheckboxListTile(
                                title: Text('Vegetarian'),
                                secondary: Image.asset(
                                  'assets/icons/vegetarian.png',
                                  height: 30,
                                ),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                selected: isVegeterian,
                                value: isVegeterian,
                                onChanged: (bool value) {
                                  setState(() {
                                    isVegeterian = value;
                                  });
                                },
                              ),
                              Divider(),
                              CheckboxListTile(
                                title: Text('Gluten Free'),
                                secondary: Image.asset(
                                  'assets/icons/glutenfree.png',
                                  height: 30,
                                ),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                selected: isGultenFree,
                                value: isGultenFree,
                                onChanged: (bool value) {
                                  setState(() {
                                    isGultenFree = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                    'Include eat-in',
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
                    child: CheckboxListTile(
                      title: Text('Include Eat-in'),
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      selected:
                          widget.foodItem.eatinAvailable == 30 ? true : false,
                      value:
                          widget.foodItem.eatinAvailable == 30 ? true : false,
                      onChanged: (bool value) {
                        setState(() {
                          value == true
                              ? widget.foodItem.eatinAvailable = 30
                              : widget.foodItem.eatinAvailable = -10;
                        });
                      },
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
                MenuFoodItem foodItem = widget.foodItem;
                foodItem.itemName = tecItemName.text;
                foodItem.itemCategoryId = selectedCategoryId;
                foodItem.itemDescription = tecItemDescription.text;
                foodItem.allergyLevel = "";
                foodItem.itemPerson = int.parse(tecPerson.text);
                foodItem.itemPrice=double.parse(tecPrice.text);
                foodItem.eatinItemPrice=double.parse(tecEatInPrice.text);

                if (orderTypeDropdownValue == "Delivery") {
                  widget.foodItem.itemDelCol = 1;
                } else if (orderTypeDropdownValue == "Collection") {
                  widget.foodItem.itemDelCol = 2;
                } else if (orderTypeDropdownValue == "Both") {
                  widget.foodItem.itemDelCol = 3;
                } else if (orderTypeDropdownValue == "Only Eat-in") {
                  widget.foodItem.itemDelCol = 30;
                }

                if (isVegan) {
                  foodItem.allergyLevel += "1,";
                } else if (isNutAllergy) {
                  foodItem.allergyLevel += "2,";
                } else if (isHalal) {
                  foodItem.allergyLevel += "3,";
                } else if (isVegeterian) {
                  foodItem.allergyLevel += "4,";
                } else if (isGultenFree) {
                  foodItem.allergyLevel += "5";
                }



                foodItem.spicyLevel = spiceLevel.toInt();
                foodItem.visibility = visibilityDropdownValue == "Show" ? 1 : 0;
                foodItem.getSubItem = subMenuDropdownValue == "Yes" ? 1 : 0;

                final overlay = LoadingOverlay.of(context);
                final response =
                    await overlay.during(FoodModel.updateFoodItem(foodItem));

                if (response == 'success') {
                  setState(() {
                    //AppStateTracker.isSubItemVarianceReload = true;
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: Text('Item updated successfully.')));
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 12,
          ),
          widget.foodItem.hasVariance
              ? Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.grey[300],
                      width: 1.0,
                    )),
                    child: ExpansionTile(
                      title: Text(
                        'Variance(s) of ${widget.foodItem.itemName}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Column(children: variances),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          widget.foodItem.getSubItem == 1
              ? Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.grey[300],
                      width: 1.0,
                    )),
                    child: ExpansionTile(
                      title: Text(
                        'Subitem(s) of ${widget.foodItem.itemName}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Column(children: subItems),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
