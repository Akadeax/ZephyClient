import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/loading/loading.dart';
import 'package:zephy_client/util/layout_builders.dart';

class ErrableLoading extends StatefulWidget {
  final Function() onErrorButtonPress;

  final String errorText;
  final String buttonText;

  final double loadingSize;
  final double singleBallSize;

  final Duration fadeToError = const Duration(milliseconds: 200);
  final Duration fadeFromError = const Duration(milliseconds: 75);

  const ErrableLoading({
    @required Key key,
    @required this.onErrorButtonPress,
    this.errorText = "Failed to locate a server.",
    this.buttonText = "RETRY",
    this.singleBallSize,
    this.loadingSize,
  }) : super(key: key);

  @override
  ErrableLoadingController createState() => ErrableLoadingController();
}

class ErrableLoadingController extends State<ErrableLoading> {
  bool _showError = false;
  bool get showError => _showError;
  set showError(bool newState) {
    setState(() {
      _showError = newState;
    });
  }

  AnimatedCrossFade fadeableLoading({
    @required Widget loading,
    @required Widget error
  }) {
    return AnimatedCrossFade(
      duration: widget.fadeToError,
      reverseDuration: widget.fadeFromError,

      firstChild: loading,
      secondChild: error,

      crossFadeState: showError ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      layoutBuilder: fadeLayoutBuilder,
    );
  }

  @override
  Widget build(BuildContext context) => ErrableLoadingView(this);
}


class ErrableLoadingView extends StatefulWidgetView<ErrableLoading, ErrableLoadingController> {
  ErrableLoadingView(ErrableLoadingController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return controller.fadeableLoading(
      loading: loading(context),
      error: error(context),
    );
  }

  Widget loading(BuildContext context, ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 0,
          child: _loadingCircle(getLoadingColors(context)),
        ),
      ],
    );
  }

  Widget error(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 0,
          child: _loadingCircle(getErrorColors(context)),
        ),
        Positioned(
            top: 125,
            child: Column(
              children: [
                Text(
                  widget.errorText,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  child: Padding(
                    child: Text(widget.buttonText),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                  onPressed: widget.onErrorButtonPress,
                ),
              ],
            )
        ),
      ],
    );
  }

  Widget _loadingCircle(List<Color> colors) {
    return Loading(
      totalSize: widget.loadingSize,
      singleBallSize: widget.singleBallSize,
      colors: colors,
      animationSpeed: 0.6,
    );
  }
}
