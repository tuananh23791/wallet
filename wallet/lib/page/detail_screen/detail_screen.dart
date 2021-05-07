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
  Map<String, List<Expense>> _mapData = Map<String, List<Expense>>();
  String _value = "";
  var isSelectedDay = true;

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
            _tabBar(),
            listCategory(),
            isSelectedDay
                ? Column(
                    children: _mapData.keys
                        .map((key) => ItemExpense(
                              listExpense: _mapData[key],
                              title: isSelectedDay ? "Ngày $key" : key,
                              isCategory: !isSelectedDay,
                            ))
                        .toList(),
                  )
                : Column(
                    children: _mapData.keys
                        .map((key) => ItemExpense(
                              listExpense: _mapData[key],
                              title: isSelectedDay ? "Ngày $key" : key,
                              isCategory: !isSelectedDay,
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
    if (_listAllExpenseOfMonth == null || _listAllExpenseOfMonth.length == 0)
      return;
    for (Expense expense in _listAllExpenseOfMonth) {
      String key = "";
      if (isSelectedDay)
        key = Utils().getDayWithString(expense.date);
      else
        key = expense.category;

      if (_mapData[key] == null) {
        _mapData[key] = <Expense>[];
      }

      if (isSelectedDay) {
        if (_value == "Tất cả" || _value == expense.category) {
          _mapData[key].add(expense);
        }
      } else {
        print("key:::::::$key");
        if (_value == "Tất cả" || _value == expense.category) {
          _mapData[key].add(expense);
        }
      }
    }
    setState(() {});
  }

  @override
  bool isCanGoBack() {
    // TODO: implement isCanGoBack
    return true;
  }

  Widget _tabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: GestureDetector(
          onTap: () {
            if (!isSelectedDay) {
              isSelectedDay = true;
              _filterData();
            }
          },
          child: Container(
            height: 50,
            color: isSelectedDay ? Colors.blueGrey : Colors.white,
            child: Center(child: Text("Ngày")),
          ),
        )),
        Expanded(
            child: GestureDetector(
          onTap: () {
            if (isSelectedDay) {
              isSelectedDay = false;
              _filterData();
            }
          },
          child: Container(
            color: isSelectedDay ? Colors.white : Colors.blueGrey,
            height: 50,
            child: Align(alignment: Alignment.center, child: Text("Tiêu Đề")),
          ),
        )),
      ],
    );
  }
}
