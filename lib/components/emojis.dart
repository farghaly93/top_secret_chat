import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Emojis extends StatefulWidget {
  Emojis({this.printEmoji});
  void Function(String) printEmoji;
  @override
  _EmojisState createState() => _EmojisState();
}

class _EmojisState extends State<Emojis> {
  List emojis = [];
  int index = 0;
  int numberOfRows = 1;

  @override
  void initState() {
    getEmojis();
    super.initState();
  }
  void getEmojis() async{
    http.Response res = await http.get('https://emoji-api.com/emojis?search=face&access_key=cc8a8f13268c99a037f72fda7979f0143eb4e665');
    List data = json.decode(res.body);
    List emotions = data.map((e) => e['character']).toList();

    index = emotions.length;
    numberOfRows = (emotions.length / 10).ceil();
    setState(() {
      emojis = emotions;
      print(emojis.length);
    });

  }
  @override
  Widget build(BuildContext context) {
    return (
      emojis.length == 0?
          Center(
            child: CircularProgressIndicator(),
          ):
       GridView.builder(
        itemCount: emojis.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, crossAxisSpacing: 1.0, mainAxisSpacing: 1.0),
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            child: Text(emojis[index],style: TextStyle(fontSize: 25),),
            onTap: () {
              widget.printEmoji(emojis[index]);
            },
          );
      },
    ));
  }
}
