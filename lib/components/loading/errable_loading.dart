import 'package:flutter/material.dart';
import 'package:zephy_client/components/loading/loading.dart';
import 'package:zephy_client/util/controller_view.dart';
import 'package:zephy_client/util/layout_builders.dart';

class ErrableLoading extends StatefulWidget {
  final double width;
  final double height;
  final Function() onButtonPress;

  final String errorText;
  final String buttonText;

  final double loadingSize;
  final double singleBallSize;

  final Duration fadeToError = const Duration(milliseconds: 200);
  final Duration fadeFromError = const Duration(milliseconds: 75);

  const ErrableLoading({
    @required Key key,
    this.width = 500,
    this.height = 300,
    @required this.onButtonPress,
    this.errorText = "An error has occured.",
    this.buttonText = "Retry",
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


class ErrableLoadingView extends WidgetView<ErrableLoading, ErrableLoadingController> {
  ErrableLoadingView(ErrableLoadingController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return state.fadeableLoading(
      loading: loading(context),
      error: error(context),
    );
  }

  Widget loading(BuildContext context, [List<Color> colors]) {
    return Loading(
        totalSize: widget.loadingSize,
        singleBallSize: widget.singleBallSize,
        colors: colors == null ? getLoadingColors(context) : colors,
    );
  }

  Widget error(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          loading(context, getErrorColors(context)),
          Positioned(
              bottom: 0,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Text(
                    widget.errorText,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 15),
                  TextButton(
                    child: Text(widget.buttonText),
                    onPressed: widget.onButtonPress,
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}
