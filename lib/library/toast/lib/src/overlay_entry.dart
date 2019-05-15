import 'package:flutter_web/widgets.dart';

import '../overlay_support.dart';

class NotificationEntry {
  final OverlayEntry _entry;
  final GlobalKey<AnimatedOverlayState> _key;

  NotificationEntry(this._entry, this._key);

  bool _dismissed = false;

  ///dismiss notification
  void dismiss({bool animate = true}) {
    if (_dismissed) {
      return;
    }
    _dismissed = true;
    if (!animate) {
      _entry.remove();
      return;
    }
    _key.currentState.hide().whenComplete(() {
      _entry.remove();
    });
  }
}
