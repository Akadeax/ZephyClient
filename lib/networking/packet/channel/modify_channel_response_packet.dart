import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class ModifyChannelResponsePacketData extends PacketData {
  int httpStatus;
  String channel;
  int action;
  String data;

  ModifyChannelResponsePacketData(
      {this.httpStatus, this.channel, this.action, this.data});

  ModifyChannelResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    channel = json['channel'];
    action = json['action'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    data['channel'] = this.channel;
    data['action'] = this.action;
    data['data'] = this.data;
    return data;
  }
}

class ModifyChannelResponsePacket extends Packet<ModifyChannelResponsePacketData> {
  static const int TYPE = 3008;
  ModifyChannelResponsePacket(ModifyChannelResponsePacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  ModifyChannelResponsePacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  ModifyChannelResponsePacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return ModifyChannelResponsePacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(ModifyChannelResponsePacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}