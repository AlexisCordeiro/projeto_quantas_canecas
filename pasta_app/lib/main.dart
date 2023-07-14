import 'package:flutter/material.dart';
import 'package:pasta_app/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quantas canecas?'),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: QuantasCanecasApp(),
      ),
    );
  }
}
