import 'dart:convert';

import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/networking/packet/packet.dart';

class LoginResponsePacketData extends PacketData {
  int httpStatus;
  BaseUser user;
  String accessToken;

  LoginResponsePacketData({this.httpStatus, this.user, this.accessToken});

  LoginResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    user = json['user'] != null ? new BaseUser.fromJson(json['user']) : null;
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['accessToken'] = this.accessToken;
    return data;
  }
}

class LoginResponsePacket extends Packet<LoginResponsePacketData> {
  static const int TYPE = 2002;
  LoginResponsePacket(LoginResponsePacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  LoginResponsePacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  LoginResponsePacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return LoginResponsePacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(LoginResponsePacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}