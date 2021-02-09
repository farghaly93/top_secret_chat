import 'dart:convert';
import 'package:flash_chat/components/rooms_screen_responsive/big_screen.dart';
import 'package:flash_chat/components/rooms_screen_responsive/small_screen.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/auth_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
// import 'file:///D:/Projects/Flutter-Course-Resources-master/farghaly_chat/flash-chat-flutter/lib/screens/join_room_loading.dart';
import 'package:flash_chat/screens/createRoom_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RoomsScreen extends StatefulWidget {
  static const id = 'roomsScreen';
  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  bool loading = false;
  String secretKey;
  List _rooms = [];
  void _getRooms() async{
    loading = true;
    http.Response data = await http.get('$KUrl/getRoomsForUser/${storage.getItem('userData')['_id']}');
    loading = false;
    var rooms = json.decode(data.body);
    setState(() {
      _rooms = rooms['rooms'];
    });
  }

  @override
  void initState() {
    _getRooms();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Choose room or create one'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () {
            storage.deleteItem('userData');
            Navigator.pushReplacementNamed(context, AuthScreen.id);
          }),
          IconButton(icon: Icon(Icons.supervised_user_circle_outlined), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen(func: 'update')));
          }),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.pink.withOpacity(.6), BlendMode.srcOver),
            image: AssetImage('images/background.png'),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: RoomsSmallScreen(
                secretKey: secretKey,
                getRooms: _getRooms,
                rooms: _rooms,
                loading: loading,
            ),
          ),
        ),
      ),
    );
  }
}
