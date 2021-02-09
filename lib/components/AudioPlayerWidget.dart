import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flash_chat/constants.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Color color;
  final String record;
  AudioPlayerWidget({this.color, this.record});
  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  IconData icon = Icons.play_arrow;
  bool play = false;
  int timer = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  int duration = 0;
  double _durationPercentage = 0.0;

  _playRecord() async{
    play = !play;
    if(play) {
      setState(() {
        icon = Icons.pause;
      });
      await audioPlayer.play(widget.record);
    } else {
      setState(() {
        icon = Icons.play_arrow;
      });
      await audioPlayer.pause();
    }
  }

  void _audioDuration() {
    audioPlayer.onDurationChanged.listen((Duration t) {
      setState(() {
        duration = t.inSeconds;//int.parse(t.toString()).toStringAsFixed(2);
      });
    });
  }
  void _isRecordCompleted() async{
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        icon = Icons.play_arrow;
      });
    });
  }

  void _getAudioTime() {
    audioPlayer.onAudioPositionChanged.listen((Duration  p) {
          setState(() {
            timer = p.inSeconds;
            _durationPercentage = duration > 0?timer / duration: 1;

          });
    });
  }

  @override
  void initState() {
    _isRecordCompleted();
    _audioDuration();
    _getAudioTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      // height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(widget.color.withOpacity(.6), BlendMode.srcOver),
          image: AssetImage('images/audio-track.jpg')
        ),
      ),
      padding: width > KSmallScreenSize?EdgeInsets.all(20) : EdgeInsets.all(5) ,
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constrains) {
                return Container(
                  height: 55,
                  width: constrains.maxWidth * _durationPercentage,
                  decoration: BoxDecoration(
                  color: widget.color.withOpacity(.6)
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(icon, size: 35, color: Colors.white), onPressed: _playRecord),
              SizedBox(width: 20,),
              Expanded(
                child: Text('00:$timer:  00:$duration', style: TextStyle(
                  color: Colors.white,
                  fontSize:  width > KSmallScreenSize?22: 15,
                  fontWeight: FontWeight.w600
                ),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
