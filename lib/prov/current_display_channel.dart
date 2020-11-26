import 'package:flutter/material.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/models/message_model.dart';
import 'package:zephy_client/models/role_model.dart';

class CurrentDisplayChannel extends ChangeNotifier {
  BaseChannelData baseChannelData;
  List<Role> roles;
  List<PopulatedMessage> messages;

  CurrentDisplayChannel() { reset(); }

  void notify() {
    notifyListeners();
  }

  void reset() {
    baseChannelData = BaseChannelData();
    roles = List<Role>();
    messages = List<PopulatedMessage>();
  }
}