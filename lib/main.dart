import 'package:flash_chat/functionality/fetchUserDataById.dart';
import 'package:flash_chat/functionality/socket_initialization.dart';
import 'package:flash_chat/screens/auth_screen.dart';
import 'package:flash_chat/screens/not_found.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/rooms_screen.dart';
import 'package:flash_chat/screens/createRoom_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'screens/chat_screen.dart';
import 'screens/rooms_screen.dart';
import 'screens/createRoom_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SocketInitialization socketInit = SocketInitialization();
  socketInit.initiateSocket();
  runApp(FlashChat());
}


class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocalStorage storage = new LocalStorage('auth');
    return ChangeNotifierProvider(
      create: (_)  => FetchUserDataById(),
      child: MaterialApp(
      title: 'Farghaly chat',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Play-Regular'
        ),
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink[400],
        accentColor: Colors.black54,
        primaryIconTheme: IconThemeData(
          color: Colors.white
        ),
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      // home: StreamBuilder(stream: storage.getItem('userData')['token'], builder: (ctx, snapshots) {
      //   if(snapshots.hasData) {
      //     return ChatScreen();
      //   } else {
      //     return AuthScreen();
      //     }
      //   },
      // ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RoomsScreen.id: (context) => RoomsScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        AuthScreen.id: (context) => AuthScreen(),
        CreateRoom.id: (context) => CreateRoom(),
        NotFound.id: (context) => NotFound(),
        },
      ),
    );
  }
}
