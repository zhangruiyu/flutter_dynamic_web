import 'package:annotation_route/route.dart';
import 'package:flutter_web/material.dart';
import './route.internal.dart';

@ARouteRoot()
class RouteOption {
  String urlpattern;
  Map<String, dynamic> query;

  RouteOption(this.urlpattern, this.query);

  //重写[] 快速取值 返回强制string
  operator [](String key) => (query[key].toString());

  int getInt(String key) {
    return int.parse(query[key]);
  }

  double getDouble(String key) {
    return double.parse(query[key]);
  }

  @override
  String toString() {
    return 'RouteOption{urlpattern: $urlpattern, query: $query}';
  }
}

class AppRoute {
  static Widget getPage(String urlString, {Map<String, dynamic> query}) {
    ARouterInternalImpl internal = ARouterInternalImpl();
    ARouterResult routeResult = internal.findPage(
        ARouteOption(urlString, query), RouteOption(urlString, query));
    if (routeResult.state == ARouterResultState.FOUND) {
      return routeResult.widget;
    }
    return Scaffold(
      // 返回的是未匹配路径的控件
      appBar: AppBar(),
      body: Center(
        child: Text('NOT FOUND'),
      ),
    );
  }
}
