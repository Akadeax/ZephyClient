import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zephy_client/packet/packet.dart';
import 'package:zephy_client/services/server_connection.dart';

typedef S ItemCreator<S>(List<int> buffer);

class PacketHandler with ChangeNotifier {
  List<int> _activeRequests = [];

  ServerConnection _conn;
  PacketHandler(this._conn);

  /// asynchronously wait for a packet of a certain type, i.e.
  /// (yes, syntax is horrible, but that's what you have to do without reflection):
  /// ```dart
  /// MyPacket p = waitForPacket<MyPacket>(MyPacket.TYPE, (buffer) => MyPacket.fromBuffer(buffer));
  /// ```
  Future<TPacketType> waitForPacket<TPacketType extends Packet>(int type, ItemCreator<TPacketType> creator) async {
    print("starting to wait for packet...");
    _activeRequests.add(type);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
    await for(Uint8List data in _conn.packetStream.stream) {
      int packetType = Packet.getPacketTypeFromBuffer(data);

      if(type != packetType) continue;

      print("got packet ($packetType).");
      _activeRequests.remove(type);
      notifyListeners();
      return creator(data);
    }

    print("cancelling waiting for packet.");
    return null;
  }

  /// Checks whether any logic is waiting for a packet of a certain
  /// type at the moment
  bool isPacketWaitOpen(int packetType) => _activeRequests.contains(packetType);
}
