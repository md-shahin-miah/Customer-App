import 'dart:async';

import 'package:blue/app_update.dart';
import 'package:blue/global/constant.dart';
import 'package:blue/model/auth.dart';
import 'package:blue/view/downloadLinkPage.dart';
import 'package:blue/view/printer_credential.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'loader.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String email = '';
  String BusinessName = '';
  String password = '';
  bool isLoading = false;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _obscureText = true;
  int isFirstTime=0;

  @override
  void initState() {
    // TODO: implement initState

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    super.initState();
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final providerLogin = Provider.of<LoginProvider>(context);

    print("connectivity status $_connectionStatus");

    final heightClipper = MediaQuery.of(context).size.height * 0.45;

    return Scaffold(

      key: _scaffoldKey,
      // backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipper2(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: heightClipper,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0x22ff3a5a), Color(0x22fe494d)])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper3(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: heightClipper,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper1(),
                child: Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 16,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 7,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/OrderEe.png'),
                        ),
                      ),
                      // Icon(
                      //   Icons.login,
                      //   color: Colors.white,
                      //   size: 50,
                      // ),

                      // Container(
                      //   height: MediaQuery.of(context).size.height/10,
                      //
                      //   child: FittedBox(
                      //     child: Image.asset(
                      //       'assets/OrderEe.png',
                      //     ),
                      //     fit: BoxFit.fill,
                      //   ),
                      // ),
                      Text(
                        "Merchant",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 25),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 26,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: heightClipper,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.deepOrange,
                    Colors.deepOrangeAccent
                  ])),
                ),
              ),
            ],
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                autocorrect: false,
                onChanged: (String value) {
                  BusinessName = value;
                },
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Business name",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.home_work,
                        color: Colors.deepOrange,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                autocorrect: false,
                onChanged: (String value) {
                  email = value;
                },
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.email,
                        color: Colors.deepOrange,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                autocorrect: false,
                obscureText: _obscureText,
                onChanged: (String value) {
                  password = value;
                },
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
                        color: Colors.deepOrange,
                      ),
                    ),
                    suffixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: InkWell(
                          onTap: () {
                            _toggle();
                          },
                          child: _obscureText
                              ? Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.deepOrange,
                                )
                              : Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.deepOrange,
                                )),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          // Container(
          //   child: new Column(
          //     children: <Widget>[
          //       new TextFormField(
          //         decoration: const InputDecoration(
          //             labelText: 'Password',
          //             icon: const Padding(
          //                 padding: const EdgeInsets.only(top: 15.0main),
          //                 child: const Icon(Icons.lock))),
          //         validator: (val) =>
          //             val.length < 6 ? 'Password too short.' : null,
          //         onSaved: (val) => _password = val,
          //         obscureText: _obscureText,
          //       ),
          //       new FlatButton(
          //           onPressed: _toggle,
          //           child: new Text(_obscureText ? "Show" : "Hide"))
          //     ],
          //   ),
          // ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
          if (isLoading)
            Center(child: CircularProgressIndicator(color: Colors.deepOrange))
          else
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.deepOrange),
                  child: FlatButton(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      if (_connectionStatus != 'ConnectivityResult.none') {
                        if (email.isNotEmpty && password.isNotEmpty) {
                          final overlay = LoadingOverlay.of(context);
                          final response = await overlay
                              .during(Auth.validateMerchant(email, password));

                          print(
                              'response login----------------------------------------$response');





                          Static.FirstTime = "1";

                          if (response != 'failed') {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setInt('logged', 1);
                            Api.businessBaseUrl =
                                'https://$response/api/Merchant/';
                            await prefs.setString('domain', response);
                            await prefs.setString('password', password);
                            await prefs.setString('BusinessName', BusinessName);

                            SharedPreferences.getInstance().then((prefs) {
                              // domain = prefs.getString('domain') ?? '-1';

                              Static.Domain = prefs.getString('domain') ?? '-1';
                              String domain = Static.Domain;

                              if (domain != '-1') {
                                Api.businessBaseUrl =
                                    'https://$domain/api/Merchant/';
                                Api.LAST_HIT_URL = 'https://$domain/';
                                Api.BusinessUrl = 'www.$domain';

                                // methodChannel.invokeMethod('update_app');
                              }
                            });

                            // if(isFirstTime!=0){
                            //   setIsFirstTime();
                            //   Navigator.pushReplacement(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (_) => PrinterCredential()));
                            // }
                            // else{

                            // setIsFirstTime();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => PrinterCredential()));
                            // }

                          } else {
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                content: Text(
                                    'Something went wrong! Please try again.')));
                          }
                        } else {
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                              content: Text('Email and password required')));
                        }
                      } else {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content:
                                Text('Please Check your internet connection')));
                        // }
                        // Get.snackbar("Internet Alert!", "Please Check your internet connection",duration: Duration(seconds: 5),);
                      }
                    },
                  ),
                )),

          // Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 32,vertical: 10),
          //     child: Container(
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(Radius.circular(100)),
          //           color: Colors.green),
          //       child: FlatButton(
          //         child: Text(
          //           "Update",
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontWeight: FontWeight.w700,
          //               fontSize: 18),
          //         ),
          //         onPressed: () async {
          //           FocusScope.of(context).requestFocus(FocusNode());
          //
          //             final overlay = LoadingOverlay.of(context);
          //             final response = await overlay
          //                 .during(Auth.updateApp());
          //             print(
          //                 'response Update----------------------------------------$response');
          //
          //
          //             if(response=="updated"){
          //
          //             }
          //             else{
          //               if(response=="no"){
          //
          //                 _scaffoldKey.currentState.showSnackBar(new SnackBar(
          //                     content: Text(
          //                         'no')));
          //
          //               }
          //             }
          //
          //         },
          //       ),
          //     )),

          // Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 32,vertical: 10),
          //     child: Container(
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(Radius.circular(100)),
          //           color: Colors.deepOrange),
          //       child: FlatButton(
          //         child: Text(
          //           "Update App",
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontWeight: FontWeight.w700,
          //               fontSize: 18),
          //         ),
          //         onPressed: () async {
          //
          //           Navigator.pushReplacement(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (_) => MyAppUpdate()));
          //
          //               })))
          //
        ],
      ),
    );
  }

  void setIsFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('isFirst'+'${Api.businessBaseUrl}', 2);
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
