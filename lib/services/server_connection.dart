import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:zephy_client/packet/packet.dart';
import 'package:zephy_client/services/packet_handler.dart';
import 'package:zephy_client/services/server_locator.dart';

class ServerConnection {
  Socket _socket;
  StreamController<Uint8List> broadcastStream = StreamController<Uint8List>.broadcast();

  PacketHandler _packetHandler;

  ServerConnection() {
    this._packetHandler = PacketHandler(this);
  }

  Future<bool> connect(BroadcastResult connInfo) async {
    if(_socket != null) {
      return false;
    }

    _socket = await Socket.connect(connInfo.receivedFromAddress, connInfo.receivedFromPort);
    _socket.listen((List<int> data) {
      broadcastStream.add(data);
    });
    return true;
  }

  void sendPacket(Packet toSend) {
    _socket.add(toSend.buffer);
  }

  void close() {
    _socket.close();
    broadcastStream.close();
  }

  Future<TPacketType> waitForPacket<TPacketType>(ItemCreator<TPacketType> creator) async {
    return _packetHandler.waitForPacket(creator);
  }
}
