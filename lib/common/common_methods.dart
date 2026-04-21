import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get/get.dart';

import '../appColors.dart';


class CommonMethods {
  static String version = "";
  static Future<bool> checkInternetConnectivity() async {
    //String connectionStatus;
    bool isConnected = await InternetConnectionChecker.createInstance().hasConnection;
/*    final Connectivity _connectivity = Connectivity();

    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
      if (await _connectivity.checkConnectivity() ==
          ConnectivityResult.mobile) {
        print("===internetconnected==Mobile" + connectionStatus);
        isConnected = true;
        // I am connected to a mobile network.
      } else if (await _connectivity.checkConnectivity() ==
          ConnectivityResult.wifi) {
        isConnected = true;
        print("===internetconnected==wifi" + connectionStatus);
        // I am connected to a wifi network.
      } else if (await _connectivity.checkConnectivity() ==
          ConnectivityResult.none) {
        isConnected = false;
        print("===internetconnected==not" + connectionStatus);
      }
    } on PlatformException catch (e) {
      print("===internet==not connected" + e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }*/
    return isConnected;
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  static void moveCursorToastPos(TextEditingController textField) {
    var cursorPos =
    TextSelection.fromPosition(TextPosition(offset: textField.text.length));
    textField.selection = cursorPos;
  }

  static void showError({required String title, required String message,int time=3}) {
    Get.snackbar(
      '',
      '',
      titleText: Container(
        margin: const EdgeInsets.only(top:22.0),
        child: Center(
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  message,
                  style:  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 36.0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      duration: Duration(seconds: time),
      animationDuration: const Duration(milliseconds: 700),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }

  static void showToast(String message,{time=3}) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
        overlayColor: Colors.black54,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        borderRadius: 12,
        margin: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 36.0),
        duration:Duration(seconds: time),
        animationDuration: const Duration(milliseconds: 700),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInCubic,
      ),
    );
  }

  static void showToastSuccess(String message) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: Row(
          children: [
            const Icon(Icons.check_circle_rounded,size: 23,color: Colors.white,),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
        overlayColor: Colors.black54,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        borderRadius: 12,
        margin: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 36.0),
        duration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 700),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInCubic,
      ),
    );
  }

  static void showProgress() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
      barrierDismissible: false,
      useSafeArea: true,
    );
  }

  static void inputFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  bool isConnect = false;
}

