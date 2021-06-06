import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wallet/model/category.dart';
import 'package:wallet/model/expense.dart';
import 'package:wallet/model/info_of_month.dart';
import 'package:wallet/page/home_screen/home_screen_controller.dart';

class FireBaseDatabaseManager {
  final _databaseReference = FirebaseDatabase.instance.reference();
  String listHostId = "";
  bool isClearData = false;
  static final FireBaseDatabaseManager _singleton =
      FireBaseDatabaseManager._internal();

  factory FireBaseDatabaseManager() {
    return _singleton;
  }

  FireBaseDatabaseManager._internal();

  get databaseReference => _databaseReference;

  loadDataWithMonth(String month) {
    _getLastInfoOfMonth(month);
  }

  _loadDataWithMonth(String month) {
    print("loadDataWithMonth ne::::::::$month");
    databaseReference.child(month).once().then((DataSnapshot snapshot) async {
      String value = json.encode(snapshot.value);
      print("value ne::::::::$value");
      if (value == "null") {
        Get.find<HomeScreenController>().setExpense(0);
        return;
      }
      _listenerExpense(month);
    });
  }

  _calculateExpense(dynamic value) {
    if (value == "null") return;

    Get.find<HomeScreenController>().totalAmountExpenseOfMonth.value = 0;
    Get.find<HomeScreenController>().listExpenseOfMonth.value.clear();
    List<dynamic> _listData = json.decode(value);
    for (var data in _listData) {
      print("data ne::::::::$data");
      Expense expense = Expense.fromJson(data);
      print("expense ne::::::::${expense.content}");
      Get.find<HomeScreenController>().setExpense(expense.total);
      Get.find<HomeScreenController>().listExpenseOfMonth.value.add(expense);
    }

    // Map<String, dynamic> decoded = json.decode(value);
    // Get.find<HomeScreenController>().totalAmountExpenseOfMonth.value = 0;
    // Get.find<HomeScreenController>().listExpenseOfMonth.value.clear();
    // for (var key in decoded.keys) {
    //   print("key ne::::::::$key");
    //   List<dynamic> _listData = json.decode(decoded[key]);
    //   for (var data in _listData) {
    //     print("data ne::::::::$data");
    //     Expense expense = Expense.fromJson(data);
    //     print("expense ne::::::::${expense.content}");
    //     Get.find<HomeScreenController>().setExpense(expense.total);
    //     Get.find<HomeScreenController>().listExpenseOfMonth.value.add(expense);
    //   }
    // }
  }

  _listenerExpense(String month) {
    databaseReference.child(month).onValue.listen((Event event) {
      String value = json.encode(event.snapshot.value["data"]);
      print("_listenerExpense me:::::::::::::$value");
      _calculateExpense(event.snapshot.value["data"]);
    });
  }

