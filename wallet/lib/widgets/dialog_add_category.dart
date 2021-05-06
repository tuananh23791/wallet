import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/page/home_screen/home_screen_controller.dart';
import 'package:wallet/utils/my_style.dart';

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

showDialogEditCategory() {
  TextEditingController _moneyController = TextEditingController();
  String _value = Utils().getListNameCategory()[0];
  _moneyController.text = "${_moneyOfCategory(_value)}";
  Get.defaultDialog(
      title: "Sửa tiêu đề",
      content: Column(
        children: [
          _listCategory(onSelected: (value) {
            _value = _value;
            _moneyController.text = "${_moneyOfCategory(value)}";
          }),
          SizedBox(
            height: 30,
          ),
          CustomTextField(
            labelText: "Số tiền",
            width: 300,
            height: 50,
            textInputType: TextInputType.text,
            textEditingController: _moneyController,
          )
        ],
      ),
      textConfirm: "Đồng ý",
      textCancel: "Hủy",
      onConfirm: () {
        _updateCategory(_value, int.parse(_moneyController.text));
        Get.back();
      });
}

Widget _listCategory({Function(String) onSelected}) {
  var _value = Utils().getListNameCategory()[0];
  return DropdownButton<String>(
    items: Utils().getListNameCategory().map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: new Text(
          value,
          style: defaultTextStyle,
        ),
      );
    }).toList(),
    value: _value,
    onChanged: (value) {
      onSelected(value);
    },
  );
}

showDialogCantEdit() {
  if (Get.isDialogOpen) Get.back();
  Get.defaultDialog(
      title: "Lỗi",
      content: Center(child: Text("Không thể chỉnh sửa tháng khác được")),
      textConfirm: "OK");
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
  if (!Utils().isCurrentDate()) {
    showDialogCantEdit();
    return;
  }
  if (isSalary)
    InfoOfMonth.currentInfoOfMonth.totalSalary = money;
  else
    InfoOfMonth.currentInfoOfMonth.targetSaveMoney = money;
  FireBaseDatabaseManager().updateInfoOfMonth(Utils().getMonth());
}

_createCategory(String name, int money) {
  if (!Utils().isCurrentDate()) {
    showDialogCantEdit();
    return;
  }
  Category category = Category();
  category.name = name;
  category.money = money;
  InfoOfMonth.currentInfoOfMonth.category.add(category);
  FireBaseDatabaseManager().updateInfoOfMonth(Utils().getMonth());
}

_updateCategory(String name, int money) {
  if (!Utils().isCurrentDate()) {
    showDialogCantEdit();
    return;
  }
  for (Category category in InfoOfMonth.currentInfoOfMonth.category) {
    if (category.name == name) {
      category.money = money;
      break;
    }
  }
  FireBaseDatabaseManager()
      .updateInfoOfMonth(Get.find<HomeScreenController>().month.value);
}

int _moneyOfCategory(String name) {
  int money = 0;
  for (Category category in InfoOfMonth.currentInfoOfMonth.category) {
    if (category.name == name) {
      money = category.money;
      break;
    }
  }
  return money;
}
