import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:zephy_client/packet/packet.dart';
import 'package:zephy_client/services/sockets/packet_handler.dart';
import 'package:zephy_client/services/sockets/server_locator.dart';

class ServerConnection {
  Socket _socket;
  StreamController<Uint8List> packetStream = StreamController<Uint8List>.broadcast();

  PacketHandler packetHandler;

  ServerConnection() {
    this.packetHandler = PacketHandler(this);
  }

  List<int> _currPacketTotal = [];
  int _currPacketRequiredSize = -1;

  /// attempts to connect to the server at 'connInfo'. returns success.
  Future<bool> connect(BroadcastResult connInfo) async {
    if(_socket != null) {
      return false;
    }

    _socket = await Socket.connect(connInfo.receivedFromAddress, connInfo.receivedFromPort);

    _socket.listen(_listen);

    return true;
  }

  void _listen(List<int> data) {
    // if this is the start of a new packet
    if(_currPacketRequiredSize == -1) {
      _currPacketRequiredSize = Packet.getPacketSizeFromBuffer(data);
    }

    // if we still need to receive more bytes to finish the current packet
    if(_currPacketTotal.length < _currPacketRequiredSize) {
      _currPacketTotal.addAll(data);
    }
    // current packet is finished
    if(_currPacketTotal.length == _currPacketRequiredSize) {
      // add entire finished result to packetStream
      packetStream.add(Uint8List.fromList(_currPacketTotal.getRange(0, _currPacketRequiredSize).toList()));
      // reset var for next use
      _currPacketTotal = [];
      _currPacketRequiredSize = -1;

    } else if(_currPacketTotal.length > _currPacketRequiredSize) {

      packetStream.add(Uint8List.fromList(_currPacketTotal.getRange(0, _currPacketRequiredSize).toList()));

      List<int> currData = _currPacketTotal.getRange(_currPacketRequiredSize, _currPacketTotal.length).toList();

      // if we received the start of another packet in
      // this data, process it separately as new packet
      _currPacketTotal = [];
      _currPacketRequiredSize = -1;

      _listen(currData);
    }

  }

  void sendPacket(Packet toSend) {
    _socket.add(toSend.buffer);
  }

  void closeConnection() {
    _socket.close();
    packetStream.close();
  }
}

