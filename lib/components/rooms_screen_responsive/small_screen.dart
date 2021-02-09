import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/createRoom_screen.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class RoomsSmallScreen extends StatelessWidget {
  RoomsSmallScreen({this.secretKey, this.rooms, this.getRooms, this.loading});
  String secretKey;
  Function getRooms;
  List rooms = [];
  bool loading;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 450,
      // height: 600,
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: SweepGradient(
            colors: [
            Colors.pink[500],
            Colors.pink,
            Colors.pinkAccent,
            Colors.pink[600],
            Colors.pink[500]
          ]
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [



          Text('Enter the Room secret key',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
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
              SizedBox(height: 20)
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
              SizedBox(height: 20)
            ],
          ),




          Card(
            // height: 500,
            elevation: 6,
            color: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[700],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
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
                      height: 270,
                      padding: EdgeInsets.all(5),
                      child:
                      rooms.length > 0?

                      ListView.builder(
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(top: 10),
                              color: Colors.pink[800],
                              child: GestureDetector(
                                onTap: () {
                                  print(secretKey);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatScreen(room: rooms[index]['room'], name: rooms[index]['name'], role: 'guest')));
                                },
                                child: ListTile(

                                    leading: Text(
                                      rooms[index]['name'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                     trailing: FlatButton(
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
                                      child: Text('copy', style: TextStyle(color: Colors.white, fontSize: 15),),
                                    ),
                                ),
                              ),
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
                      ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

