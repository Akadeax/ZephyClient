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

  Timer _updateTimer;
  ChatMessageCache(this._chatDisplay, this._conn, this._channelData) {
    print("---\"${_channelData.sId}\"---");
    _updateTimer = Timer.periodic(Duration(seconds: 1), (t) => _getMissedMessages());
  }

  int _nextPageToLoad = 0;

  List<PopulatedMessage> currentDisplayMessages = new List<PopulatedMessage>();

  Future<void> loadNextPage() async {
    var fetchedPage = await _fetchMessages(_nextPageToLoad);

    if(fetchedPage.isNotEmpty) {
      _nextPageToLoad++;
      currentDisplayMessages.insertAll(0, fetchedPage.reversed);

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

    return data.populatedMessages;
  }

  void _getMissedMessages() async {
    
  }

  void dispose() {
    _updateTimer?.cancel();
  }
}
