import 'package:annotation_route/route.dart';
import 'package:flutter_dynamic_web/constants/page_constants.dart';
import 'package:flutter_dynamic_web/entity/add_new_entity.dart';
import 'package:flutter_dynamic_web/net/network.dart';
import 'package:flutter_dynamic_web/router/route.dart';
import 'package:flutter_dynamic_web/utils/window_utils.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

@ARoute(url: PageConstants.AddNewPage)
class AddNewPage extends StatefulWidget {
  final RouteOption option;

  AddNewPage(this.option);

  @override
  _AddNewPageState createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  var pageNameTextEditingController = TextEditingController();
  var pagedDescriptionTextEditingController = TextEditingController();
  var androidMinVersionEditingController = TextEditingController();
  var androidMaxVersionEditingController = TextEditingController();

  var iOSMinVersionEditingController = TextEditingController();
  var iOSMaxVersionEditingController = TextEditingController();

  //flutter控件的模板
  var flutterTemplateEditingController = TextEditingController();

  //flutter控件生成的json模板
  var flutterJsonTemplateEditingController = TextEditingController();
  var isAllVersionUpdateCheck = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加新页面"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 128.0, right: 128.0, top: 48.0),
          child: ListView(
            children: <Widget>[
              Container(
                width: 200.0,
                child: TextField(
                  controller: pageNameTextEditingController,
                  decoration: InputDecoration(
                    labelText: "页面名称(请使用英文)",
                  ),
                ),
              ),
              Container(
                width: 200.0,
                child: TextField(
                  controller: pagedDescriptionTextEditingController,
                  decoration: InputDecoration(
                    labelText: "描述(用于后续修改时鉴别版本)",
                  ),
                ),
              ),
              SwitchListTile(
                onChanged: (bool value) {
                  setState(() {
                    isAllVersionUpdateCheck = value;
                  });
                },
                value: isAllVersionUpdateCheck,
                title: Text(
                  "是否所有版本都更新",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              isAllVersionUpdateCheck ? null : buildVersionWidget(),
              /* TextFormField(
                controller: pageNameTextEditingController,
                decoration: InputDecoration(
                  labelText: "页面名称(请使用英文)",
                ),
                maxLength: 30,
              ),*/
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: new TextField(
                  buildCounter: (BuildContext context,
                          {int currentLength, int maxLength, bool isFocused}) =>
                      null,
                  controller: flutterTemplateEditingController,
                  decoration: new InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "flutter模板文件",
                  ),
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: WindowUtils.getScreenWidth() / 5,
                    vertical: 30.0),
                child: RaisedButton(
                  onPressed: () {
                    Network.request<AddNewEntity>(context, "/template/build",
                            queryParameters: {
                              'flutterWidgetBuild':
                                  flutterTemplateEditingController.text
                            },
                            showLoadingIndicator: true)
                        .then((onValue) {
                      setState(() {
                        flutterJsonTemplateEditingController.text =
                            onValue.data;
                      });
                    });
                  },
                  color: Theme.of(context).accentColor,
                  child: Text(
                    "生成可解析的json模板(此操作可能花费数10秒时间,请勿重复点击)",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              new TextField(
                buildCounter: (BuildContext context,
                        {int currentLength, int maxLength, bool isFocused}) =>
                    null,
                controller: flutterJsonTemplateEditingController,
                decoration: new InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "生成客户端可解析的json",
                ),
                maxLines: 2,
              ),
            ].where((obj) => obj != null).toList(),
          )),
    );
  }

  Container buildVersionWidget() {
    var info = [
      {
        "title": "Android设置",
        "min": androidMinVersionEditingController,
        "max": androidMaxVersionEditingController
      },
      {
        "title": "iOS设置",
        "min": iOSMinVersionEditingController,
        "max": iOSMaxVersionEditingController
      },
    ];
    return Container(
      height: 200.0,
      child: Row(
        children: info.map((itemInfo) {
          return Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  itemInfo["title"],
                  style: TextStyle(fontSize: 15.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 38.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          width: 100.0,
                          child: new TextField(
                            buildCounter: (BuildContext context,
                                    {int currentLength,
                                    int maxLength,
                                    bool isFocused}) =>
                                null,
                            controller: itemInfo["min"],
                            decoration: new InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "最低版本",
                            ),
                            maxLines: 1,
                            maxLength: 5,
                          )),
                      Text("  至  "),
                      new Container(
                          width: 100.0,
                          child: new TextField(
                            buildCounter: (BuildContext context,
                                    {int currentLength,
                                    int maxLength,
                                    bool isFocused}) =>
                                null,
                            controller: itemInfo["max"],
                            decoration: new InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "最高版本",
                            ),
                            maxLines: 1,
                            maxLength: 5,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    pageNameTextEditingController.dispose();
    super.dispose();
  }
}
