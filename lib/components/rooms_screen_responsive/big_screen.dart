import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/createRoom_screen.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class RoomsBigScreen extends StatelessWidget {
  RoomsBigScreen({this.secretKey, this.rooms, this.getRooms, this.loading});
  String secretKey;
  final Function getRooms;
  final List rooms;
  bool loading;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 600,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.pink[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [



          Text('Enter the Room secret key',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: 37,
              fontWeight: FontWeight.w400,
            ),),
          SizedBox(height: 18),
          TextField(
            decoration: KTextFieldDecoration.copyWith(
              hintText: 'The room secret key',
            ),
            onChanged: (val) {
              secretKey = val;
            },
          ),




          SizedBox(height: 30),
          Row(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: [
              FlatButton(
                minWidth: 250,
                onPressed: () {
                  if(secretKey != null)
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatScreen(room: secretKey, role: 'guest')));
                },
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                color: Colors.green,
                child: Text('Join room', style: TextStyle(fontSize: 30),),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 21),
              SizedBox(height: 3, width: MediaQuery.of(context).size.width *.8, child: Container(color: Colors.pink[800]),),
              SizedBox(height: 60)
            ],
          ),




          FlatButton(
            minWidth: 250,
            onPressed: () {
              Navigator.of(context).pushNamed(CreateRoom.id);
            },
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            color: Colors.blueAccent,
            child: Text('Create room', style: TextStyle(fontSize: 30),),
          ),



          Column(
            children: [
              SizedBox(height: 21),
              SizedBox(height: 3, width: MediaQuery.of(context).size.width *.8, child: Container(color: Colors.pink[800]),),
              SizedBox(height: 60)
            ],
          ),




          Container(
            // height: 500,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )
                  ),
                  child: Text(
                    'Existing Rooms',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),
                  ),
                ),
                Container(
                    height: 500,
                    padding: EdgeInsets.all(20),
                    child:
                    rooms.length > 0?

                    ListView.builder(
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(14),
                              margin: EdgeInsets.only(top: 10),
                              color: Colors.blueGrey,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    rooms[index]['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      FlutterClipboard.copy(rooms[index]['room']).then(( value ) {
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Copied to clipboard...',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 17
                                              ),
                                            ),
                                            backgroundColor: Colors.pink,
                                          ),
                                        );
                                      } );
                                    },
                                    child: Text('copy secret key', style: TextStyle(color: Colors.white, fontSize: 15),),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              print(secretKey);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatScreen(room: rooms[index]['room'], role: 'guest')));
                            },
                          );
                        }
                    )
                    :
                    loading?
                    GestureDetector(
                      onTap: getRooms,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        :

                    Center(
                      child: Text('No rooms..', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

