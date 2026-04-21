
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/resources/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Application',
      getPages: RoutesClass.routes,
      initialRoute: RoutesClass.splashScreen,
    );
  }
}
