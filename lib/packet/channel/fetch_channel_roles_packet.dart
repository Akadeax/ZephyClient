import 'dart:convert';

import 'package:zephy_client/models/role_model.dart';
import 'package:zephy_client/packet/packet.dart';

class FetchChannelRolesPacketData extends PacketData {
  String forChannel;
  List<Role> roles;

  FetchChannelRolesPacketData({this.forChannel, this.roles});

  FetchChannelRolesPacketData.fromJson(Map<String, dynamic> json) {
    forChannel = json['forChannel'];
    if (json['roles'] != null) {
      roles = new List<Role>();
      json['roles'].forEach((v) {
        roles.add(new Role.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forChannel'] = this.forChannel;
    if (this.roles != null) {
      data['roles'] = this.roles.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FetchChannelRolesPacket extends Packet<FetchChannelRolesPacketData> {
  static const int TYPE = 3002;
  FetchChannelRolesPacket(FetchChannelRolesPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  FetchChannelRolesPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  FetchChannelRolesPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return FetchChannelRolesPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(FetchChannelRolesPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }

}