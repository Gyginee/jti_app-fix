import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Utility {
  static const chanel = MethodChannel("ConnectSwift");

  static Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static void errorInterner() {
    Fluttertoast.showToast(
      msg: 'Kết nối của bạn không ổn định, vui lòng kiểm tra lại',
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
    return;
  }
}
