import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zephy_client/utils/bit_converter.dart';


abstract class PacketData {
  PacketData();

  PacketData.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}

abstract class Packet<TPacketData> {
  static const int BASE_PACKET_SIZE = 4;

  List<int> buffer;

  @protected
  Packet(int type, PacketData packetData) {
    buffer = BitConverter.getBytesUint16(type);
    int jsonLen = jsonEncode(packetData.toJson()).length;
    int totalLen = jsonLen + BASE_PACKET_SIZE;
    buffer.insertAll(2, BitConverter.getBytesUint16(totalLen));
  }

  Packet.fromBuffer(List<int> packet) {
    buffer = packet;
  }

  int getPacketType() {
    return readUShort(0);
  }

  int getPacketSize() {
    return readUShort(2);
  }

  static int getPacketTypeFromBuffer(List<int> buffer) {
    if(buffer.length < 2) return null;
    return BitConverter.getUint16(buffer);
  }

  static int getPacketSizeFromBuffer(List<int> buffer) {
    return BitConverter.getUint16(buffer, offset: 2);
  }

  int readUShort(int offset) {
    return BitConverter.getUint16(buffer, offset: offset);
  }

  void writeUShort(int value, int offset) {
    List<int> valueBuffer = BitConverter.getBytesUint16(value);
    buffer.insertAll(offset, valueBuffer);
  }


  String readString(int offset, int count) {
    return utf8.decode(buffer.getRange(offset, offset + count).toList(), allowMalformed: true);
  }

  void writeString(String value, int offset) {
    List<int> valueBuffer = utf8.encode(value);
    buffer.insertAll(offset, valueBuffer);
  }

  TPacketData readPacketData();

  void writePacketData(TPacketData data);
}
