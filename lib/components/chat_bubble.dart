import 'dart:convert';
import 'package:flash_chat/components/AudioPlayerWidget.dart';
import 'package:flash_chat/components/dialog_box.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/functionality/socket_initialization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:http/http.dart' as http;
import 'package:flash_chat/components/usernameAndImage.dart';
import 'package:flash_chat/functionality/fetchUserDataById.dart';

class SmallScreenMessageBubble extends StatefulWidget {

  SmallScreenMessageBubble({this.room, this.type, this.text, this.isMe, this.key, this.userId, this.date, this.messageId});
  final String text;
  final String room;
  final bool isMe;
  final userId;
  final String date;
  final messageId;
  final Key key;
  final type;

  @override
  _SmallScreenMessageBubbleState createState() => _SmallScreenMessageBubbleState();
}

class _SmallScreenMessageBubbleState extends State<SmallScreenMessageBubble> {
  SocketIO socket = SocketInitialization.socket;
  bool _messageDeleted = false;
  String _imagePath;
  String _username;
  _deleteMessage(ctx) async{
    print('DELETE>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    ConfirmBox confirm = ConfirmBox(context: ctx);
    bool answer = await confirm.showMyDialog();
    if(answer) {
      String userId = storage.getItem('userData')['_id'];
      final body = {'userId': userId, '_id': widget.messageId, 'room': widget.room};
      final jsonBody = json.encode(body);
      print(jsonBody);
      http.Response res = await http.post(
          KUrl + '/deleteMessage',
          body: jsonBody,
          headers: {
            'Content-Type': 'application/json'
          }
      ).catchError((e) {
        print(e);
      });
      final data = json.decode(res.body);
      print(data['deleted']);
      if (data['deleted']) {
        socket.sendMessage('deleteMessageForAll', json.encode({'messageId': widget.messageId, 'room': widget.room}));
      }
    }
  }
  @override
  void initState() {
    if(widget.text == null) _messageDeleted = true;
    socket.subscribe('deleteMessage', (id) {
      setState(() {
        if(widget.messageId == id) {
          setState(() {
            _messageDeleted = true;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      overflow: Overflow.visible,
      children: [
        Row(
          mainAxisAlignment: widget.isMe? MainAxisAlignment.end: MainAxisAlignment.start,
          children: [
            if(!_messageDeleted)
            Container(
              width: width > KSmallScreenSize? width* .6: width*.8,
              padding: EdgeInsets.fromLTRB(widget.isMe?1:6,13, widget.isMe?6: 1, 10),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 34),
              decoration: BoxDecoration(
                color: widget.type=='photo' || widget.type=='record'? null: widget.isMe? Colors.blueAccent: Colors.grey[400],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: widget.isMe? Radius.circular(3) : Radius.circular(30),
                  bottomRight: !widget.isMe? Radius.circular(3) : Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(widget.isMe)
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {_deleteMessage(context);},
                    color: widget.type=='photo' || widget.type=='record'?Colors.grey[800] : Colors.white54,
                  ),
                  Expanded(
                    child: Container(
                      margin: widget.isMe? EdgeInsets.only(right: 30): EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: widget.isMe? CrossAxisAlignment.end: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if(widget.type == 'text')
                            Text(widget.text, style: TextStyle(
                              color: widget.isMe? Colors.white : Colors.black,
                              fontSize: width>KSmallScreenSize? 18: 14,
                              fontWeight: FontWeight.w400,
                              // fontFamily: 'MontserratAlternates'
                              )
                            )
                          else if(widget.type == 'record')
                            AudioPlayerWidget(color: widget.isMe?Colors.blue[600]: Colors.green, record: widget.text)
                          else if(widget.type == 'photo')
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                widget.text,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null)
                                    return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),

                          SizedBox(height: 4),
                          Text(
                            KFormatDate(widget.date),
                            style: TextStyle(
                            color: widget.type=='photo' || widget.type=='record'?Colors.grey[800] : widget.isMe? Colors.white : Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
            else
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 34),
              padding: widget.isMe? EdgeInsets.only(right: 70): EdgeInsets.only(left: 70),
              child: Text('Message deleted', style: TextStyle(fontSize: width > KSmallScreenSize? 30: 23, color: Colors.black54),
            ),
          ),
        ],
      ),

      Positioned(
        left: !widget.isMe? 15: null,
        right: widget.isMe? 15: null,
        top: -10,
        child: UsernameAndImage(isMe: widget.isMe, type: widget.type, userId: widget.userId,),
        ),
      ]
    );
  }
}

