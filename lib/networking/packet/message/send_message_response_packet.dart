import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class SendMessageResponsePacketData extends PacketData {
  int httpStatus;
  String forChannel;
  String content;
  String author;

  SendMessageResponsePacketData(
      {this.httpStatus, this.forChannel, this.content, this.author});

  SendMessageResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    forChannel = json['forChannel'];
    content = json['content'];
    author = json['author'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    data['forChannel'] = this.forChannel;
    data['content'] = this.content;
    data['author'] = this.author;
    return data;
  }
}

class SendMessageResponsePacket extends Packet<SendMessageResponsePacketData> {
  static const int TYPE = 4004;
  SendMessageResponsePacket(SendMessageResponsePacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  SendMessageResponsePacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  SendMessageResponsePacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return SendMessageResponsePacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(SendMessageResponsePacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}