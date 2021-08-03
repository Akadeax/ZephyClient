import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/networking/packet/packet.dart';
import 'package:zephy_client/networking/packet/packet_handler.dart';
import 'package:zephy_client/providers/server_connection.dart';

/// Opens a stream that waits and calls a callback for all packets of
/// TPacketType that are received.
class PacketWait<TPacketType extends Packet> {

  bool disposed = false;

  int type;
  PacketCreator<TPacketType> creator;
  StreamSubscription<TPacketType> _stream;
  PacketWait(this.type, this.creator);

  void startWait(ServerConnection conn, [Function(TPacketType packet) onGot]) async {
    if(_stream != null) return;
    print("starting packet wait stream ($type)...");

    _stream = conn.packetHandler.packetStream<TPacketType>(type, creator).listen((packet) {
      if(disposed) return;
      if(onGot != null) onGot(packet);
      print("received packet in packet wait ($type)");
    });
  }

  void dispose() {
    print("cancelling wait of type $type.");
    _stream.cancel();
    disposed = true;
  }
}

class PacketWaitList {
  final Map<PacketWait, Function(dynamic)> waits = {};

  PacketWaitList();

  void add<TPacketType extends Packet>(
      int type,
      PacketCreator<TPacketType> creator,
      Function(TPacketType) onGot) {
    PacketWait newWait = PacketWait(type, creator);
    waits[newWait] = onGot;
  }

  void start(BuildContext context) {
    print("START CALLED");
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
    if(conn == null) throw ProviderNotFoundException(conn.runtimeType, conn.runtimeType);

    for(PacketWait wait in waits.keys) {
      print("STARTING ${wait.type}");
      wait.startWait(conn, waits[wait]);
    }
  }

  void dispose() {
    for(PacketWait wait in waits.keys) {
      wait.dispose();
    }
  }
}