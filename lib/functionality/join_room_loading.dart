import 'dart:async';
import 'dart:convert';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/functionality/socket_initialization.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:http/http.dart' as http;

class JoinRoom {
  JoinRoom({this.room, this.name, this.role});
  final String room;
  final String name;
  final role;
  bool joined = false;
  SocketIO socket;


  void joinSocketRoom() {
      print('send join socket event');
      socket = SocketInitialization.socket;
      socket.init();
      socket.connect();
      new Timer(Duration(milliseconds: 500), () {
        socket.sendMessage('join',
          json.encode({
            'username': storage.getItem('userData')['username'],
            'room': room
          }),
        );
      });
  }

  Future<bool> checkUserAuthority() async{
      String userId = storage.getItem('userData')['_id'];
      Map<String, dynamic> body = {
        'userId': userId,
        'room': room,
        'name': name
      };
      var json = jsonEncode(body);
      String nameSpace = role=='owner'?'createRoom': 'joinRoom';
      print(nameSpace);
      http.Response record = await http.post(
          '$KUrl/$nameSpace',
          headers: {'Content-Type': 'application/json'},
          body: json
      );
      bool isDone = jsonDecode(record.body)['added'];

      if(isDone) {
        joined = true;
      } else {
        joined = false;
      }
    return joined;
  }










// Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// if(error != null)
// Container(
// child: Column(
// children: [
// Text(
// error,
// textAlign: TextAlign.center,
// style: KErrorText,
// ),
// ],
// ),
// ),
// Container(
// child: ModalProgressHUD(
// child: Container(),
// inAsyncCall: joining,
// color: Colors.purple,
// progressIndicator: CircularProgressIndicator(),
// ),
// ),
// ],
// ),




}
// @override
// void initState() {
//   print(widget.name);
//   super.initState();
//   joinToChatRoom();
//   // Navigator.pushNamed(context, ChatScreen.id);
// }
// @override
// void dispose() {
//   // socket.disconnect();
//   super.dispose();
// }
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Joining functionality'),
//     ),
//     body: SafeArea(
//       child: Center(child: Text(
//         'Loading..',
//         style: TextStyle(
//             fontSize: 37,
//             fontWeight: FontWeight.bold
//         ),
//       )),
//     ),
//   );
// }