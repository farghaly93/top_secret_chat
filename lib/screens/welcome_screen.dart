import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/round_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/auth_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/rooms_screen.dart';
import 'package:flash_chat/screens/createRoom_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  Animation animation2;
  @override

  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
      upperBound: 1
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    animation2 = CurvedAnimation(parent: controller, curve: Curves.easeInBack);
    //animation = ColorTween(begin: Colors.grey , end: Colors.white).animate(controller);
    controller.forward();
    controller.repeat(min: .7, max: 1, reverse: true, period: Duration(milliseconds: 4500));

    controller.addListener(() {
      setState(() {});
       // print(animation.value);
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Top secret chat'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.grey.withOpacity(.6), BlendMode.srcOver),
            image: AssetImage('images/background.jpg'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: SizedBox(height: 20)),
            Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(160),
                    child: Image.asset('images/logo.png',
                      width: width > KSmallScreenSize? 300*animation.value: 150*animation.value,
                      height: width > KSmallScreenSize? 300*animation.value: 150*animation.value,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    color: Colors.grey.withOpacity(.7),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                    child: Column(
                      children: [
                        TypewriterAnimatedTextKit(
                          speed: Duration(milliseconds: 150),
                          text: ['Top secret chat...'],
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Courgette',
                            fontSize: width > KSmallScreenSize?60: 30,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          'Only authorized users you let them allowed to join your chat room,'
                              'your messages are completely protected all messages are deleted for all users and the database when the room owner drops the room,'
                              'any message you delete permanently removed for every one and database, no screen shots allowed, no images download allowed ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: width > KSmallScreenSize? 22: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Material(
                    color: Theme.of(context).backgroundColor,
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: MaterialButton(
                      minWidth: width > KSmallScreenSize? 300*controller.value: 200*controller.value,
                      height: width > KSmallScreenSize?80*controller.value: 50*controller.value,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      // color: Theme.of(context).buttonColor,
                      child: Text('Start', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),),
                      onPressed: () {
                        if(storage.getItem('userData') != null) {
                          Navigator.of(context).pushNamed(RoomsScreen.id);
                        } else {
                          Navigator.of(context).pushNamed(AuthScreen.id);
                        }
                      },
                    ),
                  ),
                ]),
            Expanded(
              child: Container(
                child: FlatButton(
                  onPressed: () async{
                    // if(await storage.getItem('itemData') != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChatScreen(
                            room: 'g0hSVbaEr0vo2NmcTlSyFpnVcmLCDdiJYEa/EjGbUXU=',
                            role: 'guest',
                          ),
                        ),
                        // (Route<dynamic> route) => false
                      );
                    // } else {
                    //   Navigator.pushNamed(context, AuthScreen.id);
                    // }
                  },
                  child: Text('The Lobby',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                      fontSize: width > KSmallScreenSize?32: 22,
                        shadows: [
                          Shadow( // bottomLeft
                              offset: Offset(-1.5, -1.5),
                              color: Colors.grey[700]
                          ),
                          Shadow( // bottomRight
                              offset: Offset(1.5, -1.5),
                              color: Colors.grey[700]
                          ),
                          Shadow( // topRight
                              offset: Offset(1.5, 1.5),
                              color: Colors.grey[700]
                          ),
                          Shadow( // topLeft
                              offset: Offset(-1.5, 1.5),
                              color: Colors.grey[700]
                          ),
                        ]
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
