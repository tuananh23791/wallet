import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/firebase/firebase_database_manager.dart';
import 'package:wallet/model/expense.dart';
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
            value,
            style: defaultTextStyle,
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
}
