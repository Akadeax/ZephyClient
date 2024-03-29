import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zephy_client/networking/packet/packet.dart';
import 'package:zephy_client/providers/server_connection.dart';

typedef S PacketCreator<S>(List<int> buffer);

class PacketHandler with ChangeNotifier {
  List<int> _activeRequests = [];

  ServerConnection _conn;
  PacketHandler(this._conn);

  /// asynchronously wait for a packet of a certain type, i.e.
  /// (yes, syntax is horrible, but that's what you have to do without reflection):
  /// ```dart
  /// MyPacket p = waitForPacket<MyPacket>(MyPacket.TYPE, (buffer) => MyPacket.fromBuffer(buffer));
  /// ```
  /// note: Damn you flutter, you can't cancel futures? This causes bugs with messages still
  /// being waited for in this function but not actually in any function scope, maybe
  /// fix one day.
  Future<TPacketType> waitForPacket<TPacketType extends Packet>(int type, PacketCreator<TPacketType> creator, {Duration timeout = const Duration(seconds: 1)}) async {
    var res = _waitForPacket(type, creator).timeout(timeout, onTimeout: () {
      print("packet wait for $type timed out after $timeout seconds.");
      return null;
    });
    return res;
  }

  Future<TPacketType> _waitForPacket<TPacketType extends Packet>(int type, PacketCreator<TPacketType> creator) async {
    _activeRequests.add(type);
    notifyNextFrame();

    await for(Uint8List data in _conn.packetStream.stream) {
      int packetType = Packet.getPacketTypeFromBuffer(data);

      if(type != packetType) continue;

      _activeRequests.remove(type);
      notifyListeners();
      return creator(data);
    }

    print("cancelling waiting for packet.");
    return null;
  }

  /// open a stream that receives all Packets of TPacketType and puts them in the returned stream.
  Stream<TPacketType> packetStream<TPacketType extends Packet>(int type, PacketCreator<TPacketType> creator) async* {
    notifyNextFrame();

    await for(Uint8List data in _conn.packetStream.stream) {
      int packetType = Packet.getPacketTypeFromBuffer(data);

      if(type != packetType) continue;

      print("got packet in stream ($packetType).");
      notifyListeners();
      yield creator(data);
    }
  }

  // next frame because widgets waiting might be still building when calling this method
  void notifyNextFrame() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });

  }

  /// Checks whether any logic is waiting for a packet of a certain
  /// type at the moment
  bool isPacketWaitOpen(int packetType) => _activeRequests.contains(packetType);
}
