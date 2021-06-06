import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/model/expense.dart';
import 'package:wallet/page/home_screen/home_screen_controller.dart';
import 'package:wallet/struct/base_stateful_widget.dart';
import 'package:wallet/utils/my_style.dart';
import 'package:wallet/utils/utils.dart';

import 'detail_screen_controller.dart';
import 'item_expense.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends BaseStatefulWidgetState<DetailScreen> {
  List<String> _listCategory = <String>[];
  Map<int, List<Expense>> _mapData = Map<int, List<Expense>>();
  String _value = "";

  @override
  String appBarTitle() {
    return "Chi tiết chi tiêu tháng ${Get.find<DetailScreenController>().month}";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listCategory.add("Tất cả");
    _listCategory.addAll(Utils().getListNameCategory());
    _value = _listCategory[0];
    _filterData();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listCategory(),
            Column(
              children: _mapData.values
                  .map((listExpense) => ItemExpense(
                        listExpense: listExpense,
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget listCategory() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: DropdownButton<String>(
        items: _listCategory.map((String value) {
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
          _value = value;
          _filterData();
        },
      ),
    );
  }

  _filterData() {
    _mapData.clear();
    var _listAllExpenseOfMonth =
        Get.find<HomeScreenController>().listExpenseOfMonth.value;
    for (Expense expense in _listAllExpenseOfMonth) {
      int day = int.parse(Utils().getDayWithString(expense.date));
      if (_mapData[day] == null) {
        _mapData[day] = <Expense>[];
      }

      if (_value == "Tất cả" || _value == expense.category)
        _mapData[day].add(expense);
    }
    setState(() {});
  }

  @override
  bool isCanGoBack() {
    // TODO: implement isCanGoBack
    return true;
  }
}
