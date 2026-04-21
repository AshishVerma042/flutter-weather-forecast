import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:weatherapp/screen/homePage.dart';

import '../../screen/splash_screen.dart';

class RoutesClass {

  static String splashScreen = '/splashScreen';
  static String homeScreen = '/homeScreen';

  static String gotoSplashScreen() => splashScreen;
  static String gotoHomeScreen() => homeScreen;

  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
       page: () => const SplashScreen(),

      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: homeScreen,
      page: () => const MyHomePage(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}

