import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  late IO.Socket _socket;
  ServerStatus _serverStatus = ServerStatus.Connecting;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => _socket;

  SocketService() {
    this.initConfig();
  }
  void initConfig() {
    this._socket = IO.io(
        'http://10.0.2.2:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    this._socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    this._socket.on('nuevo-mensaje', (payload) {
      (payload.containsKey('nombre')
          ? print(payload['nombre'])
          : print('No tiene'));
    });
  }

  void emitir() {
    this._socket.emit('emitir-flutter',
        {'nombre': 'Flutter', 'mensaje': 'Hola desde Flutter'});
  }
}
