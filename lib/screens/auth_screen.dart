import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/form_widget.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/rooms_screen.dart';
import 'file:///D:/Projects/Flutter-Course-Resources-master/farghaly_chat/flash-chat-flutter/lib/functionality/uploadFileToStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';

class AuthScreen extends StatefulWidget {
  static const id = 'authScreen';
  AuthScreen({this.func});
  final String func;
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void initState() {
    super.initState();
    if(storage.getItem('userData') != null && widget.func != 'update') {
      Navigator.pushReplacementNamed(context, ChatScreen.id);
    }
  }
  bool loading = false;
  void userAuth(String email, String username, String password, bool isLogin, BuildContext ctx, pickedImage, func) async {
    try {
      setState(() {
        loading = true;
      });
      if (isLogin) {
        final body = {
          'email': email,
          'password': password,
        };
        final jsonBody = json.encode(body);
        final login = await post(
            '$KUrl/login',
            body: jsonBody,
            headers: {
              'Content-Type': 'application/json'
            }
        );
        setState(() {
          loading = false;
        });
        final data = json.decode(login.body);
        if(data['error'] == null) {
          storage.setItem('userData', data['userData']);
          if (storage.getItem('userData')['token'] != null) {
            Navigator.pushReplacementNamed(context, RoomsScreen.id);
          }
        } else {
          Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(data['error'].toString()), backgroundColor: Theme.of(ctx).errorColor,),);
        }
      }
      else if (!isLogin) {
       var image;
        if(pickedImage != null) {
          image = pickedImage;
        } else {
          if(storage.getItem('userData')['imagePath'] != null) {
            image = storage.getItem('userData')['imagePath'];
          } else {
            image = null;
          }
        }
        String url;
        String method = func == 'update'? 'updateUser': 'register';
         if(image is PickedFile) {
           UploadImageToStorage uploadImage = UploadImageToStorage(
               file: image);
           url = await uploadImage.uploadAndGetUrl();
         } else if(image is String) {
           url = image;
         }
          if(url != null) {
            final body = {
              'email': email,
              'username': username,
              'imagePath': url,
            };
            if(func=='update') body.addAll({'_id': storage.getItem('userData')['_id']});
            if(func !='update') body.addAll({'password': password});
            final jsonBody = json.encode(body);
            final register = await post(
                '$KUrl/$method',
                body: jsonBody,
                headers: {
                  'Content-Type': 'application/json'
                }
            );
            final data = json.decode(register.body);
            storage.setItem('userData', data['userData']);
            if (storage.getItem('userData')['token'] != null) {
              Navigator.pushReplacementNamed(context, RoomsScreen.id);
            }
          }
          // });
        }
      } on PlatformException catch(e) {
      setState(() {
        loading = false;
      });
      String message = 'Problem has occurred please check';
      if(e.message != null) {
        message = e.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(message), backgroundColor: Theme.of(ctx).errorColor,),);
    } catch(e) {
      setState(() {
        loading = false;
      });
      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Theme.of(ctx).errorColor,),);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).primaryColor,
        title: Text('Registration screen'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('images/icon.png', height: 65, width: 65),
                    Text('Farghaly Chat', style: TextStyle(
                        color: Colors.white,
                        fontSize: 37,
                        fontWeight: FontWeight.bold

                    )),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: FormWidget(userAuth: userAuth, loading: loading, func: widget.func),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

