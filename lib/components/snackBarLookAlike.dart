import 'dart:async';

import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class SnackBarLookAlike extends StatefulWidget {
  final String message;
  final Color color;
  SnackBarLookAlike({this.message, this.color});

  @override
  _SnackBarLookAlikeState createState() => _SnackBarLookAlikeState();
}

class _SnackBarLookAlikeState extends State<SnackBarLookAlike> with SingleTickerProviderStateMixin {
  AnimationController controller;
  // Animation animation;
  @override
  void initState() {
    print('Here is snackbar widget');
    controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
      upperBound: 1
    );
    // animation = CurvedAnimation(parent: controller, curve: Curves.);
    controller.forward();
    controller.addListener(() {
      if(controller.value == 1) {
        new Timer( Duration(seconds: 4), () {
          setState(() {
            print(controller.value);
            controller.reverse();
          });
        });
      }
      setState(() {});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
          width: double.infinity,
          height: 50 * controller.value,
          padding: EdgeInsets.all(10),
          color: widget.color,
          child: Text(
            widget.message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: width > KSmallScreenSize?25: 16,
              fontWeight: FontWeight.w600
            ),
          ),
        );
  }
}