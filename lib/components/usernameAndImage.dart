import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/functionality/fetchUserDataById.dart';
import 'package:provider/provider.dart';

class UsernameAndImage extends StatefulWidget {
  bool isMe;
  String userId;
  String type;
  UsernameAndImage({@required this.isMe, @required this.userId, @required this.type});
  @override
  _UsernameAndImageState createState() => _UsernameAndImageState();
}

class _UsernameAndImageState extends State<UsernameAndImage> {

  @override
  Widget build(BuildContext context) {
    FetchUserDataById usersProvider = Provider.of<FetchUserDataById>(context);
    double width = MediaQuery.of(context).size.width;
    usersProvider.fetchUserData(widget.userId);

    return Consumer<FetchUserDataById>(
      builder: (context, FetchUserDataById users, child) {
        return Stack(
          overflow: Overflow.visible,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: width > KSmallScreenSize? 29: 26,
                  backgroundColor: Colors.white,
                ),
                Positioned(
                  left: 2,
                  child: CircleAvatar(
                    radius: width > KSmallScreenSize? 28: 25,
                    backgroundImage: NetworkImage(users.getImagePath(widget.userId) != null?users.getImagePath(widget.userId): 'https://developer.android.com/codelabs/kotlin-android-training-internet-images/img/6c1f87d1c932c762.png'),
                  ),
                ),
              ],
            ),
            Positioned(
              left: !widget.isMe? 68: null,
              right: widget.isMe? 68: null,
              top: widget.type=='photo'?20 : 10,
              child: Text(users.getUsername(widget.userId)!=null? users.getUsername(widget.userId): 'loading', style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              )),
            ),
          ],
        );
      }
    );
  }
}
