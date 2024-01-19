import 'package:flutter/material.dart';

class Likeanimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duratrion;
  final VoidCallback? onEnd;
  final bool smallLike;
  const Likeanimation({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.onEnd,
    this.duratrion = const Duration(milliseconds: 150),
    this.smallLike = false,
  }) : super(key: key);

  @override
  State<Likeanimation> createState() => _LikeanimationState();
}

class _LikeanimationState extends State<Likeanimation>
    with SingleTickerProviderStateMixin {
  late AnimationController anicontroller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    anicontroller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duratrion.inMilliseconds ~/ 2),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(anicontroller);
  }

  @override
  void didUpdateWidget(covariant Likeanimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await anicontroller.forward();
      await anicontroller.reverse();
      await Future.delayed(
        const Duration(milliseconds: 200),
      );
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    anicontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
