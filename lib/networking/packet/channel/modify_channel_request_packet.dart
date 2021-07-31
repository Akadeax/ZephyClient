import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class ChannelAction {
  static const int MODIFY_NAME = 0;
}

class ModifyChannelRequestPacketData extends PacketData {
  String channel;
  int action;
  String data;

  ModifyChannelRequestPacketData({this.channel, this.action, this.data});

  ModifyChannelRequestPacketData.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    action = json['action'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel'] = this.channel;
    data['action'] = this.action;
    data['data'] = this.data;
    return data;
  }
}

class ModifyChannelRequestPacket extends Packet<ModifyChannelRequestPacketData> {
  static const int TYPE = 3007;
  ModifyChannelRequestPacket(ModifyChannelRequestPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  ModifyChannelRequestPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  ModifyChannelRequestPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return ModifyChannelRequestPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(ModifyChannelRequestPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}