  createExpense(Expense expense) {
    databaseReference
        .child("listMonth")
        .once()
        .then((DataSnapshot snapshot) async {
      String value = json.encode(snapshot.value["data"]);
      print("checkMonth ne::::::::$value");

      var df2 = DateFormat("dd/MM/yyyy hh:mm");
      var df = DateFormat("MM-yyyy");
      String dateTime = df.format(DateTime.now());

      // Expense expense = Expense();
      // expense.content = "mua mì gói";
      // expense.total = 10000;
      // expense.date = df2.format(DateTime.now());

      if (!value.contains(dateTime)) {
        _updateListMonth("${value.replaceAll('"', '')},$dateTime");
        _createMonth(expense, dateTime);
      } else {
        _updateExpenseOfMonth(expense, dateTime);
      }
    });
  }

  _updateListMonth(String listMonth) {
    print("_updateListMonth ne::::::::$listMonth");
    databaseReference.child("listMonth").update({"data": listMonth});
  }

  _createMonth(Expense expense, String dateTime) {
    var df3 = DateFormat("dd");
    Get.find<HomeScreenController>().listExpenseOfMonth.value.add(expense);
    String data =
        json.encode(Get.find<HomeScreenController>().listExpenseOfMonth.value);
    String day = df3.format(DateTime.now());
    String id = "$dateTime/${df3.format(DateTime.now())}";
    print("_createMonth::::::$id - data::::::$data");
    _databaseReference.child(dateTime).set({"data": data});
    // _createInfoOfMonth(dateTime);
  }

  _updateExpenseOfMonth(Expense expense, String dateTime) {
    var df3 = DateFormat("dd");
    Get.find<HomeScreenController>().listExpenseOfMonth.value.add(expense);
    String data =
        json.encode(Get.find<HomeScreenController>().listExpenseOfMonth.value);
    String day = df3.format(DateTime.now());
    String id = "$dateTime/${df3.format(DateTime.now())}";
    print("_updateExpenseOfMonth::::::$id - data::::::$data");
    _databaseReference.child(dateTime).update({"data": data});
  }

  _createInfoOfMonth(String dateTime) {
    print("_createInfoOfMonth::::::$dateTime");
    _databaseReference.child("info_$dateTime").set({
      "target_save_money": InfoOfMonth.currentInfoOfMonth.targetSaveMoney,
      "total_salary": InfoOfMonth.currentInfoOfMonth.totalSalary,
      "category": json.encode(InfoOfMonth.currentInfoOfMonth.category)
    });
  }

  updateInfoOfMonth(String dateTime) {
    _databaseReference.child("info_$dateTime").update({
      "target_save_money": 20000000,
      "total_salary": 40000000,
      "category": "tiệc,ăn uống"
    });
  }

  _getLastInfoOfMonth(String month) {
    print("getLastInfoOfMonth ne::::::::::::::");
    databaseReference
        .child("listMonth")
        .once()
        .then((DataSnapshot snapshot) async {
      String value = json.encode(snapshot.value["data"]).replaceAll('"', '');
      print("getLastInfoOfMonth listMonth ne::::::::::::::$value");
      List<String> listDateTime = value.split(",");
      databaseReference
          .child("info_${listDateTime[listDateTime.length - 1]}")
          .once()
          .then((DataSnapshot snapshot) async {
        String data = json.encode(snapshot.value);
        print(
            "getLastInfoOfMonth ne::::::::::::::$data - key:::::::::::::info_${listDateTime[listDateTime.length - 1]}");
        InfoOfMonth infoOfMonth;
        if (data == "null") {
          print("day ne");
          infoOfMonth = InfoOfMonth();
          infoOfMonth.category = _listDefaultCategory();
          infoOfMonth.totalSalary = 40000000;
          infoOfMonth.targetSaveMoney = 20000000;
        } else {
          print("day ne2");
          infoOfMonth = InfoOfMonth.fromJson(json.decode(data));
        }
        Get.find<HomeScreenController>().totalSalary.value =
            infoOfMonth.totalSalary;
        Get.find<HomeScreenController>().targetSaveMoney.value =
            infoOfMonth.targetSaveMoney;
        InfoOfMonth.currentInfoOfMonth = infoOfMonth;
        print("getLastInfoOfMonth::::::::::::::${infoOfMonth.category}");
        var df = DateFormat("MM-yyyy");
        String dateTime = df.format(DateTime.now());
        if (!value.contains(dateTime)) {
          _createInfoOfMonth(dateTime);
        }
        _loadDataWithMonth(month);
      });
    });
  }

  List<Category> _listDefaultCategory() {
    List<Category> _listCategory = <Category>[];

    for (int i = 0; i < 5; i++) {
      Category category = Category();
      String name = "";
      int money = 0;
      if (i == 0) {
        name = "tiệc";
        money = 3000000;
      } else if (i == 1) {
        name = "ăn uống của vợ";
        money = 6000000;
      } else if (i == 2) {
        name = "ăn uống của chồng";
        money = 2000000;
      } else if (i == 3) {
        name = "khám bệnh tía";
        money = 1700000;
      } else if (i == 4) {
        name = "du lịch";
        money = 2000000;
      }
      category.name = name;
      category.money = money;
      _listCategory.add(category);
    }

    return _listCategory;
  }
}
