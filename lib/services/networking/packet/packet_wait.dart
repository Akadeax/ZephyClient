import 'dart:async';

import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/services/networking/packet/packet.dart';
import 'package:zephy_client/services/networking/packet/packet_handler.dart';

/// Opens a stream that waits and calls a callback for all packets of
/// TPacketType that are received.
class PacketWait<TPacketType extends Packet> {

  bool disposed = false;

  int type;
  PacketCreator<TPacketType> creator;
  StreamSubscription<TPacketType> stream;
  PacketWait(this.type, this.creator);

  void startWait(ServerConnection conn, [Function(TPacketType packet) onGot]) async {
    if(stream != null) return;
    print("starting packet wait stream ($type)...");

    stream = conn.packetHandler.packetStream<TPacketType>(type, creator).listen((packet) {
      if(disposed) return;
      if(onGot != null) onGot(packet);
      print("received packet in packet wait ($type)");
    });
  }

  void dispose() {
    print("cancelling wait of type $type.");
    stream.cancel();
    disposed = true;
  }
}
