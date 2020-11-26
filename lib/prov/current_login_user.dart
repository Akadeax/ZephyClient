import 'package:flutter/material.dart';
import 'package:zephy_client/models/user_model.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';

class CurrentLoginUser extends ChangeNotifier {
  PopulatedUser _user;

  PopulatedUser get user => _user;

  void setUser(PopulatedUser newUser, [bool shouldNotifyListeners = true]) {
    _user = newUser;
    if(shouldNotifyListeners) notifyListeners();
  }

  Stream<AccessibleChannelsInfoPacket> _stream;
  /// get all the data of the channels that 'loggedInUser' has access to in accordance with his roles.
  Stream<AccessibleChannelsInfoPacket> accessibleChannelsStream(ServerConnection conn) {
    _stream = conn.packetHandler.packetStream<AccessibleChannelsInfoPacket>(
      AccessibleChannelsInfoPacket.TYPE,
      (buffer) => AccessibleChannelsInfoPacket.fromBuffer(buffer)
    );
    return _stream;
  }
}