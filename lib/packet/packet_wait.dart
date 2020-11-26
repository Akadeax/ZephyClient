import 'dart:async';

import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/packet/packet.dart';
import 'package:zephy_client/packet/packet_handler.dart';

class PacketWait<TPacketType extends Packet> {

  bool disposed = false;

  int type;
  PacketCreator<TPacketType> creator;
  Stream<TPacketType> stream;

  PacketWait(this.type, this.creator);

  void startWait(ServerConnection conn, Function(TPacketType packet) onGot) async {
    if(stream != null) return;


    stream = conn.packetHandler.packetStream<TPacketType>(type, creator);
    await for(TPacketType packet in stream) {
      if(disposed) return;
      onGot(packet);
    }
  }

  void dispose() {
    stream = null;
    disposed = true;
  }
}
