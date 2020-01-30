import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/pages/home.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        accentColor: Colors.teal,
        primarySwatch: Colors.teal,
      ),
      title: 'GetOutfit Stylist',
    );
  }
}
