import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class LoginAttemptPacketData extends PacketData {
  String username;
  String email;
  String password;

  LoginAttemptPacketData({this.username, this.email, this.password});

  LoginAttemptPacketData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}

class LoginAttemptPacket extends Packet<LoginAttemptPacketData> {
  static const int TYPE = 2001;
  LoginAttemptPacket(LoginAttemptPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  LoginAttemptPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  LoginAttemptPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return LoginAttemptPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(LoginAttemptPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}