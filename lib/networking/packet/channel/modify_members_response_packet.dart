import 'dart:convert';

import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/networking/packet/packet.dart';

class ModifyMembersResponsePacketData extends PacketData {
  int httpCode;
  ListedUser user;
  int action;

  ModifyMembersResponsePacketData({this.httpCode, this.user, this.action});

  ModifyMembersResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    user = json['user'] != null ? new ListedUser.fromJson(json['user']) : null;
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpCode'] = this.httpCode;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['action'] = this.action;
    return data;
  }
}

class ModifyMembersResponsePacket extends Packet<ModifyMembersResponsePacketData> {
  static const int TYPE = 3006;
  ModifyMembersResponsePacket(ModifyMembersResponsePacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  ModifyMembersResponsePacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  ModifyMembersResponsePacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return ModifyMembersResponsePacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(ModifyMembersResponsePacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}