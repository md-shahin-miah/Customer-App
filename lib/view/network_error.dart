import 'package:flutter/material.dart';

class NetworkErrorScreen extends StatefulWidget {
  @override
  _NetworkErrorScreenState createState() => _NetworkErrorScreenState();
}

class _NetworkErrorScreenState extends State<NetworkErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height/4,
                  width: MediaQuery.of(context).size.width/2,
                  child: Image.asset('assets/errornt.png')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(child: Text('Check your internet Connection and try again!')),
              )
            ],
          ),
        ),
    );
  }
}
