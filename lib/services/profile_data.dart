import 'package:flutter/foundation.dart';
import 'package:zephy_client/models/user_model.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';
import 'package:zephy_client/services/server_connection.dart';

class ProfileData with ChangeNotifier {
  PopulatedUser _loggedInUser;

  PopulatedUser get loggedInUser
      => _loggedInUser;

  set loggedInUser(PopulatedUser newUser) {
    _loggedInUser = newUser;
    notifyListeners();
  }

  Future<AccessibleChannelsInfoPacketData> fetchAccessibleChannels(ServerConnection conn) async {
    var packet = AccessibleChannelsInfoPacket(AccessibleChannelsInfoPacketData(
        forUser: loggedInUser.sId
    ));
    conn.sendPacket(packet);

    var recvPacket = await conn.waitForPacket<AccessibleChannelsInfoPacket>(
            (buffer) => AccessibleChannelsInfoPacket.fromBuffer(buffer)
    );
    return recvPacket.readPacketData();
  }
}
