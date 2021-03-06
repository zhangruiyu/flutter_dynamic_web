import 'dart:async';

import 'package:flutter_dynamic_web/constants/page_constants.dart';
import 'package:flutter_dynamic_web/router/route.dart';
import 'package:flutter_web/material.dart';

class NavigatorHelper {
  static popToMain(BuildContext context) {
    Navigator.popUntil(context, (Route<dynamic> route) {
      return route.settings.name == PageConstants.MainPage;
    });
  }

  static popToMainByIndex(BuildContext context, int index) {
    popToMain(context);
//    MainPage.bottomNavigationKey?.currentState?.setNewState(index);
  }

  static OverlayEntry _overlayEntry;

  //是否显示load的dialog
  static showLoadingDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      //获取OverlayState
      OverlayState overlayState = Overlay.of(context);
      //创建OverlayEntry
      _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Container(
                alignment: Alignment.center,
                child: new CircularProgressIndicator(
                  strokeWidth: 4.0,
                  backgroundColor: Colors.blue,
                  // value: 0.2,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                ),
                color: Colors.black38,
              ));
      //显示到屏幕上。
      overlayState.insert(_overlayEntry);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  static Future<T> pushPage<T>(BuildContext context, String pageUrl,
      [Map<String, dynamic> params]) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return AppRoute.getPage(pageUrl, query: params);
        },
        settings: RouteSettings(name: pageUrl)));
  }

  static Future<T> pushReplacement<T>(BuildContext context, String pageUrl,
      {Map<String, dynamic> query}) async {
    return Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return AppRoute.getPage(pageUrl, query: query);
        },
        settings: RouteSettings(name: pageUrl)));
  }
}
