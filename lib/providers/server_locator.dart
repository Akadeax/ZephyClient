import 'dart:async';
import 'dart:io';

import 'package:zephy_client/networking/packet/general/identify_packet.dart';
import 'package:zephy_client/networking/packet/packet.dart';

class ServerLocator {
  static const int TIMEOUT_SECS = 5;
  static const int UDP_PORT = 6556;

  BroadcastResult lastBroadcastResult;

  RawDatagramSocket _socket;

  /// tries to locate the server on the local network and returning the location of it;
  /// times out after one second, returning null.
  Future<BroadcastResult> locate() async {
    BroadcastResult res = await _locate().timeout(Duration(seconds: TIMEOUT_SECS), onTimeout: () {
      print("locating timed out!");
      return null;
    });
    _socket.close();
    lastBroadcastResult = res;
    return res;
  }

  Future<BroadcastResult> _locate() async {
    print("trying to locate server...");
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, UDP_PORT);
    _socket.broadcastEnabled = true;
    _socket.readEventsEnabled = true;

    _sendIdentify();

    return await _waitForAnswer();
  }

  void _sendIdentify() {
    IdentifyPacket sendPacket = IdentifyPacket(IdentifyPacketData(src: "CLIENT"));
    _socket.send(sendPacket.buffer, InternetAddress("255.255.255.255"), UDP_PORT);
  }

  Future<BroadcastResult> _waitForAnswer() async {
    await for(RawSocketEvent event in _socket) {
      if(event != RawSocketEvent.read) continue;

      Datagram dgram = _socket.receive();
      if (Packet.getPacketTypeFromBuffer(dgram.data) != IdentifyPacket.TYPE) continue;

      IdentifyPacket recvPacket = IdentifyPacket.fromBuffer(dgram.data);
      if(recvPacket.readPacketData().src != "SERVER") continue;
      print("Received answer from '${recvPacket.readPacketData().src}'!");

      // to improve user experience; doesn't instantly jump to login screen
      // after successful loation
      await Future.delayed(const Duration(seconds: 1));

      return BroadcastResult(recvPacket, dgram.address, dgram.port);
    }

    return null;
  }

  void close() {
    _socket.close();
  }
}

class BroadcastResult {
  IdentifyPacket receivedResult;
  InternetAddress receivedFromAddress;
  int receivedFromPort;

  BroadcastResult(
    this.receivedResult,
    this.receivedFromAddress,
    this.receivedFromPort
  );
}
