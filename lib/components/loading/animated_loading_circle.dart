import 'package:flutter/material.dart';
import 'package:zephy_client/util/list_util.dart';


List<Color> loadingColor = [];
List<Color> errorColor = [];

// convert list of colors to an animatable color series
List<TweenSequenceItem<Color>> rotatingColor([List<Color> colors]) {
  if(colors == null) colors = [Colors.black, Colors.black, Colors.black];

  List<TweenSequenceItem<Color>> newList = [];
  // adds a transition from current color to next etc
  // to get fluid transition between all in list
  for(int i = 0; i < colors.length; i++) {
    Color secondCol = i + 1 < colors.length ? colors[i + 1] : colors[0];
    newList.add(TweenSequenceItem(tween: ColorTween(begin: colors[i], end: secondCol), weight: 1.0));
  }
  return newList;
}

class AnimatedLoadingCircle extends StatefulWidget {
  final int offset;
  final List<Color> colors;
  final double singleBallSize;

  AnimatedLoadingCircle({Key key, @required this.offset, this.colors, this.singleBallSize = 30}) : super(key: key);

  @override
  AnimatedLoadingCircleState createState() => AnimatedLoadingCircleState();
}


class AnimatedLoadingCircleState extends State<AnimatedLoadingCircle> with SingleTickerProviderStateMixin  {
  AnimationController _controller;
  Animation<Color> _colorAnim;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward()..repeat();

    _colorAnim = TweenSequence<Color>(rotate(rotatingColor(widget.colors), widget.offset)).animate(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, _) {
        return Container(
          width: widget.singleBallSize,
          height: widget.singleBallSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _colorAnim.value,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
