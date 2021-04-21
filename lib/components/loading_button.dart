import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';

class LoadingButton extends StatefulWidget {

  final Function() onPressed;
  final Widget child;

  const LoadingButton({
    @required Key key,
    @required this.onPressed,
    @required this.child,
  }) : super(key: key);

  @override
  LoadingButtonController createState() => LoadingButtonController();
}

class LoadingButtonController extends State<LoadingButton> {

  bool _isDisabled = false;
  bool get isDisabled => _isDisabled;
  set isDisabled(newVal) {
    setState(() {
      _isDisabled = newVal;
    });
  }

  @override
  Widget build(BuildContext context) => _LoadingButtonView(this);
}

class _LoadingButtonView extends StatefulWidgetView<LoadingButton, LoadingButtonController> {
  _LoadingButtonView(LoadingButtonController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(child: widget.child, padding: EdgeInsets.all(10)),
      onPressed: controller.isDisabled ? null : widget.onPressed,
    );
  }
}
