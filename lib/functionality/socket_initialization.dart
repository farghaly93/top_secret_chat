import 'package:flash_chat/constants.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class SocketInitialization {
   static SocketIO socket;

  void initiateSocket() {
    socket = SocketIOManager().createSocketIO(KUrl, '/');
    socket.init();
    socket.connect();
  }
}