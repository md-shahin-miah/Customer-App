import 'package:flutter/material.dart';

import 'set_del_col.dart';

class DeliveryCollectionSetting extends StatefulWidget {
  @override
  _DeliveryCollectionState createState() => _DeliveryCollectionState();
}

class _DeliveryCollectionState extends State<DeliveryCollectionSetting> {
  List<Widget> widgetList = List();

  final List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < days.length; i++) {
      widgetList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => SetDelCol(days[i], '$i')));
          },
          child: Card(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                days[i],
                style: TextStyle(fontSize: 20),
              ),
            ),
          )),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Time Settings')), body: ListView(children: widgetList));
  }
}
