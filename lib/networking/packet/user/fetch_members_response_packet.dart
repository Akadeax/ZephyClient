import 'dart:convert';

import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/networking/packet/packet.dart';

class FetchMembersResponsePacketData extends PacketData {
  int httpStatus;
  String channel;
  List<ListedUser> members;

  FetchMembersResponsePacketData({this.channel, this.members});

  FetchMembersResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    channel = json['channel'];
    if (json['members'] != null) {
      members = <ListedUser>[];
      json['members'].forEach((v) {
        members.add(new ListedUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    data['channel'] = this.channel;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FetchMembersResponsePacket extends Packet<FetchMembersResponsePacketData> {
  static const int TYPE = 5004;
  FetchMembersResponsePacket(FetchMembersResponsePacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  FetchMembersResponsePacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  FetchMembersResponsePacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return FetchMembersResponsePacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(FetchMembersResponsePacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}