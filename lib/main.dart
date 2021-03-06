import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        accentColor: Colors.teal[600],
        primarySwatch: Colors.teal,
      ),
      title: 'Get Outfit',
    );
  }
}
