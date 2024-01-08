import 'package:flutter/material.dart';
import 'dart:math';


class GlobalHelper {
  static Size getDeviceSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getPreferredWidth(BuildContext context) {
    return max(500, MediaQuery.of(context).size.width/2);
  }

  static Widget commonFutureBuilder(Future future, Function generator){
    return FutureBuilder(
      future: future, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          
          return generator(snapshot);
        }
      }
    );
  }
  
}