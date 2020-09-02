import 'dart:convert';
import 'package:zephy_client/models/user_model.dart';

import '../packet.dart';

class LoginResultPacketData {
  int statusCode;
  PopulatedUser user;

  LoginResultPacketData({this.statusCode, this.user});

  LoginResultPacketData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    user = json['user'] != null ? new PopulatedUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class LoginResultPacket extends Packet<LoginResultPacketData> {
  static const int TYPE = 2002;
  LoginResultPacket(LoginResultPacketData data) : super(TYPE) {
    writePacketData(data);
  }

  LoginResultPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  LoginResultPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    LoginResultPacketData data = LoginResultPacketData.fromJson(jsonDecode(jsonString));
    return data;
  }

  @override
  void writePacketData(LoginResultPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}
