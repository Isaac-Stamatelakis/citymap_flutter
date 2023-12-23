import 'package:flutter/material.dart';

class Helper {
  static Size getDeviceSize(BuildContext context) {
    return MediaQuery.of(context).size;
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