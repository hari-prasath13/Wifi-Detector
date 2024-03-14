import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Wifi Detector")),
        ),
        body: dingding(),
      ),
    );
  }
}

class dingding extends StatefulWidget {
  dingding({super.key});

  @override
  State<dingding> createState() => _dingdingState();
}
String? connectiontype;
StreamSubscription? subscription;

 Future<String> Connetedon()async{

   final connectivityResult = await (Connectivity().checkConnectivity());
   if (connectivityResult == ConnectivityResult.mobile) {
     return "Connected to mobile network";
   } else if (connectivityResult == ConnectivityResult.wifi) {
     return "Connected to wifi network";
   } else if (connectivityResult == ConnectivityResult.ethernet) {
     return "Connected to ethernet connection";
   } else if (connectivityResult == ConnectivityResult.vpn) {
     return "Connected to vpn";
     // Note for iOS and macOS:
     // There is no separate network interface type for [vpn].
     // It returns [other] on any device (also simulator)
   } else if (connectivityResult == ConnectivityResult.bluetooth) {
     return "Connected to bluetooth";
   } else if (connectivityResult == ConnectivityResult.other) {
     return "Connected to other network";
   } else if (connectivityResult == ConnectivityResult.none) {
     return "Not Connected";
   }

   return "Not Connected";
 }


class _dingdingState extends State<dingding> {

   bool? a;

  void _showSnackbar(BuildContext context,a) {

    if (a==false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('No Internet Connection!!')),
          duration: Duration(seconds: 5), // Adjust the duration as needed
        ),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('Internet Connected')),
          duration: Duration(seconds: 5), // Adjust the duration as needed
        ),
      );
    }
  }

   @override
   dispose() {
     subscription?.cancel();
     super.dispose();
   }

@override
initState() {
  super.initState();
  subscription = Connectivity().onConnectivityChanged
      .listen((ConnectivityResult result) {
    if(result == ConnectivityResult.mobile ||result == ConnectivityResult.wifi ){
      return _showSnackbar(context,true);
    }else{
      return _showSnackbar(context,false);
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text("CONECTIVITY TYPE: ${connectiontype ?? ""}",
                  style: TextStyle(
                    fontSize: 19,
                  )),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:(){setState(() {
                Connetedon().then((value) {
                  connectiontype = value;
              });
                });
              },
              child: Text("CHECK CONECTIVITY "),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan), // Change the color here
              ),
            )
          ],
        ),
      ),
    );
  }
}
