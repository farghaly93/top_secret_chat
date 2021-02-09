import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'file:///D:/Projects/Flutter-Course-Resources-master/farghaly_chat/flash-chat-flutter/lib/components/chat_bubble.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/functionality/socket_initialization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatMessages extends StatefulWidget {
  ChatMessages({this.room});
  final String room;
  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  SocketIO socket;
  AudioCache audioPlayer = AudioCache();
  ScrollController _scrollController = ScrollController();
  bool _toBottom = true;
  int skip = 10;
  int limit = 10;
  List messages = [];
  bool loading = false;
  bool _noMoreMessages = false;
  double _currentMaxPositionPixels;

  _scrollToBottom() {
    if(_scrollController.hasClients)
      _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: Duration(milliseconds: 1000), curve: Curves.bounceIn);
  }

  _scrollToTop() {
    if(_scrollController.hasClients)
      _scrollController.jumpTo(_currentMaxPositionPixels);
  }


  void getMessages(start) async{
    print('get messages...');
    loading = true;
    Response messagesData = await post(
      '$KUrl/getAllMessages',
      headers: {'Content-type': 'application/json'},
      body: json.encode({'room': widget.room, 'skip': start?0: skip, 'limit': limit}),
    );
    setState(() {
      List incomingMessages = json.decode(messagesData.body)['messages'];
      print('number of incoming messages is ${incomingMessages.length}');
      setState(() {
        loading = false;
        if(incomingMessages.length < skip) _noMoreMessages = true;
        messages = [ ...messages, ...incomingMessages];
      });
    });
  }

  @override
  void initState() {
    getMessages(true);
    socket = SocketInitialization.socket;
    socket.subscribe('message', (res) {
      print('message event arrived');
      var data = json.decode(res);
      setState(() {
        _toBottom = true;
        messages.insert(0, data);
      });
      if(data['userId'] != storage.getItem('userData')['_id'])
        audioPlayer.play('new-message.mp3');
    });

    socket.subscribe('deleteMessage', (id) {
      int index = messages.indexWhere((el) => el['_id'] == id);
      print(messages[index]['userId'] == storage.getItem('userData')['_id']);
      messages.removeAt(index);
      messages.insert(index, {'text': null, 'userId': messages[index]['userId']});
    });

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {

          // if(skip <= messages.length) {
            print('list view top limit $skip ${messages.length}');
            _currentMaxPositionPixels = _scrollController.position.maxScrollExtent;
            setState(() {
              skip = skip + limit;
              _toBottom = false;
              getMessages(false);
            });
          // } else {
          //   _toBottom = false;
          // }
        }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _toBottom? _scrollToBottom(): _scrollToTop());
    return
      loading && messages.length < 1?
      Center(
        child: Container(
            height: 60,
            width: 60,
            child: CircularProgressIndicator()
        ),
      )
          :
      messages.length < 1?

      Center(
        child: Text(
          'No messages yet...',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: MediaQuery.of(context).size.width > KSmallScreenSize?40: 16
          ),
        ),
      )

          :

      ListView.builder(
          reverse: true,
          padding: EdgeInsets.only(top: 33),
          itemCount: !_noMoreMessages?messages.length + 1: messages.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if(index == messages.length && !_noMoreMessages) {
              return Center(child: CircularProgressIndicator(backgroundColor: Colors.black26,));
            }
            return Container(
              child:  SmallScreenMessageBubble(
                  room: widget.room,
                  text: messages[index]['message'],
                  isMe:  storage.getItem('userData')['_id']==messages[index]['userId'],
                  userId: messages[index]['userId'],
                  date: messages[index]['date'],
                  type: messages[index]['type'],
                  messageId: messages[index]['_id'],
                  // getMessageId: getMessageId,
                  key: ValueKey(messages[index]['_id'])
              ),
            );
          }
      );
  }
}
