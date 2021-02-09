import 'dart:convert';
import 'dart:io';
import '../components/snackBarLookAlike.dart';
import 'package:http/http.dart' as http;
import 'file:///D:/Projects/Flutter-Course-Resources-master/farghaly_chat/flash-chat-flutter/lib/functionality/pick_image.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/changePassword_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormWidget extends StatefulWidget {
  FormWidget({this.userAuth, this.loading, this.func});
   void Function(
    String email,
    String useranme,
    String password,
    bool islogin,
    BuildContext ctx,
    dynamic pickedImage,
    String func
  ) userAuth;
  bool loading;
  String func;
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _username = TextEditingController();
  void pickImage(imageFile) {
    setState(() {
      pickedImage = imageFile;
    });
  }
  var pickedImage;
  String email = '';
  String username = '';
  String password = '';
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  void _submitForm() {
    print(_formKey);
    final isValidate = _formKey.currentState.validate();
    if(isValidate) {
      _formKey.currentState.save();
      widget.userAuth(email, username, password, _isLogin, context, pickedImage, widget.func);
    }
  }
  @override
  void initState() {
    print('Welcome to form widget');
    if(widget.func == 'update') {
      print(storage.getItem('userData'));
      _isLogin = false;
      _email.text = storage.getItem('userData')['email'];
      _username.text = storage.getItem('userData')['username'];
    } else {
      // _email.text = 'saadawy.thecousin@gmail.com';
      // _password.text = '1234567';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if(!_isLogin)
            PickImage(imageSource: ImageSource.camera, screen: 'form',icon: Icons.camera_alt, pickImageFunction: pickImage,),

            TextFormField(
              controller: _email,
              key: ValueKey('email'),
              validator: (val) {
                if(val.isEmpty || !val.contains('@')) return 'input right email';
                else return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Input email'),
              onChanged: (val) {email = val;},
            ),
            if(!_isLogin)
            TextFormField(
              controller: _username,
              key: ValueKey('username'),
              validator: (val) {
                if(val.isEmpty || val.length < 4) return 'Username is short';
                else return null;
              },
              decoration: InputDecoration(labelText: 'Input username'),
              keyboardType: TextInputType.text,
              onSaved: (val) {username = val;},
            ),
            if(widget.func != 'update')
            TextFormField(
              controller: _password,
              key: ValueKey('password'),
              validator: (val) {
                if(val.isEmpty || val.length < 7) return 'password is short';
                else return null;
              },
              decoration: InputDecoration(labelText: 'Input password'),
              obscureText: true,
              onSaved: (val) {password = val;},
            ),
            SizedBox(height: 20),
            if(widget.loading)
              CircularProgressIndicator(),
            if(!widget.loading)
            RaisedButton(
                child: Text(_isLogin?'Login': 'register'),
                onPressed: _submitForm,
            ),
            if(widget.func != 'update')
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text(_isLogin?'You don\'t have account.. register now': 'you have an account login'),
              onPressed: (){
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
            ),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text(_isLogin?'reset password': widget.func=='update'?'change your password': ''),
              onPressed: () async{
                if(widget.func == 'update') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                } else if(_isLogin) {
                  print(email);
                  http.Response res = await http.get('$KUrl/resetPassword/$email');
                  if(json.decode(res.body)['done']) {
                    SnackBarLookAlike(message: 'check your email for new password', color: Colors.green[800]);
                  } else {
                    SnackBarLookAlike(message: 'Password reset failed', color: Colors.red[600]);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
