import 'dart:convert';

import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/services/networking/packet/packet.dart';

class FetchUserListResponsePacketData extends PacketData {
  int httpStatus;
  List<ListedUser> users;

  FetchUserListResponsePacketData({this.httpStatus, this.users});

  FetchUserListResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users.add(new ListedUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FetchUserListResponsePacket extends Packet<FetchUserListResponsePacketData> {
  static const int TYPE = 5002;
  FetchUserListResponsePacket(FetchUserListResponsePacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  FetchUserListResponsePacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  FetchUserListResponsePacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return FetchUserListResponsePacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(FetchUserListResponsePacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}