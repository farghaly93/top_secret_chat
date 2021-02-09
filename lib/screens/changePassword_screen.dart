import 'dart:async';
import 'dart:convert';
import '../components/snackBarLookAlike.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final  _formKey = GlobalKey<FormState>();
  bool loading = false;
  String oldPassword;
  String newPassword;
  bool _showSnackBar = false;
  String _snackBarMessage;
  Color _snackBarColor;
  void _updatePassword(ctx) async {
    setState(() {
      _showSnackBar = false;
    });
    try {
      final isValid = _formKey.currentState.validate();
      if (isValid) {
        print('valid');
        _formKey.currentState.save();
        Map body = {'old': oldPassword, 'new': newPassword, 'userId': storage.getItem('userData')['_id']};
        var json = jsonEncode(body);
        setState(() {
          loading = true;
        });
        http.Response res = await http.post('$KUrl/changePassword', body: json,
            headers: {'content-type': 'application/json'});
        setState(() {
          loading = false;
        });

        if (jsonDecode(res.body)['done']) {
          setState(() {
            _snackBarMessage = 'Password updated successfully';
            _snackBarColor = Colors.green[800];
            _showSnackBar = true;
          });
        } else {
          setState(() {
            _snackBarMessage = 'Password update failed';
            _snackBarColor = Colors.red[800];
            _showSnackBar = true;
          });
        }
      }
    } catch(err) {
      setState(() {
        loading = false;
        _snackBarMessage = 'Password update failed';
        _snackBarColor = Colors.red[800];
        _showSnackBar = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Change password'),
      ),
      body: Center(
        child: Container(
          height: 400,
          child: SingleChildScrollView(
            child: Card(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Update password', textAlign: TextAlign.center, style: TextStyle(fontSize: 33),),
                          SizedBox(height: 20,),
                          TextFormField(
                            decoration: KTextFieldDecoration.copyWith(
                              hintText: 'old password'
                            ),
                            validator: (val) {
                              if(val.length < 7) {
                                return 'password is short';
                                } else return null;
                              },
                            key: ValueKey('oldPassword'),
                            onChanged: (val) => oldPassword = val,
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            decoration: KTextFieldDecoration.copyWith(
                              hintText: 'new password'
                            ),
                            validator: (val) {
                              if(val.length < 7) {
                                return 'password is short';
                              } else return null;
                            },
                            key: ValueKey('newPassword'),
                            onChanged: (val) => newPassword = val,
                          ),
                          SizedBox(height: 20,),
                          if(!loading)
                            RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Text('Update', style: TextStyle(fontSize: 25),),
                              onPressed: () => _updatePassword(context),
                            ),
                          if(loading)
                            CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                  if(_showSnackBar)
                    SnackBarLookAlike(message: _snackBarMessage, color: _snackBarColor,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
