import 'package:blue/view/SetDeliveryCollectionTimeLimit.dart';
import 'package:flutter/material.dart';

class DeliveryCollectionTimeLimit extends StatefulWidget {
  const DeliveryCollectionTimeLimit({Key key}) : super(key: key);

  @override
  _DeliveryCollectionTimeLimitState createState() => _DeliveryCollectionTimeLimitState();
}

class _DeliveryCollectionTimeLimitState extends State<DeliveryCollectionTimeLimit> {
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
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < days.length; i++) {
      widgetList.add(
        GestureDetector(
          onTap: () {
            print('daynum : $i');
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => SetDeliveryCollectionTimeLimit(days[i], '$i')));
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
    return Scaffold(appBar: AppBar(title: Text('Time Settings'),), body: ListView(children: widgetList));
  }
}
