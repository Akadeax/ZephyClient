import 'dart:async';
import 'dart:io';

import 'package:zephy_client/networking/packet/general/identify_packet.dart';
import 'package:zephy_client/networking/packet/packet.dart';

class ServerLocator {
  static const int TIMEOUT_SECS = 5;

  BroadcastResult lastBroadcastResult;

  RawDatagramSocket _socket;
  final int sendPort, listenPort;

  ServerLocator({this.sendPort = 6556, this.listenPort = 6557});

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
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, listenPort);
    _socket.broadcastEnabled = true;

    _sendIdentify();

    return await _waitForAnswer();
  }

  void _sendIdentify() {
    IdentifyPacket sendPacket = IdentifyPacket(IdentifyPacketData(src: "CLIENT"));
    _socket.send(sendPacket.buffer, InternetAddress("255.255.255.255"), sendPort);
  }

  Future<BroadcastResult> _waitForAnswer() async {
    await for(RawSocketEvent event in _socket) {
      if(event != RawSocketEvent.read) continue;

      _socket.readEventsEnabled = true;
      Datagram dgram = _socket.receive();
      if (Packet.getPacketTypeFromBuffer(dgram.data) != IdentifyPacket.TYPE) continue;

      IdentifyPacket recvPacket = IdentifyPacket.fromBuffer(dgram.data);
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
