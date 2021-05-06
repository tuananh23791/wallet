import 'dart:convert';

import 'category.dart';

class InfoOfMonth {
  int targetSaveMoney;
  int totalSalary;
  String month = "";
  List<Category> category;
  static InfoOfMonth currentInfoOfMonth;

  InfoOfMonth({this.targetSaveMoney, this.totalSalary, this.category});

  InfoOfMonth.fromJson(Map<String, dynamic> mapJson) {
    targetSaveMoney = mapJson['target_save_money'];
    totalSalary = mapJson['total_salary'];
    if (mapJson['category'] != null) {
      category = <Category>[];
      json.decode(mapJson['category']).forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['target_save_money'] = this.targetSaveMoney;
    data['total_salary'] = this.totalSalary;
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
