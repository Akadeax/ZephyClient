import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class FetchUserListRequestPacketData extends PacketData {
  String search;
  int page;
  List<String> optionalExcludeIds;

  FetchUserListRequestPacketData({this.search, this.page, this.optionalExcludeIds});

  FetchUserListRequestPacketData.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    page = json['page'];
    optionalExcludeIds = json['optionalExcludeIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['page'] = this.page;
    data['optionalExcludeIds'] = this.optionalExcludeIds;
    return data;
  }
}

class FetchUserListRequestPacket extends Packet<FetchUserListRequestPacketData> {
  static const int TYPE = 5001;
  FetchUserListRequestPacket(FetchUserListRequestPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  FetchUserListRequestPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  FetchUserListRequestPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return FetchUserListRequestPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(FetchUserListRequestPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}