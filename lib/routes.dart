import 'package:flutter/material.dart';
import 'package:zephy_client/screens/connection_screen/connection_screen.dart';
import 'package:zephy_client/screens/fatal_error_screen/fatal_error_screen.dart';

final Map<String, WidgetBuilder> routes = {
  "/fatal": (BuildContext context) => FatalErrorScreen(),
  "/connect": (BuildContext context) => ConnectionScreen(),
};

