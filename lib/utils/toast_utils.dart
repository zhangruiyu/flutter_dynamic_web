import 'package:flutter_dynamic_web/library/toast/lib/src/toast/overlay_toast.dart';
import 'package:flutter_web/material.dart';

class ToastUtils {
  static void showToast(BuildContext context, String toastMsg) {
    toast(context, toastMsg);
  }
}
