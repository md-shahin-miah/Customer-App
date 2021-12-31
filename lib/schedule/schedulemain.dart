import 'package:blue/interfaces/delete_listener.dart';
import 'package:blue/model/schedule_model.dart';
import 'package:blue/podo/schedule_podo.dart';
import 'package:blue/schedule/widgets/buttons.dart';
import 'package:blue/schedule/widgets/homepagelistview.dart';
import 'package:blue/view/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';
import 'package:provider/provider.dart';

import 'widgets/constants.dart';
import 'screen/pickdate.dart';

class SchedulePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SchedulePage> implements DeleteListener {
  DateTime selectedDate = DateTime.now();
  List<Schedule> schedules = List();
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  void getData() {
    ScheduleModel.getSchedule().then((value) {
      if (value != null) {
        for (int i = 0; i < value.length; i++) {
          String startDate = value[i]['start_date'];
          String endDate = value[i]['end_date'];

          if (startDate != endDate) {
            startDate = startDate + '-' + endDate;
          }
          Schedule schedule = Schedule(value[i]['id'], startDate);
          // print(schedule.);

          schedules.add(schedule);
        }
      }
      print(schedules.length);

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<DateData>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Schedule'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (schedules.length) == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (schedules.length) == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    Constant.PICK_DATE,
                                    arguments: true),
                                child: Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    color: Colors.green,
                                    child: Button('Individual',
                                        'You Can add an off day for your business')),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    Constant.PICK_DATE,
                                    arguments: false),
                                child: Card(
                                    elevation: 5,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    color: Colors.deepOrange,
                                    child: Button('Range Date',
                                        'You Can add date range for your business')),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: HomeListView(schedules, this)),
                            ],
                          ),
                  ],
                )
              : Column(
                  children: [
                    (schedules.length) == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    Constant.PICK_DATE,
                                    arguments: true),
                                child: Card(
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    color: Colors.green,
                                    child: Button('Individual',
                                        'You Can add an off day for your business')),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    Constant.PICK_DATE,
                                    arguments: false),
                                child: Card(
                                    elevation: 5,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    color: Colors.deepOrange,
                                    child: Button('Range Date',
                                        'You Can add date range for your business')),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: HomeListView(schedules, this),
                              ),
                            ],
                          ),
                  ],
                ),
      floatingActionButton: (schedules.length) > 0
          ? BoomMenu(
              backgroundColor: Colors.deepOrange,
              animatedIcon: AnimatedIcons.add_event,
              animatedIconTheme: IconThemeData(size: 22.0),
              //child: Icon(Icons.add),
              onOpen: () => print('OPENING DIAL'),
              onClose: () => print('DIAL CLOSED'),
              scrollVisible: true,
              overlayColor: Colors.black,
              overlayOpacity: 0,
              children: [
                MenuItem(
                  child: Icon(Icons.date_range_outlined, color: Colors.black),
                  title: "Individual",
                  titleColor: Colors.white,
                  subtitle: "You Can add an off day for your business",
                  subTitleColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
                  onTap: () => Navigator.of(context)
                      .pushNamed(Constant.PICK_DATE, arguments: true),
                ),
                MenuItem(
                  child: Icon(Icons.date_range, color: Colors.black),
                  title: "Date range",
                  titleColor: Colors.white,
                  subtitle: "You Can add date range for your business",
                  subTitleColor: Colors.white,
                  backgroundColor: Colors.green,
                  onTap: () => Navigator.of(context)
                      .pushNamed(Constant.PICK_DATE, arguments: false),
                ),
              ],
            )
          : Container(),
    );
  }

  @override
  void delete(String id) async {
    // TODO: implement delete
    final overlay = LoadingOverlay.of(context);
    final response = await overlay.during(ScheduleModel.deleteSchedule(id));
    print('res : ' + response);
    if (response == 'success') {
      schedules.clear();
      setState(() {
        isLoading = true;
      });
      getData();
    }
  }
}
