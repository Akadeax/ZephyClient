import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/providers/profile_handler.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/providers/server_locator.dart';
import 'package:zephy_client/routes.dart';
import 'package:zephy_client/theme/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  runApp(ZephyApp());
}
GlobalKey<NavigatorState> rootNav = GlobalKey();

class ZephyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ServerLocator>(create: (_) => ServerLocator()),
        Provider<ServerConnection>(create: (_) => ServerConnection()),
        ChangeNotifierProvider<ProfileHandler>(create: (_) => ProfileHandler()),
      ],
      child: MaterialApp(
        navigatorKey: rootNav,
        debugShowCheckedModeBanner: false,
        title: "Zephy",
        themeMode: ThemeMode.dark,
        theme: ZephyLight.theme,
        darkTheme: ZephyDark.theme,
        onGenerateRoute: routeGenerator,
      ),
    );
  }
}
