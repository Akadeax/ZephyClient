import 'package:flutter/material.dart';

class ChatNav {
  GlobalKey<NavigatorState> _key;

  ChatNav(this._key);

  GlobalKey<NavigatorState> get key => _key;
  NavigatorState get currentState => _key.currentState;
}