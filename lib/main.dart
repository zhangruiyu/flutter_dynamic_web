import 'package:flutter_dynamic_web/constants/page_constants.dart';
import 'package:flutter_dynamic_web/utils/window_utils.dart';
import 'package:flutter_web/material.dart';
import 'package:js/js.dart';

import 'entity/main_tab_model.dart';
import 'helper/navigator_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '源梦flutter应用动态更新管理中心'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  List<MainTabModel> tabContent = [
    MainTabModel("发布新页面补丁", Colors.red, (BuildContext buildContext) {
      NavigatorHelper.pushPage(buildContext, PageConstants.AddNewPage);
    }),
    MainTabModel("管理页面补丁", Colors.green, (BuildContext buildContext) {
      NavigatorHelper.pushPage(buildContext, PageConstants.AddNewPage);
    }),
    MainTabModel("人员管理", Colors.amber, (BuildContext buildContext) {}),
    MainTabModel("设置", Colors.lightBlue, (BuildContext buildContext) {})
  ];

  @override
  Widget build(BuildContext context) {
//    Dio().post("");
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton(
                onSelected: (int id) {
                  if (id == -1) {
                    NavigatorHelper.pushPage(
                        context, PageConstants.AddNewProjectPage);
                  }
                },
                icon: Icon(Icons.add_a_photo),
                itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                      new PopupMenuItem(value: 1, child: new Text("添加新项目")),
                      new PopupMenuItem(value: -1, child: new Text("添加新项目"))
                    ])
          ],
        ),
        body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return buildContent(context);
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return Center(
                child: Text(
                  "默认状态",
                ),
              );
            }
          },
        ));
  }

  Widget buildContent(context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Row(
        children: tabContent.map((MainTabModel mainTabEntity) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(38.0),
              child: SizedBox(
                height: 200.0,
                child: RaisedButton(
                  color: mainTabEntity.color,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    mainTabEntity.title,
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                  onPressed: () {
                    mainTabEntity.click(context);
                  },
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
