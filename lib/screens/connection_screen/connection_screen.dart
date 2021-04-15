import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/components/loading/errable_loading.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/providers/server_locator.dart';
import 'package:zephy_client/util/controller_view.dart';

class ConnectionScreen extends StatefulWidget {
  @override
  _ConnectionScreenController createState() => _ConnectionScreenController();
}

class _ConnectionScreenController extends State<ConnectionScreen> {
  @override
  Widget build(BuildContext context) => _ConnectionScreenView(this);

  ServerLocator locator;
  Future currentLocateFuture;

  GlobalKey<ErrableLoadingController> loadingKey = GlobalKey();

  @override
  void initState() {
    locator = Provider.of<ServerLocator>(context, listen: false);
    currentLocateFuture = locator.locate();
    super.initState();
  }

  FutureBuilder locateBuilder({
    @required BuildContext context,
    @required ErrableLoading loading,
  }) {
    return FutureBuilder(
        future: currentLocateFuture,
        builder: (builderCtx, snapshot) {
          bool dataIsValid = !snapshot.hasError && snapshot.data != null;
          bool isLoading = snapshot.connectionState == ConnectionState.waiting;

          // Server Location was successful
          if (dataIsValid && !isLoading) {
            // TODO: transition to login screen together with snapshot.data
          }

          bool shouldShowError = !dataIsValid && !isLoading;

          if(loadingKey.currentState != null)
            loadingKey.currentState.showError = shouldShowError;

          return loading;
        }
    );
  }

  void retryButton() {
    currentLocateFuture = locator.locate();
    setState(() {});
  }
}


class _ConnectionScreenView extends WidgetView<ConnectionScreen, _ConnectionScreenController> {
  _ConnectionScreenView(_ConnectionScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
          child: state.locateBuilder(
            context: context,
            loading: ErrableLoading(
              key: state.loadingKey,
              onButtonPress: state.retryButton,

              singleBallSize: 25,
              loadingSize: 85,

              height: 300,
            ),
          ),
        )
    );
  }
}
