import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/firebase/firebase_database_manager.dart';
import 'package:wallet/model/category.dart';
import 'package:wallet/model/expense.dart';
import 'package:wallet/model/info_of_month.dart';
import 'package:wallet/page/home_screen/home_screen_controller.dart';
import 'package:wallet/struct/base_stateful_widget.dart';
import 'package:wallet/utils/my_style.dart';
import 'package:wallet/utils/utils.dart';
import 'package:wallet/widgets/custom_button.dart';
import 'package:wallet/widgets/custom_textfield.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends BaseStatefulWidgetState<ExpenseScreen> {
  TextEditingController _contentEditingController = TextEditingController();
  TextEditingController _moneyEditingController = TextEditingController();
  String _value = "";
  List<String> _listCategory = <String>[];
  @override
  String appBarTitle() {
    return "Tạo chi tiêu";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listCategory = Utils().getListNameCategory();
    setState(() {
      _value = _listCategory[0];
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content(),
            moneyExpense(),
            SizedBox(
              height: 30,
            ),
            textDate(),
            SizedBox(
              height: 30,
            ),
            listCategory(),
            SizedBox(
              height: 30,
            ),
            buttonCreate(),
          ],
        ),
      ),
    );
  }

  @override
  bool isCanGoBack() {
    // TODO: implement isCanGoBack
    return true;
  }

  Widget content() {
    return CustomTextField(
      labelText: "Nội dung chi tiêu",
      height: 200,
      textEditingController: _contentEditingController,
    );
  }

  Widget moneyExpense() {
    return CustomTextField(
      labelText: "Số tiền đã tiêu",
      height: 70,
      textEditingController: _moneyEditingController,
      textInputType: TextInputType.number,
    );
  }

  Widget textDate() {
    return Text(
      Utils().getCurrentDate(),
      style: defaultTextStyle,
    );
  }

  Widget buttonCreate() {
    return Center(
      child: CustomButton(
        height: 70,
        width: 200,
        text: "Tạo",
        onClick: () {
          Expense expense = Expense();
          expense.content = _contentEditingController.text;
          expense.total = int.parse(_moneyEditingController.text);
          expense.date = Utils().getCurrentDate();
          expense.category = _value;
          FireBaseDatabaseManager().createExpense(expense);
          _showPopupSuccess();
        },
      ),
    );
  }

  Widget listCategory() {
    return DropdownButton<String>(
      items: _listCategory.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: new Text(
            "$value ${_getValueText(value)}",
            style: defaultTextStyle.copyWith(color: _getColorItem(value)),
          ),
        );
      }).toList(),
      value: _value,
      onChanged: (value) {
        setState(() {
          _value = value;
        });
      },
    );
  }

  _showPopupSuccess() {
    Get.defaultDialog(
        title: "Thành Công",
        content: Text("Đã cập nhật thành công"),
        textConfirm: "OK",
        onConfirm: () {
          Get.back();
          Get.back();
        });
  }

  Color _getColorItem(String value) {
    print("_getColorItem:::::::::$value");
    _calculateExpenseAmount();
    int maxAmount = _getMaxAmountOfCategory(value);
    int restAmount = _calculateRestAmount(value);
    double amount50Percent = maxAmount / 2;
    double amount30Percent = maxAmount * 30 / 100;
    double amount10Percent = maxAmount * 10 / 100;

    if (restAmount > amount50Percent) return Colors.green;
    if (restAmount > amount30Percent) return Colors.amber;
    if (restAmount > amount10Percent) return Colors.purple;
    return Colors.red;
  }

  int _getMaxAmountOfCategory(String value) {
    print("_getMaxAmountOfCategory");
    int maxAmount = 0;
    for (Category category in InfoOfMonth.currentInfoOfMonth.category) {
      if (category.name == value) {
        maxAmount = category.money;
        break;
      }
    }
    return maxAmount;
  }

  int _calculateRestAmount(String value) {
    print(
        "_calculateRestAmount value:::::::::::$value - length:::::::${mapAmountExpense.length}");
    if (mapAmountExpense[value] == null) mapAmountExpense[value] = 0;
    int rest = _getMaxAmountOfCategory(value) - mapAmountExpense[value];
    return rest;
  }

  Map<String, int> mapAmountExpense = Map<String, int>();
  _calculateExpenseAmount() {
    mapAmountExpense.clear();
    if (Get.find<HomeScreenController>().listExpenseOfMonth.value == null) {
      return;
    }
    for (Expense expense
        in Get.find<HomeScreenController>().listExpenseOfMonth) {
      if (mapAmountExpense[expense.category] == null)
        mapAmountExpense[expense.category] = 0;
      mapAmountExpense[expense.category] += expense.total;
      print(
          "category::::::::::${expense.category} ---- amount:::::::::::::${mapAmountExpense[expense.category]}");
    }
  }

  String _getValueText(String value) {
    _calculateExpenseAmount();

    return "(còn lại ${_calculateRestAmount(value)})";
  }
}
