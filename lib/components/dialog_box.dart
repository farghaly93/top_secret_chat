import 'package:flutter/material.dart';

class ConfirmBox  {
  ConfirmBox({this.context});
  BuildContext context;
  // String messageId;
  Future<bool> showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('confirm to proceed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You need to confirm this action'),
                Text('Would you like to approve this action?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }
}
