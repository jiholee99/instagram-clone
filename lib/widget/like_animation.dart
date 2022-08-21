import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEndCallBack;
  final bool smallLike;
  const LikeAnimation({
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEndCallBack,
    this.smallLike = false,
  });

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    // TODO: implement initState

    //Initialize controller and animation
    // divide duration because it is being used two times : forward() and reverse()
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2));
    scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(controller);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget

    // meaning isAnimating is changed
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  startAnimation() async {
    // if it's small like then it runs everytime cuz userId might be in the likes or not.
    if (widget.isAnimating || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(
        const Duration(milliseconds: 200),
      );

      // Animation is completed
      if (widget.onEndCallBack != null) {
        widget.onEndCallBack!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: widget.child,
    );
  }
}
