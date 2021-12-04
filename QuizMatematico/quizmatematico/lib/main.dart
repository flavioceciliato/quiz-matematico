import 'package:flutter/material.dart';
import 'package:quizmatematico/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz  Matemático',
      theme: ThemeData(
        primaryColor: Color(0xFF55C1EF),
      ),
      home: Home(),
    );
  }
}
