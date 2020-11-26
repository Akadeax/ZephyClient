import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/prov/chat_nav.dart';
import 'package:zephy_client/prov/current_display_channel.dart';

class InboxScreenLogic {
  GlobalKey<NavigatorState> chatNavKey = GlobalKey();
  CurrentDisplayChannel currentDisplayChannel = CurrentDisplayChannel();
  Navigator chatDisplayNav() {
    return Navigator(
      key: chatNavKey,
      initialRoute: null,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (_) => Container()
        );
      },
    );
  }

  MultiProvider providers({@required Widget child}) {
    return MultiProvider(
      providers: [
        _chatNavProv(),
        _currentDisplayChannelProv(),
      ],
      child: child,
    );
  }

  Provider<ChatNav> _chatNavProv() {
    return Provider<ChatNav>(create: (_) => ChatNav(this.chatNavKey));
  }

  ChangeNotifierProvider _currentDisplayChannelProv() {
    return ChangeNotifierProvider<CurrentDisplayChannel>.value(value: currentDisplayChannel);
  }
}