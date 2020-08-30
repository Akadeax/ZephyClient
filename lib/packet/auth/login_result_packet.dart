import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/user_model.dart';
import 'package:zephy_client/screens/inbox_screen.dart';
import 'package:zephy_client/services/nav_wrapper.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/server_connection.dart';

import '../packet.dart';

class LoginResultPacketHandler extends PacketHandler<LoginResultPacketHandler> {

  ProfileData profileData = Provider.of<ProfileData>(rootNavContext, listen: false);

  @override
  handle(List<int> buffer, ServerConnection serverConn) {
    LoginResultPacket received = LoginResultPacket.fromBuffer(buffer);
    LoginResultPacketData data = received.readPacketData();

    if(data.statusCode == HttpStatus.ok && data.user != null) {
      pushNextFrame(InboxScreen());
      profileData.loggedInUser = data.user;
    } else {
      //Scaffold.of(SignInFormState.formKey.currentContext).showSnackBar(wrongLoginSnackbar());
    }
  }

  SnackBar wrongLoginSnackbar() {
    return SnackBar(
      content: Text("Invalid login data!"),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
    );
  }
}

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
