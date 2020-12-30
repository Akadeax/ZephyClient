import 'dart:convert';

import 'package:zephy_client/packet/packet.dart';

class ModifyChannelAction
{
  static const int REMOVE_ROLE = 0;
  static const int ADD_ROLE = 1;
  static const int UPDATE_NAME = 2;
  static const int UPDATE_DESC = 3;
  static const int DELETE = 4;
}

class ModifyChannelPacketData extends PacketData {
  int action;
  String channel;
  String data;

  ModifyChannelPacketData({this.action, this.channel, this.data});

  ModifyChannelPacketData.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    channel = json['channel'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['channel'] = this.channel;
    data['data'] = this.data;
    return data;
  }
}

class ModifyChannelPacket extends Packet<ModifyChannelPacketData> {
  static const int TYPE = 3003;
  ModifyChannelPacket(ModifyChannelPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  ModifyChannelPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  ModifyChannelPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return ModifyChannelPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(ModifyChannelPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }

}