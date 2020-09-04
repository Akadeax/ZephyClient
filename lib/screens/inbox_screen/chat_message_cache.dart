import 'dart:async';

import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/models/message_model.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'package:zephy_client/screens/inbox_screen/chat_display.dart';
import 'package:zephy_client/services/server_connection.dart';

class ChatMessageCache {
  final ServerConnection _conn;
  final BaseChannelData _channelData;

  final ChatDisplayState _chatDisplay;

  ChatMessageCache(this._chatDisplay, this._conn, this._channelData) {
    print("---\"${_channelData.sId}\"---");
  }

  int _nextPageToLoad = 0;

  List<PopulatedMessage> currentDisplayMessages = new List<PopulatedMessage>();

  Future<void> loadNextPage() async {
    var fetchedPage = await _fetchMessages(_nextPageToLoad);

    if(fetchedPage != null && fetchedPage.isNotEmpty) {
      _nextPageToLoad++;
      currentDisplayMessages.addAll(fetchedPage);

      _chatDisplay.updateDisplay();
    }
  }

  Future<List<PopulatedMessage>> _fetchMessages(int page) async {
    PopulateMessagesPacket packet = PopulateMessagesPacket(PopulateMessagesPacketData(
      forChannel: _channelData.sId,
      page: page
    ));
    _conn.sendPacket(packet);

    PopulateMessagesPacket recvPacket = await _conn.waitForPacket<PopulateMessagesPacket>((buffer) => PopulateMessagesPacket.fromBuffer(buffer));
    PopulateMessagesPacketData data = recvPacket.readPacketData();
    if(data == null) return null;

    return data.populatedMessages;
  }

  void dispose() {}
}
