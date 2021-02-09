import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  static String id = 'notFoundScreen';
  final String text;
 final  Function onPressed;
  NotFound({this.text, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        title: Text('Not Found'),
        actions: [
          IconButton(
            icon: Icon(Icons.assignment_return),
            iconSize: 30,
            onPressed: onPressed,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            height: 300,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 30,
                  padding: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(17),
                    ),
                  ),
                  child: Text('Error',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                // SizedBox(height: 30),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.w700
                        ),
                      ),
                      SizedBox(height: 30),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                        onPressed: onPressed,
                        textColor: Colors.white,
                        color: Colors.red,
                        child: Text('back', style: TextStyle(fontSize: 22)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
