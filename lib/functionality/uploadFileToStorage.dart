import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flash_chat/constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadImageToStorage {
  UploadImageToStorage({this.file, this.audio});
  final file;
  final audio;
  Future<String> uploadAndGetUrl() async{
    var request;
    if(file != null) {
      request = http.MultipartRequest(
          'POST', Uri.parse(KUrl + '/uploadFile'));
      request.files.add(
          await http.MultipartFile.fromPath(
              'file',
              file.path
          )
      );
    } else if(audio != null) {
      request = http.MultipartRequest(
          'POST', Uri.parse(KUrl + '/uploadAudio'));
      request.files.add(
          await http.MultipartFile.fromPath(
              'file',
              audio.path
          )
      );
    }
    // final res = await request.send();
    // res.stream.transform(utf8.decoder).listen((event) {
    //
    // });

    http.Response response = await http.Response.fromStream(await request.send());
    String url = json.decode(response.body)['url'];
    // print(url);
    return url;
  }
}