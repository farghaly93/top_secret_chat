import 'dart:io';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  PickImage({this.pickImageFunction, this.imageSource, this.icon, this.screen});
  final void Function(PickedFile imageFile) pickImageFunction;
  final ImageSource imageSource;
  final IconData icon;
  final String screen;
  @override
  _PickImageState createState() => _PickImageState();
}
class _PickImageState extends State<PickImage> {
  String networkImage = storage.getItem('userData') != null? storage.getItem('userData')['imagePath']: null;
  PickedFile _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(widget.screen == 'form')
        CircleAvatar(
          radius: 44,
          backgroundImage: _pickedImage != null?
              FileImage(File(_pickedImage.path)) :
                networkImage != null?
                    NetworkImage(networkImage):
                    null
        ),
        FlatButton.icon(

            onPressed: () async{
              final pickedImage = await ImagePicker().getImage(
                source: widget.imageSource,
                imageQuality: 100,
                maxWidth: 450
              );
              setState(() {
                _pickedImage = pickedImage;
              });
              if(_pickedImage == null) return;
              widget.pickImageFunction(_pickedImage);
            },
            icon: Icon(widget.icon, color: Theme.of(context).backgroundColor,),
            label: Text(''),
        ),
      ],
    );
  }
}
