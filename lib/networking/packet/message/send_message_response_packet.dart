import 'dart:convert';

import 'package:zephy_client/models/message.dart';
import 'package:zephy_client/networking/packet/packet.dart';

class SendMessageResponsePacketData extends PacketData {
  int httpStatus;
  PopulatedMessage message;
  String channel;

  SendMessageResponsePacketData({this.httpStatus, this.message, this.channel});

  SendMessageResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    message =
    json['message'] != null ? new PopulatedMessage.fromJson(json['message']) : null;
    channel = json['channel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    data['channel'] = this.channel;
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