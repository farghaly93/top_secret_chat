import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

// const KUrl = 'http://192.168.1.5:6969';
const KUrl = 'https://farghaly-chat-socket-server.herokuapp.com';
const KTitleTextStyle = TextStyle(
    color: Colors.pink,
    fontSize: 22,
    fontWeight: FontWeight.w600
);
const KBigScreenSize = 800;
const KSmallScreenSize = 400;

Function KFormatDate = (date) {
  DateFormat formatter = DateFormat.yMMMMEEEEd().add_jm();
  final formatted = formatter.format(DateTime.fromMicrosecondsSinceEpoch(int.parse(date)*1000));
  return formatted;
};

LocalStorage storage = new LocalStorage('auth');

const KTextFieldDecoration = InputDecoration(
  fillColor: Colors.white70,
  filled: true,
  hintText: 'Enter your password',
  hintStyle: TextStyle(
    color: Colors.black38,
        fontSize: 12
  ),
  contentPadding:
  EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(22.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(22.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(22.0)),
  ),
);


const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const KErrorText = TextStyle(
  color: Colors.red,
  fontSize: 28,
  fontWeight: FontWeight.w400,
  shadows: [
    Shadow(color: Colors.white54, blurRadius: 3),
    Shadow(color: Colors.white54, blurRadius: 2),
    Shadow(color: Colors.white54, blurRadius: 2)]
);