import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:zephy_client/packet/auth/login_result_packet.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';
import 'package:zephy_client/packet/identify_packet.dart';
import 'package:zephy_client/packet/packet.dart';
import 'package:zephy_client/services/server_locator.dart';

typedef S ItemCreator<S>(List<int> buffer);

class ServerConnection {
  static Map<int, Type> _packetTypes = {
    IdentifyPacket.TYPE: IdentifyPacket.fromBuffer(null).runtimeType,
    LoginResultPacket.TYPE: LoginResultPacket.fromBuffer(null).runtimeType,
    AccessibleChannelsInfoPacket.TYPE: AccessibleChannelsInfoPacket.fromBuffer(null).runtimeType,
  };

  Socket socket;
  StreamController<Uint8List> broadcastStream = StreamController<Uint8List>.broadcast();

  Future<bool> connect(BroadcastResult connInfo) async {
    if(socket != null) {
      return false;
    }

    socket = await Socket.connect(connInfo.receivedFromAddress, connInfo.receivedFromPort);
    socket.listen((List<int> data) {
      broadcastStream.add(data);
    });
    return true;
  }

  void sendPacket(Packet toSend) {
    socket.add(toSend.buffer);
  }

  void close() {
    socket.close();
    broadcastStream.close();
  }

  Future<TPacketType> waitForPacket<TPacketType>(ItemCreator<TPacketType> creator) async {
    print("starting to wait for packet...");
    await for(Uint8List data in broadcastStream.stream) {
      int packetType = Packet.getPacketTypeFromBuffer(data);
      log("received something ($packetType): ${utf8.decode(data.sublist(2))}");
      if(!_packetTypes.containsKey(packetType)) continue;
      print("the received thing was right! returning the packet.");
      return creator(data);
    }

    print("cancelling waiting for packet.");
    return null;
  }
}
