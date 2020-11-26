import 'package:flutter/material.dart';

class SnackBarShow {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  snackBarShow(String message, [String label = 'OK']) {
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 14),
      ),
      action: SnackBarAction(
        label: label,
        onPressed: () {},
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getScaffoldKey() {
    return _scaffoldKey;
  }
}
