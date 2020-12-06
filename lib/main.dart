import 'package:flutter/material.dart';
import 'package:flutter_apps/pages/password/password_page.dart';

void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCH',
      debugShowCheckedModeBanner: false,
      home: Password(),
    );
  }
}
