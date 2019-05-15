import 'package:annotation_route/route.dart';
import 'package:flutter_dynamic_web/constants/page_constants.dart';
import 'package:flutter_dynamic_web/router/route.dart';
import 'package:flutter_web/material.dart';

@ARoute(url: PageConstants.AddNewProjectPage)
class AddNewProjectPage extends StatefulWidget {
  final RouteOption option;

  AddNewProjectPage(this.option);

  @override
  _AddNewProjectPageState createState() => _AddNewProjectPageState();
}

class _AddNewProjectPageState extends State<AddNewProjectPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
