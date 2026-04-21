import 'dart:async';
import 'package:get/get.dart';
import 'package:weatherapp/resources/routes/routes.dart';

class SplashScreenController extends GetxController{

  @override
  void onInit() {
    Timer(Duration(seconds:3 ), (){
      Get.offAllNamed(RoutesClass.homeScreen);
    });
    super.onInit();
  }
}
