import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../firebase/firebase_database_manager.dart';
import '../model/category.dart';
import '../model/info_of_month.dart';
import '../utils/utils.dart';
import 'custom_textfield.dart';

showDialogAddCategory() {
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _moneyController = TextEditingController();
  Get.defaultDialog(
      title: "Tạo tiêu đề",
      content: Column(
        children: [
          CustomTextField(
            labelText: "Tên tiêu đề",
            width: 300,
            height: 50,
            textEditingController: _categoryController,
          ),
          SizedBox(
            height: 30,
          ),
          CustomTextField(
            labelText: "Số tiền",
            width: 300,
            height: 50,
            textInputType: TextInputType.number,
            textEditingController: _moneyController,
          )
        ],
      ),
      textConfirm: "Đồng ý",
      textCancel: "Hủy",
      onConfirm: () {
        _createCategory(
            _categoryController.text, int.parse(_moneyController.text));
        Get.back();
      });
}

showDialogUpdateMoney({bool isSalary = false}) {
  int salary = isSalary
      ? InfoOfMonth.currentInfoOfMonth.totalSalary
      : InfoOfMonth.currentInfoOfMonth.targetSaveMoney;
  TextEditingController _moneyController = TextEditingController();
  _moneyController.text = "$salary";
  Get.defaultDialog(
      title: isSalary
          ? "Sửa thu nhập tháng ${Utils().getMonth()}"
          : "Sửa mục tiêu đề dành tháng ${Utils().getMonth()}",
      content: Column(
        children: [
          CustomTextField(
            labelText: "Số tiền",
            width: 300,
            height: 50,
            textInputType: TextInputType.number,
            textEditingController: _moneyController,
          )
        ],
      ),
      textConfirm: "Đồng ý",
      textCancel: "Hủy",
      onConfirm: () {
        _updateMoney(int.parse(_moneyController.text), isSalary: isSalary);
        Get.back();
      });
}

_updateMoney(int money, {bool isSalary}) {
  if (isSalary)
    InfoOfMonth.currentInfoOfMonth.totalSalary = money;
  else
    InfoOfMonth.currentInfoOfMonth.targetSaveMoney = money;
  FireBaseDatabaseManager().updateInfoOfMonth(Utils().getMonth());
}

_createCategory(String name, int money) {
  Category category = Category();
  category.name = name;
  category.money = money;
  InfoOfMonth.currentInfoOfMonth.category.add(category);
  FireBaseDatabaseManager().updateInfoOfMonth(Utils().getMonth());
}
