import 'package:http/http.dart' as http;
import 'package:flash_chat/constants.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class FetchUserDataById extends ChangeNotifier{
  List<Map> usersData = [];

  void fetchUserData(userId) async{
    Map data;
    if(usersData.length > 0) {
      data = usersData.firstWhere((el) => el['_id'] == userId ,orElse: () => null);
    }
    if(data != null) {
      // notifyListeners();
      return;
    } else {
      print('else');
      print('$KUrl/fetchUserDataById/$userId');
      http.Response res = await http.get('$KUrl/fetchUserDataById/$userId');
      var object = json.decode(res.body)['userData'];
      if(object != null) {
        usersData.add(object);
        notifyListeners();
      }
    }
  }
  String getImagePath(id) {
    Map user = usersData.firstWhere((el) => el['_id'] == id ,orElse: () => null);
    String imagePath = user != null? user['imagePath']: null;
    return imagePath;
  }
  String getUsername(id) {
    Map user = usersData.firstWhere((el) => el['_id'] == id ,orElse: () => null);
    String username = user != null? user['username']: null;
    return username;
  }
}
