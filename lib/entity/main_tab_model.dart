import 'package:flutter_web/material.dart';
import 'package:flutter_web_ui/ui.dart';

class MainTabModel {
  String title;
  Color color;
  Null Function(BuildContext buildContext) click;

  MainTabModel(this.title, this.color, this.click);
}
