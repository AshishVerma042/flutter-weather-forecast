import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/resources/strings.dart';
import '../controller/splash_screen_controller.dart';
import '../resources/images.dart';
class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    return Scaffold(
      body: Container(
        color: Color.fromARGB(224, 51, 20, 112),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Column(children: [Text(appStrings.w,style: TextStyle(fontSize: 80,fontWeight: FontWeight.bold,color: Colors.blue.shade800),)],),
                Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(appStrings.eather,style: TextStyle(color: Colors.white,fontSize: 25),),
              Text(appStrings.app,style: TextStyle(fontSize: 25,color: Colors.white),)],)],
            ),
            Center(child: Image.asset(appImages.sunRainAngledCloud,height: 200, width: 200,)),

          ],
        ),
      ),

    );
  }
}