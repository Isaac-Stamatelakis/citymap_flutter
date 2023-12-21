import 'package:flutter/material.dart';

class Helper {
  static Size getDeviceSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  
}