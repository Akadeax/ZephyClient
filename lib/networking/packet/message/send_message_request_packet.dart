import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class SendMessageRequestPacketData extends PacketData {
  String forChannel;
  String content;

  SendMessageRequestPacketData({this.forChannel, this.content});

  SendMessageRequestPacketData.fromJson(Map<String, dynamic> json) {
    forChannel = json['forChannel'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forChannel'] = this.forChannel;
    data['content'] = this.content;
    return data;
  }
}

class SendMessageRequestPacket extends Packet<SendMessageRequestPacketData> {
  static const int TYPE = 4003;
  SendMessageRequestPacket(SendMessageRequestPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  SendMessageRequestPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  SendMessageRequestPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return SendMessageRequestPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(SendMessageRequestPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}