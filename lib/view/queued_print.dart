import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:blue/model/order_model.dart';
import 'package:blue/view/loader.dart';

class QueuedPrint extends StatefulWidget {
  @override
  _QueuedPrintState createState() => _QueuedPrintState();
}

class _QueuedPrintState extends State<QueuedPrint> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Widget> orders = List();
  bool isloading = true;

  void _chooseOption(context, id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reprint Queue'),
                IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  Text(
                    'Order id - $id is on reprint queue.\nDo you want to clear it from queue?',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          final overlay = LoadingOverlay.of(context);
                          final response =
                              await overlay.during(OrderModel.clearReprint(id));

                          if (response == 'success') {
                            orders.clear();
                            getQueuedOrders();
                            setState(() {
                              _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                  content: Text(
                                      'Order has been cleared from queue.')));
                            });
                          }
                        },
                        child: Text(
                          'Clear',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )));
  }

  void getQueuedOrders() {
    OrderModel.getReprintQueue().then((value) {
      if (value != null) {
        for (int i = 0; i < value.length; i++) {
          String orderId = value[i]['order_person_contact'];
          orders.add(GestureDetector(
            onTap: () {
              _chooseOption(context, orderId);
            },
            child: Card(
              child: ListTile(
                leading: Icon(
                  Icons.arrow_right,
                ),
                title: Text('Order Id - $orderId'),
              ),
            ),
          ));
        }
      }
      isloading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    getQueuedOrders();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Print Queue'),
        ),
        body: orders.length == 0
            ? isloading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Center(child: CircularProgressIndicator())])
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Icon(
                          Icons.print,
                          size: 120,
                          color: Colors.grey[300],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'No reprint request in queue!',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                    ],
                  )
            : Column(children: orders));
  }
}
