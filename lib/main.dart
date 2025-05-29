import 'package:flutter/material.dart';
import 'package:insta_clone/constants/material_white.dart';
import 'package:insta_clone/home_page.dart';
import 'package:insta_clone/screens/auth_screen.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: AuthScreen(),
      home: Homepage(),
      theme: ThemeData(primarySwatch: white),
    );
  }
}

