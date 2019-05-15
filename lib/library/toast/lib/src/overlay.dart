import 'dart:async';

import 'package:flutter_web/material.dart';

import '../overlay_support.dart';

///progress : from 0 - 1
typedef Widget AnimatedOverlayWidgetBuilder(
    BuildContext context, double progress);

///basic api to show overlay widget
///
///[duration] the overlay display duration , overlay will auto dismiss after [duration]
///if null , will be set to [kNotificationDuration]
///if zero , will not auto dismiss in the future
///
NotificationEntry showOverlay(
  BuildContext context,
  AnimatedOverlayWidgetBuilder builder, {
  Curve curve,
  Duration duration,
}) {
  duration ??= kNotificationDuration;
  final autoDismiss = duration != Duration.zero;

  GlobalKey<AnimatedOverlayState> key = GlobalKey();

  final entry = OverlayEntry(builder: (context) {
    return AnimatedOverlay(
      key: key,
      builder: builder,
      curve: curve,
    );
  });

  NotificationEntry notification = NotificationEntry(entry, key);

  Overlay.of(context).insert(entry);

  if (autoDismiss) {
    Future.delayed(duration + kNotificationSlideDuration).whenComplete(() {
      //ensure entry has been inserted into screen
      WidgetsBinding.instance
          .scheduleFrameCallback((_) => notification.dismiss());
    });
  }
  return notification;
}

class AnimatedOverlay extends StatefulWidget {
  final Duration animationDuration;

  final AnimatedOverlayWidgetBuilder builder;

  final Curve curve;

  AnimatedOverlay(
      {@required Key key,
      Duration animationDuration,
      Curve curve,
      @required this.builder})
      : animationDuration = animationDuration ?? kNotificationSlideDuration,
        curve = curve ?? Curves.easeInOut,
        assert(animationDuration == null || animationDuration >= Duration.zero),
        super(key: key);

  @override
  AnimatedOverlayState createState() => AnimatedOverlayState();
}

class AnimatedOverlayState extends State<AnimatedOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  void show() {
    _controller.forward(from: _controller.value);
  }

  Future hide() {
    final completer = Completer();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        completer.complete();
      }
    });
    _controller.reverse(from: _controller.value);
    return completer.future
        /*set time out more 16 milliseconds (Maybe we don not need this assertion)*/
        /*..timeout(widget.animationDuration + const Duration(milliseconds: 16))*/;
  }

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: widget.animationDuration,
        debugLabel: 'AnimatedOverlayShowHideAnimation');
    super.initState();
    show();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return widget.builder(
              context, widget.curve.transform(_controller.value));
        });
  }
}
