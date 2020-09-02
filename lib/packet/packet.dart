import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'bit_converter.dart';

abstract class Packet<TPacketData> {
  @protected
  static const int BASE_PACKET_SIZE = 2;

  List<int> buffer;

  @protected
  Packet(int type) {
    buffer = BitConverter.getBytesUint16(type);
  }

  Packet.fromBuffer(List<int> packet) {
    buffer = packet;
  }

  int getPacketType() {
    return readUShort(0);
  }

  static int getPacketTypeFromBuffer(List<int> buffer) {
    return BitConverter.getUint16(buffer);
  }

  int readUShort(int offset) {
    return BitConverter.getUint16(buffer, offset: offset);
  }

  void writeUShort(int value, int offset) {
    List<int> valueBuffer = BitConverter.getBytesUint16(value);
    buffer.insertAll(offset, valueBuffer);
  }


  String readString(int offset, int count) {
    return utf8.decode(buffer.getRange(offset, offset + count).toList());
  }

  void writeString(String value, int offset) {
    List<int> valueBuffer = utf8.encode(value);
    buffer.insertAll(offset, valueBuffer);
  }

  TPacketData readPacketData();

  void writePacketData(TPacketData data);
}
