import 'dart:convert';

import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/models/user_model.dart';
import 'package:zephy_client/services/server_connection.dart';

import '../packet.dart';

class AccessibleChannelsInfoPacketData {
  List<BaseChannelData> accessibleChannelsData;
  PopulatedUser forUser;

  AccessibleChannelsInfoPacketData({this.accessibleChannelsData, this.forUser});

  AccessibleChannelsInfoPacketData.fromJson(Map<String, dynamic> json) {
    if (json['accessibleChannelsData'] != null) {
      accessibleChannelsData = new List<BaseChannelData>();
      json['accessibleChannelsData'].forEach((v) {
        accessibleChannelsData.add(new BaseChannelData.fromJson(v));
      });
    }
    forUser =
    json['forUser'] != null ? new PopulatedUser.fromJson(json['forUser']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessibleChannelsData != null) {
      data['accessibleChannelsData'] =
          this.accessibleChannelsData.map((v) => v.toJson()).toList();
    }
    if (this.forUser != null) {
      data['forUser'] = this.forUser.toJson();
    }
    return data;
  }
}


class AccessibleChannelsInfoPacketHandler extends PacketHandler<AccessibleChannelsInfoPacketHandler> {
  @override
  handle(List<int> buffer, ServerConnection serverConn) {
    AccessibleChannelsInfoPacket received = AccessibleChannelsInfoPacket.fromBuffer(buffer);
    AccessibleChannelsInfoPacketData data = received.readPacketData();

    print("User ${data.forUser.name} has access to channels:");
    for(BaseChannelData ch in data.accessibleChannelsData) {
      print(ch.name);
    }
  }
}

class AccessibleChannelsInfoPacket extends Packet<AccessibleChannelsInfoPacketData> {
  static const int TYPE = 3001;
  AccessibleChannelsInfoPacket(AccessibleChannelsInfoPacketData data) : super(TYPE) {
    writePacketData(data);
  }

  AccessibleChannelsInfoPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  AccessibleChannelsInfoPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return AccessibleChannelsInfoPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(AccessibleChannelsInfoPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }

}