import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:doca_project/component/routeGlobal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My App',
      initialRoute: RouteName.login,
      getPages: getPages,
      debugShowCheckedModeBanner: false,
    );
  }
}
