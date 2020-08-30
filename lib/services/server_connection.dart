import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zephy_client/packet/packet.dart';
import 'package:zephy_client/packet/packet_receiver.dart';
import 'package:zephy_client/services/server_locator.dart';

class ServerConnection {
  PacketReceiver _handler;
  Socket _socket;

  ServerConnection() {
    _handler = new PacketReceiver(this);
  }

  void connect(BuildContext context, BroadcastResult connInfo) async {
    if(_socket != null) {
      return;
    }

    _socket = await Socket.connect(connInfo.receivedFromAddress, connInfo.receivedFromPort);
    _listenForPackets();
  }

  void sendPacket(Packet toSend) {
    _socket.add(toSend.buffer);
  }

  void close() {
    _socket.close();
  }

  void _listenForPackets() {
    _socket.listen((event) {
      _handler.handle(event.buffer.asUint8List());
    });
  }
}
