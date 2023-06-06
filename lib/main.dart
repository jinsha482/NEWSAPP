// @dart=2.9
import 'package:flutter/material.dart';
import 'package:newsapp/dashboard.dart';
import 'package:newsapp/homescreen.dart';
import 'package:splashscreen/splashscreen.dart';




void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  

  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:SplashScreen(title:Text('News App',style: TextStyle(color:Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),seconds: 10,backgroundColor: Colors.green.shade200,navigateAfterSeconds: NewsScreen(),
    useLoader: true,loaderColor: Colors.white,));
  }
}

