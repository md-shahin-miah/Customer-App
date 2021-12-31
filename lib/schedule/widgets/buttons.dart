import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final String subText;

  Button(this.text, this.subText);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(
        text,
        style: TextStyle(color: Colors.white,
        fontSize: 18),
      ),
      subtitle: Text(
        subText,
        style: TextStyle(color: Colors.white,fontSize: 12),
      ),
      leading: Icon(
        Icons.calendar_today_sharp,
        color: Colors.black,
      ),

      // isThreeLine: false,
    );
  }
}
