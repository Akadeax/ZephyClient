import 'dart:convert';

import '../packet.dart';

class RequestAccessibleChannelsInfoPacketData {
  String forUser;

  RequestAccessibleChannelsInfoPacketData({this.forUser});

  RequestAccessibleChannelsInfoPacketData.fromJson(Map<String, dynamic> json) {
    forUser = json['forUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forUser'] = this.forUser;
    return data;
  }
}

class RequestAccessibleChannelsInfoPacket extends Packet<RequestAccessibleChannelsInfoPacketData> {
  static const int TYPE = 3000;
  RequestAccessibleChannelsInfoPacket(RequestAccessibleChannelsInfoPacketData data) : super(TYPE) {
    writePacketData(data);
  }

  RequestAccessibleChannelsInfoPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  RequestAccessibleChannelsInfoPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return RequestAccessibleChannelsInfoPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(RequestAccessibleChannelsInfoPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }

}