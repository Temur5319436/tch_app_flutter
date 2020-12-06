import 'package:flutter/material.dart';

class PasswordButtons extends StatefulWidget {
  var setPassword;
  var getItem;
  var buttonSize;

  PasswordButtons({Key key, this.getItem, this.buttonSize, this.setPassword})
      : super(key: key);

  @override
  PasswordButtonsState createState() => PasswordButtonsState();
}

class PasswordButtonsState extends State<PasswordButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFloatActionButton(1, widget.buttonSize),
            _buildFloatActionButton(2, widget.buttonSize),
            _buildFloatActionButton(3, widget.buttonSize),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFloatActionButton(4, widget.buttonSize),
            _buildFloatActionButton(5, widget.buttonSize),
            _buildFloatActionButton(6, widget.buttonSize),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFloatActionButton(7, widget.buttonSize),
            _buildFloatActionButton(8, widget.buttonSize),
            _buildFloatActionButton(9, widget.buttonSize),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFloatActionButton(-2, widget.buttonSize),
            _buildFloatActionButton(0, widget.buttonSize),
            _buildFloatActionButton(-1, widget.buttonSize),
          ],
        ),
      ],
    );
  }

  _buildFloatActionButton(int n, double size) {
    return InkWell(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      onTap: () {
        widget.setPassword(n);
      },
      splashColor: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: new BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: size,
          width: size,
          child: Center(child: widget.getItem(n)),
        ),
      ),
    );
  }
}
