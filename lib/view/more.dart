import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'queued_print.dart';
import 'login_page.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        // appBar: AppBar(
        //   title: Text('OrderE - Merchant App'),
        // ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () =>
                  _launchURL('https://ordervox.co.uk/index.php/privacy-policy'),
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.arrow_right,
                  ),
                  title: Text('Privacy Policy'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _launchURL(
                  'https://ordervox.co.uk/index.php/terms-and-condition/'),
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.arrow_right,
                  ),
                  title: Text('Terms & Conditions'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => QueuedPrint())),
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.arrow_right,
                  ),
                  title: Text('Reprint Queue'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setInt('logged', 0);
                await prefs.setString('printer_address', '-1');

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.arrow_right,
                  ),
                  title: Text('Logout'),
                ),
              ),
            ),
          ],
        ));
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
