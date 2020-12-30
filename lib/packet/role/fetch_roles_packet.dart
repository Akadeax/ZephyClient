import 'dart:convert';

import 'package:zephy_client/models/role_model.dart';
import 'package:zephy_client/packet/packet.dart';

class FetchRolesPacketData extends PacketData {
  String forChannel;
  List<Role> roles;

  FetchRolesPacketData({this.forChannel, this.roles});

  FetchRolesPacketData.fromJson(Map<String, dynamic> json) {
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

class FetchRolesPacket extends Packet<FetchRolesPacketData> {
  static const int TYPE = 5000;
  FetchRolesPacket(FetchRolesPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  FetchRolesPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  FetchRolesPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return FetchRolesPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(FetchRolesPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }

}