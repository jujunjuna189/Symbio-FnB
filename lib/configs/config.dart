import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Config {
  static String appDate = '2023-01-01';
  static void easyLoading() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.transparent
      ..boxShadow = []
      ..textColor = Colors.white
      ..indicatorColor = Colors.transparent
      ..maskType = EasyLoadingMaskType.black
      ..indicatorColor = Colors.amberAccent
      ..indicatorType = EasyLoadingIndicatorType.circle;
  }
}
