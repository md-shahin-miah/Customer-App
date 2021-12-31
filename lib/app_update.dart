// import 'dart:async';
// import 'dart:ffi';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:ota_update/ota_update.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
//
// /// example widget for ota_update plugin
// class MyAppUpdate extends StatefulWidget {
//   @override
//   _MyAppUpdateState createState() => _MyAppUpdateState();
// }
//
// class _MyAppUpdateState extends State<MyAppUpdate> {
//   OtaEvent currentEvent;
//
//   @override
//   void initState() {
//     super.initState();
//     tryOtaUpdate();
//   }
//
//   Future<void> tryOtaUpdate() async {
//     try {
//       //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
//       OtaUpdate()
//           .execute(
//         'https://internal1.4q.sk/flutter_hello_world.apk',
//         destinationFilename: 'flutter_hello_world.apk',
//         //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
//         sha256checksum:
//             'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478',
//       )
//           .listen(
//         (OtaEvent event) {
//           setState(() => currentEvent = event);
//         },
//       );
//       // ignore: avoid_catches_without_on_clauses
//     } catch (e) {
//       print('Failed to make OTA update. Details: $e');
//     }
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   if (currentEvent == null) {
//   //     return Container();
//   //   }
//   //   return MaterialApp(
//   //     home: Scaffold(
//   //       appBar: AppBar(
//   //         title: const Text('Plugin example app'),
//   //       ),
//   //       body: Center(
//   //         child: Text('OTA status: ${currentEvent.status} : ${currentEvent.value} \n'),
//   //       ),
//   //     ),
//   //   );
//   // }
//   String s;
//   double d=0.0;
//   String data="0.0";
//   String status="";
//   String percentage="";
//   @override
//   Widget build(BuildContext context) {
//     if(currentEvent==null){
//       data="1";
//       status="";
//     }
//     else{
//       status=currentEvent.status.toString();
//       data=currentEvent.value;
//       print('data-------$data');
//       if(data=="File not found"){
//         s="100";
//       }
//       else if(data=="installing"){
//
//       }
//       else if(data==""){
//         s="100";
//         data="100";
//       }
//       else{
//         s=data;
//       }
//
//       percentage=data=="File not found"? "":"%";
//       d=double.parse(s)/100;
//       d=double.parse(d.toStringAsFixed(1));
//       print('val---------------$d');
//       if(d==0.0){
//         d=0.1;
//       }
//
//     }
//
//     print('val---------------$d');
//     return Scaffold(
//       appBar: new AppBar(
//         title: new Text("Circular Percent Indicators"),
//       ),
//       body:    Container(
//         alignment: Alignment.center,
//         child: new CircularPercentIndicator(
//           radius: 120.0,
//           lineWidth: 13.0,
//           animation: true,
//           percent:d,
//           center: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: FittedBox(
//               fit: BoxFit.fill,
//               child: new Text(
//                 data+percentage,
//                 style:
//                 new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//               ),
//             ),
//           ),
//           footer: Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: FittedBox(
//               fit: BoxFit.fill,
//               child: new Text(
//                 'Downloading status: ${status} ',
//                 style:
//                 new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
//               ),
//             ),
//           ),
//           circularStrokeCap: CircularStrokeCap.butt,
//           progressColor: Colors.deepOrange,
//         ),
//       ),
//     );
//   }
// }
