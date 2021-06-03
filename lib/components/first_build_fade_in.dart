import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:widget_view/widget_view.dart';

class FirstBuildFadeIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration animDuration;

  FirstBuildFadeIn({
    Key key,
    @required this.child,
    this.delay,
    this.animDuration = const Duration(milliseconds: 500)
  }) : super(key: key);

  @override
  _FirstBuildFadeInController createState() => _FirstBuildFadeInController();
}

class _FirstBuildFadeInController extends State<FirstBuildFadeIn> {
  bool loaded = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if(widget.delay == null) {
        loaded = true;
        setState(() {});
      } else {
        Future.delayed(widget.delay, () {
          loaded = true;
          setState(() {});
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _FirstBuildFadeInView(this);
}

class _FirstBuildFadeInView extends StatefulWidgetView<FirstBuildFadeIn, _FirstBuildFadeInController> {
  const _FirstBuildFadeInView(_FirstBuildFadeInController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      curve: Curves.easeInQuad,
      duration: widget.animDuration,
      opacity: controller.loaded ? 1 : 0,
      child: widget.child,
    );
  }
}