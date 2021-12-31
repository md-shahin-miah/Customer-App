import 'package:blue/interfaces/delete_listener.dart';
import 'package:blue/model/schedule_model.dart';
import 'package:blue/podo/schedule_podo.dart';
import 'package:blue/view/loader.dart';
import 'package:flutter/material.dart';

class HomeListView extends StatelessWidget {

  final List<Schedule> dateList;

 final DeleteListener deleteListener;

  HomeListView(this.dateList,this.deleteListener);

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
                          // final response =
                          // await overlay.during(OrderModel.clearReprint(id));

                          // if (response == 'success') {
                          //   orders.clear();
                          //   getQueuedOrders();
                          //   setState(() {
                          //     _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          //         content: Text(
                          //             'Order has been cleared from queue.')));
                          //   });
                          //  }
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




  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: dateList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text('Closed on',
                style: TextStyle(fontSize: 18, color: Colors.redAccent)),
            subtitle: Text(
              '${dateList[index].date}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            leading: Icon(
              Icons.event_note,
              color: Colors.black,
            ),
            trailing: GestureDetector(
              onTap: () async{

              deleteListener.delete(dateList[index].id);


              },
              child: Icon(
                Icons.delete,
                color: Colors.red[700],

              ),
            ),
          ),
        );
      },
    );
  }
}
