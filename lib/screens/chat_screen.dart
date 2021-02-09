import 'dart:async';
import 'dart:convert';
import 'package:flash_chat/components/chat_messages_widget.dart';
import 'package:flash_chat/components/dialog_box.dart';
import 'package:flash_chat/components/send_message.dart';
import 'package:flash_chat/components/snackBarLookAlike.dart';
import 'package:flash_chat/functionality/socket_initialization.dart';
import 'package:flash_chat/screens/auth_screen.dart';
import 'file:///D:/Projects/Flutter-Course-Resources-master/farghaly_chat/flash-chat-flutter/lib/functionality/join_room_loading.dart';
import 'package:flash_chat/screens/not_found.dart';
import 'package:flash_chat/screens/rooms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/services.dart';


class ChatScreen extends StatefulWidget {
  static const id = 'chatScreen';
  ChatScreen({this.room, this.role, this.name});
  final String room;
  final String role;
  final String name;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  LocalStorage storage = new LocalStorage('auth');
  SocketIO socket;
  String _roomOwner;
  bool _showSnackBar = false;
  String _snackBarMessage = '';
  bool _userAuthorized = false;
  int _numberOfJoiners = 0;
  Color _snackBarColor;
  String _name = '';

  void gotoErrorPage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
          return NotFound(
            text: 'You are not allowed to this room or there is no room',
            onPressed: () {
              Navigator.pushReplacementNamed(context, RoomsScreen.id);
            },
          );
        })
    );
  }

  @override
  void initState() {
    if(storage.getItem('userData') == null) {
      Navigator.pushReplacementNamed(context, AuthScreen.id);
    }
    socket = SocketInitialization.socket;
    initiateSocket();
    _getRoomOwner();
    super.initState();
  }



  void initiateSocket() async{
    try {
      imageCache.clearLiveImages();
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      JoinRoom joinRoom = JoinRoom(room: widget.room, name: widget.name, role: widget.role);
      bool joined = await joinRoom.checkUserAuthority();
      if(!joined) {
        gotoErrorPage();
        return;
      }
      joinRoom.joinSocketRoom();
      print('joining new user');
      socket.subscribe('newUser', (data) async{
        setState(() {
          _showSnackBar = false;
        });
        print('newUser event arrived..');
        if(json.decode(data)['joined']) {
          new Timer(Duration(milliseconds: 300), () {
            setState(() {
              _snackBarMessage = json.decode(data)['message'];
              _showSnackBar = true;
              _snackBarColor = Colors.green[800];
              _numberOfJoiners = json.decode(data)['joiners'];
              _userAuthorized = true;
            });
          });
          // setState(() {});
        } else {
          gotoErrorPage();
        }
      });

      socket.subscribe('leftRoom', (data) {
        print('left room');
        var res = json.decode(data);
        setState(() {
          _showSnackBar = false;
        });
        new Timer(Duration(milliseconds: 300), () {
          setState(() {
            _snackBarMessage = res['message'];
            _showSnackBar = true;
            _snackBarColor = Colors.deepOrange;
            _numberOfJoiners = res['joiners'];
          });
        });
      });

    } catch(e) {
      print(e);
    }
  }


  void _getRoomOwner() async{
    Response roomData = await post(
        '$KUrl/getRoomData',
        headers: {'Content-type': 'application/json'},
        body: json.encode({'room': widget.room})
        );
    _roomOwner = json.decode(roomData.body)['roomData']['owner'];
    if(widget.name == null) {
      _name = json.decode(roomData.body)['roomData']['name'];
    }
  }

  _deleteRoom(ctx) async{
    ConfirmBox confirm = ConfirmBox(context: ctx);
    bool del = await confirm.showMyDialog();
    if(!del) return;
    Response delRoom = await post(
      '$KUrl/deleteRoom',
      headers: {'Content-type': 'application/json'},
      body: json.encode({'room': widget.room, 'userId': storage.getItem('userData')['_id']})
    );
    bool deleted = json.decode(delRoom.body)['deleted'];
    print(json.decode(delRoom.body));
    print(deleted);
    if(deleted) {
      Navigator.pushReplacementNamed(context, RoomsScreen.id);
    } else {
      String error = json.decode(delRoom.body)['error'];
      print(error);
    }
  }

  void didChangeAppLifeCycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) {
      SocketInitialization socketInit = SocketInitialization();
      socketInit.initiateSocket();
    }
  }

  @override
  void dispose() {
    socket.sendMessage('leaveRoom', json.encode({'room': widget.room, 'username': storage.getItem('userData')['username']}));
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
        title: Text('${widget.name != null? widget.name: _name}'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        Text('Logout', style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                  value: 'logout',
                ),
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.time_to_leave),
                        Text('Leave chat', style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                  value: 'leave',
                ),

                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.supervised_user_circle),
                        Text('update information', style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                  value: 'updateUser',
                ),
                if(_roomOwner == storage.getItem('userData')['_id'])

                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.delete_forever),
                        Text('Delete chat', style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                  value: 'delete',
                )
              ],
              onChanged: (val) {
                if(val == 'logout') {
                  storage.deleteItem('userData');
                  Navigator.pushReplacementNamed(context, AuthScreen.id);
                } else if(val == 'leave') {
                  Navigator.pushReplacementNamed(context, RoomsScreen.id);
                } else if(val == 'delete') {
                  _deleteRoom(context);
                } else if(val == 'updateUser') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen(func: 'update')));
                }
              }),
        ],
      ),
      body: Builder(
        builder: (context) {
          return  SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.grey.withOpacity(.3), BlendMode.srcOver),
                  image: AssetImage('images/background.png'),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.name != null? widget.name: _name, style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: MediaQuery.of(context).size.width > KSmallScreenSize?37: 23,
                            fontWeight: FontWeight.bold

                        )),
                        Text('('+_numberOfJoiners.toString()+')', style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: MediaQuery.of(context).size.width > KSmallScreenSize?37: 23,
                            fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  if(_userAuthorized)
                    Expanded(
                      child: ChatMessages(room: widget.room),
                    )
                  else
                    Expanded(
                      child: Center(
                          child: CircularProgressIndicator()
                      ),
                    ),
                  if(_showSnackBar)
                    SnackBarLookAlike(message: _snackBarMessage, color: _snackBarColor,),
                  //
                  SendMessage(room: widget.room),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
