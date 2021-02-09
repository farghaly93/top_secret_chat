import 'dart:convert';
import 'dart:math';

import 'package:flash_chat/components/round_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateRoom extends StatefulWidget {
  static String id = 'createRoom';

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  String name;
  final TextEditingController _inputController = TextEditingController();

  String secretKey;

  void _generateRandomKey() {
    Random random = Random.secure();
    var bytes = List<int>.generate(32, (i) => random.nextInt(256));
    final encoded =  base64.encode(bytes);
    secretKey = encoded;
    _inputController.text = encoded;
  }

  void initState() {
    _generateRandomKey();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Create new room'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.pink.withOpacity(.3), BlendMode.srcOver),
            image: AssetImage('images/background.png'),
          ),
        ),
        child: Center(
          child: Card(
            elevation: 5,
            color: Colors.white,
            margin: EdgeInsets.all(14),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('your new room secret key',
                      textAlign: TextAlign.center,
                      style: KTitleTextStyle.copyWith(
                        color: Colors.black87,
                        fontSize: width > KSmallScreenSize?25: 17
                      ),
                    ),
                    Text('Give this secret key to people you want them to join',
                      textAlign: TextAlign.center,
                      style: KTitleTextStyle.copyWith(
                        color: Colors.grey,
                        fontSize: width > KSmallScreenSize? 22: 12
                      )
                    ),
                    SizedBox(height: 60),
                    Text('Room name',
                        style: KTitleTextStyle.copyWith(
                        fontSize: width > KSmallScreenSize? 22: 12
                    )),
                    TextField(
                      decoration: KTextFieldDecoration.copyWith(
                        hintText: 'Room name'
                      ),
                      onChanged: (val) {
                        name = val;
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: width > KSmallScreenSize?22: 12
                      ),
                    ),
                    SizedBox(height: 60),
                    Text('Room key', style: KTitleTextStyle.copyWith(
                        fontSize: width > KSmallScreenSize? 22: 12
                    )),
                    TextField(
                      controller: _inputController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: width > KSmallScreenSize?30: 15
                      ),
                    ),
                    FlatButton(
                      onPressed: _generateRandomKey,
                      child: Text(
                        'Regenerate key',
                        style: TextStyle(color: Colors.pink, fontSize: MediaQuery.of(context).size.width > KSmallScreenSize?25: 16),
                      ),
                    ),
                    RoundButton(
                      color: Colors.pink,
                      labelColor: Colors.white,
                      width: MediaQuery.of(context).size.width > KSmallScreenSize? 380: 220,
                      height: MediaQuery.of(context).size.width > KSmallScreenSize? 100: 50,
                      label: 'Start room now',
                      fontSize: MediaQuery.of(context).size.width > KSmallScreenSize? 33: 22,
                      onPressed: () {
                        if(secretKey != null && name != null)
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(room: secretKey, name: name, role: 'owner')));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
