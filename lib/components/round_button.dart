import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  RoundButton({this.color, this.label, @required this.onPressed, this.width, this.height, this.labelColor, this.fontSize});
  final Color color;
  final String label;
  final Function onPressed;
  final double width;
  final double height;
  final Color labelColor;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: width,
          height: height,
          child: Text(
            label,
            style: TextStyle(color: labelColor, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}