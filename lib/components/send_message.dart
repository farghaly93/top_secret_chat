import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flash_chat/components/emojis.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/functionality/pick_image.dart';
import 'package:flash_chat/functionality/socket_initialization.dart';
import 'package:flash_chat/functionality/uploadFileToStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:path_provider/path_provider.dart';

class SendMessage extends StatefulWidget {
  SendMessage({this.room});
  final String room;

  @override
  _SendMessageState createState() => _SendMessageState();
}

class LocalFileSystem {
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController _controller = TextEditingController();
  bool _showEmojiPicker = false;
  String message = '';
  SocketIO socket;
  PickedFile image;
  var record;
  String typeOfMessage;
  bool hasPermission;
  bool _imageLoading = false;
  int time = 0;
  String timer = '00:00';
  bool recording = false;
  AudioPlayer audioPlayer = AudioPlayer();
  Random random = Random.secure();
  bool playing = false;


  FlutterAudioRecorder recorder;
  var current;

  @override
  void initState() {
    socket = SocketInitialization.socket;
    initAudioRecorder();
    super.initState();
  }

  void _pickImage(pickedImage) async{
    setState(() {
      _showEmojiPicker = false;
      image = pickedImage;
    });
  }

  void printEmoji(val) {
    setState(() {
      message = '$message $val';
      _controller.text = message;
      typeOfMessage = 'text';
    });
  }

  void _sendMessage() async {
    try{

      if(image != null) {
        setState(() {
          _imageLoading = true;
        });
        UploadImageToStorage uploadImage = UploadImageToStorage(file: image);
        String url = await uploadImage.uploadAndGetUrl();
        message = url;
        typeOfMessage = 'photo';
      }
      if(record != null) {
        setState(() {
          _imageLoading = true;
        });
        UploadImageToStorage uploadImage = UploadImageToStorage(audio: record);
        String url = await uploadImage.uploadAndGetUrl();
        message = url;
        print(url);
        typeOfMessage = 'record';
      }
      if(message.trim().isEmpty) {
        return;
      }
      socket.sendMessage('send', jsonEncode({
        'message': message,
        'userId': storage.getItem('userData')['_id'],
        'room': widget.room,
        'type': typeOfMessage
        // 'date': Timestamp.now()
      }));
      // socket.write(_message);
      _controller.clear();
      setState(() {
        message = '';
        image = null;
        record = null;
        _imageLoading = false;
      });
    }catch(e) {
      print(e);
    }
  }

void initAudioRecorder() async{
  Directory directory = await getTemporaryDirectory();
  String path = directory.path;
  print(path);
  recorder = FlutterAudioRecorder("$path/recording${random.nextInt(100000)}.m4a"); // .wav .aac .m4a
  audioPlayer.onPlayerCompletion.listen((event) {
    setState(() {
      playing = false;
    });
  });
  await recorder.initialized;
}

void _startRecording() async{
  setState(() {
    _showEmojiPicker = false;
  });
  recording = true;
  if(!await FlutterAudioRecorder.hasPermissions) return;
  await recorder.start();
  int milliseconds = 0;
  new Timer.periodic(Duration(milliseconds: 100), (Timer t) {

    milliseconds++;
    // print(milliseconds);
    if(milliseconds == 99) milliseconds = 0;
    setState(() {
      time++;
      timer = new DateTime.fromMillisecondsSinceEpoch(time*100).second.toString() + ': 00';
    });
    if (!recording || time == 600) {
      _stopRecording();
      t.cancel();
    }
  });

}

void _stopRecording() async{
  recording = false;
  setState(() {
    timer = '00:00';
    time = 0;
  });
  var result = await recorder.stop();
  File file = File(result.path);
  record = file;
  // initAudioRecorder();
}
@override
void dispose() {
    super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return //Stack(
        // overflow: Overflow.visible,
        // children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if(image != null)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close_rounded, size: 35, color: Colors.black,),
                            onPressed: () {
                              setState(() {
                                image = null;
                              });
                            }
                          ),
                          Image.file(File(image.path),),
                        ],
                      ),
                    ),
                    if(_imageLoading)
                      Positioned(
                        left: 400,
                        top: 120,
                        child: CircularProgressIndicator(backgroundColor: Colors.blue,),
                      ),
                  ],
                )
              else if(recording)
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(timer.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30
                        ),
                      ),
                    ),
                  ),
                )
                else if(record != null)
                  Container(
                    color: Colors.black87.withOpacity(.5),
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(icon: Icon(playing?Icons.pause:Icons.play_arrow, size: 35, color: Colors.white), onPressed: () async{
                          if(!playing) {
                            await audioPlayer.play(record.path);
                          } else {
                            await audioPlayer.pause();
                          }
                          setState(() {
                            playing = !playing;
                          });
                        },),
                        if(_imageLoading)
                          Expanded(child: Center(child: CircularProgressIndicator()))
                        else
                          Expanded(child: SizedBox()),
                        IconButton(icon: Icon(Icons.close_rounded, size: 26, color: Colors.white), onPressed: () async{
                          setState(() {
                            record = null;
                          });
                        },),
                      ],
                    ),
                  )
              else
              TextField(
                decoration: InputDecoration(
                    fillColor: Colors.white54,
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                        color: Colors.black38
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide.none,
                    )
                ),
                onChanged: (val) {
                  message = val;
                  _showEmojiPicker = false;
                  typeOfMessage = 'text';
                },
                onTap: () {
                  setState(() {
                    _showEmojiPicker = false;
                  });
                },
                controller: _controller,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  PickImage(
                    screen: 'chat',
                    icon: Icons.camera_alt,
                    imageSource: ImageSource.camera,
                    pickImageFunction: _pickImage,
                  ),
                  PickImage(
                    screen: 'chat',
                    icon: Icons.photo_album,
                    imageSource: ImageSource.gallery,
                    pickImageFunction: _pickImage,
                  ),
                  GestureDetector(
                    child: Icon(
                        Icons.mic,
                        size: 35,
                        color: Theme.of(context).backgroundColor,
                    ),
                    onLongPress: _startRecording,
                    onLongPressUp: _stopRecording,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Theme.of(context).backgroundColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _showEmojiPicker = !_showEmojiPicker;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).backgroundColor,
                    ),
                    onPressed: () {
                      _sendMessage();
                      _showEmojiPicker = false;
                    },
                  ),
                ],
              ),
            // ],
          // ),
          if(_showEmojiPicker)
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.grey[350],
            padding: EdgeInsets.all(5),
            child: Emojis(printEmoji: printEmoji),
          ),
       ],
    );
  }
}


