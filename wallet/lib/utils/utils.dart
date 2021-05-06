import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wallet/model/category.dart';
import 'package:wallet/model/info_of_month.dart';
import 'package:wallet/page/home_screen/home_screen_controller.dart';

class Utils {
  static final Utils _singleton = Utils._internal();

  Utils._internal();

  factory Utils() {
    return _singleton;
  }

  showPopupErrorMessage({String message}) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    Get.dialog(Center(child: alert), barrierDismissible: false);
  }

  showLoading() {
    Get.dialog(Center(child: CircularProgressIndicator()),
        barrierDismissible: false);
  }

  String getAuth() {
    String username = 'naruto';
    String password = 'bvM9pmEEQ7tfPZdC';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return basicAuth;
  }

  String getCurrentDate() {
    var df = DateFormat("dd-MM-yyyy hh:mm");
    String dateTime = df.format(DateTime.now());
    return dateTime;
  }

  String getMonth() {
    if (InfoOfMonth.currentInfoOfMonth != null &&
        InfoOfMonth.currentInfoOfMonth.month.isNotEmpty) {
      Get.find<HomeScreenController>().month.value =
          InfoOfMonth.currentInfoOfMonth.month;
      print(
          "getMonth currentInfoOfMonth::::::::::::${InfoOfMonth.currentInfoOfMonth.month}");
      return InfoOfMonth.currentInfoOfMonth.month;
    }
    var df = DateFormat("MM-yyyy");
    String dateTime = df.format(DateTime.now());
    Get.find<HomeScreenController>().month.value = dateTime;
    print("getMonth dateTime::::::::::::$dateTime");
    return dateTime;
  }

  String getDayWithString(String value) {
    var df = DateFormat("dd-MM-yyyy hh:mm");
    DateTime dateTime = df.parse(value);
    var df2 = DateFormat("dd");
    String dateTime2 = df2.format(dateTime);
    return dateTime2;
  }

  String formatMoneyWithString(String value) {
    final oCcy = new NumberFormat("#,###", "en_US");
    return oCcy.format(value);
  }

  String formatMoneyWithInt(int value) {
    final oCcy = new NumberFormat("#,###", "en_US");
    return oCcy.format(value);
  }

  List<String> getListNameCategory() {
    List<String> _listNameCategory = <String>[];
    for (Category category in InfoOfMonth.currentInfoOfMonth.category) {
      _listNameCategory.add(category.name);
    }

    return _listNameCategory;
  }

  bool isCurrentDate() {
    var df = DateFormat("MM-yyyy");
    String dateTime = df.format(DateTime.now());
    print(
        "dateTime:::::::$dateTime --- getMonth::::::${Get.find<HomeScreenController>().month.value}");
    if (dateTime != Get.find<HomeScreenController>().month.value) return false;

    return true;
  }
}
