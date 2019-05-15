import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter_dynamic_web/helper/navigator_helper.dart';
import 'package:flutter_dynamic_web/helper/user_helper.dart';
import 'package:flutter_dynamic_web/utils/toast_utils.dart';
import 'package:flutter_web/material.dart';

import '../entity_factory.dart';
import 'NetException.dart';

class Network {
  static Future<T> request<T>(
    BuildContext context,
    String url, {
    Map<String, dynamic> queryParameters,
    bool isPost = true,
    bool showLoadingIndicator = false,
    String contentType = "application/x-www-form-urlencoded",
  }) async {
    try {
//    var host = Platform.isAndroid ? '192.168.31.150:8080' : 'localhost:8080';
      if (showLoadingIndicator) {
        NavigatorHelper.showLoadingDialog(context, true);
      }
      var newQueryParameters =
          queryParameters?.map((String key, dynamic value) {
        return new MapEntry<String, String>(
            key, value != null ? value.toString() : "");
      });

      http.Response response = await http.post("http://localhost:8081$url",
          body: newQueryParameters);
      debugPrint("NetWork:request");
      var responseBody = response.body;
      Map<String, String> headers = {};
//    headers['content_type'] = 'application/json';

      if (showLoadingIndicator) {
        NavigatorHelper.showLoadingDialog(context, false);
      }
      debugPrint("NetWork:====================START====================");
      debugPrint("NetWork:" + url.toString());
      debugPrint("NetWork:" + '请求方式:${isPost ? 'Post' : 'GET'}');
      debugPrint("NetWork:" + headers.toString());
      debugPrint("NetWork:" + newQueryParameters.toString());
      debugPrint("NetWork:" + responseBody.toString());
      debugPrint("NetWork:====================END====================");
      if (response.statusCode == HttpStatus.ok) {
        debugPrint("NetWork:====================END222====================");
//      var jsonSource = await response.transform(utf8.decoder).join();
        var data = json.decode(responseBody);
        debugPrint("NetWork:====================END3====================");
        if (data['status'].toString() == '0') {
          debugPrint("NetWork:====================END4====================");
          return new Future.value(EntityFactory.generateOBJ<T>(data));
        } else {
          /* if (data['status'].toString() == '1001') {
            UserHelper.loginOut(context);
          }*/
          /*   if (!interceptCode.contains(data['ret_code'].toString())) {
            ToastUtils.showToast(context, data['ret_msg']);
          }*/
          return Future.error(
              new NetException(data['status'], data['ret_msg'], data['data']));
        }
      } else {
        debugPrint(
            'Error getting IP address:\nHttp status ${response.statusCode}');
        ToastUtils.showToast(
            context, "网络请求失败 statusCode : ${response.statusCode}");
        return Future.error(
            new NetException(response.statusCode, response.toString()));
      }
    } catch (e) {
      if (showLoadingIndicator) {
        NavigatorHelper.showLoadingDialog(context, false);
      }
      ToastUtils.showToast(context, "网络请求失败$e");
      return Future.error(new NetException(100000, "网络请求失败"));
    }
  }
}
