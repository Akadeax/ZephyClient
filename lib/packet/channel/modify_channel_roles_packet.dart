import 'dart:convert';

import 'package:zephy_client/packet/packet.dart';

class ModifyChannelRolesAction
{
  static const int REMOVE = 0;
  static const int ADD = 1;
}

class ModifyChannelRolesPacketData extends PacketData {
  int action;
  String channel;
  String role;

  ModifyChannelRolesPacketData({this.action, this.channel, this.role});

  ModifyChannelRolesPacketData.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    channel = json['channel'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['channel'] = this.channel;
    data['role'] = this.role;
    return data;
  }
}

class ModifyChannelRolesPacket extends Packet<ModifyChannelRolesPacketData> {
  static const int TYPE = 3003;
  ModifyChannelRolesPacket(ModifyChannelRolesPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  ModifyChannelRolesPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  ModifyChannelRolesPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return ModifyChannelRolesPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(ModifyChannelRolesPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }

}