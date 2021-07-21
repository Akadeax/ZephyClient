import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class MemberAction {
  static const int ADD_MEMBER = 0;
  static const int REMOVE_MEMBER = 1;
}

class ModifyMembersRequestPacketData extends PacketData {
  int action;
  String channel;
  String user;

  ModifyMembersRequestPacketData({this.action, this.channel, this.user});

  ModifyMembersRequestPacketData.fromJson(Map<String, dynamic> json) {
  action = json['action'];
  channel = json['channel'];
  user = json['user'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['action'] = this.action;
  data['channel'] = this.channel;
  data['user'] = this.user;
  return data;
  }
}

class ModifyMembersRequestPacket extends Packet<ModifyMembersRequestPacketData> {
  static const int TYPE = 3005;
  ModifyMembersRequestPacket(ModifyMembersRequestPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  ModifyMembersRequestPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  ModifyMembersRequestPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return ModifyMembersRequestPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(ModifyMembersRequestPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}