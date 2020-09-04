import 'dart:convert';

import 'package:zephy_client/models/channel_model.dart';

import '../packet.dart';

class AccessibleChannelsInfoPacketData {
  List<BaseChannelData> accessibleChannelsData;
  String forUser;

  AccessibleChannelsInfoPacketData({this.accessibleChannelsData, this.forUser});

  AccessibleChannelsInfoPacketData.fromJson(Map<String, dynamic> json) {
    if (json['accessibleChannelsData'] != null) {
      accessibleChannelsData = new List<BaseChannelData>();
      json['accessibleChannelsData'].forEach((v) {
        accessibleChannelsData.add(new BaseChannelData.fromJson(v));
      });
    }
    forUser = json['forUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessibleChannelsData != null) {
      data['accessibleChannelsData'] =
          this.accessibleChannelsData.map((v) => v.toJson()).toList();
    }
    data['forUser'] = this.forUser;
    return data;
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
    try {
      String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
      return AccessibleChannelsInfoPacketData.fromJson(jsonDecode(jsonString));
    } catch(e) { return null; }
  }

  @override
  void writePacketData(AccessibleChannelsInfoPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }

}