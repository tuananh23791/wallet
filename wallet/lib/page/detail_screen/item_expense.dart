import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wallet/model/category.dart';
import 'package:wallet/model/expense.dart';
import 'package:wallet/model/info_of_month.dart';
import 'package:wallet/utils/my_style.dart';
import 'package:wallet/utils/utils.dart';

class ItemExpense extends StatefulWidget {
  final List<Expense> listExpense;
  final String title;
  final bool isCategory;

  const ItemExpense({
    Key key,
    this.listExpense,
    this.title,
    this.isCategory = false,
  }) : super(key: key);

  @override
  ItemExpenseState createState() => ItemExpenseState();
}

class ItemExpenseState extends State<ItemExpense> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _groupItem();
  }

  // void setStateIfMounted(f) {
  //   if (mounted) setState(f);
  // }

  Widget _groupItem() {
    return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.yellow,
        ),
        child: Stack(
          children: [
            Container(
              height: 70,
              color: _getColorItem(),
            ),
            ExpansionTile(
              title: Text(
                widget.title == null
                    ? "null"
                    : "${widget.title} (đã chi: ${Utils().formatMoneyWithInt(_totalAmount())}) ${_contentRestAmount()}",
                style: defaultTextStyle.copyWith(
                    fontSize: 16,
                    color: widget.isCategory ? Colors.white : Colors.black),
              ),
              // initiallyExpanded: true,
              collapsedBackgroundColor: Colors.transparent,
              children: widget.listExpense.length > 0
                  ? widget.listExpense
                      .map((expense) => _itemExpense(expense))
                      .toList()
                  : [SizedBox()],
            ),
          ],
        ));
  }

  Color _getColorItem() {
    if (!widget.isCategory) return Colors.white;
    int maxAmount = _getMaxAmountOfCategory();
    int restAmount = _calculateRestAmount();
    double amount50Percent = maxAmount / 2;
    double amount30Percent = maxAmount * 30 / 100;
    double amount10Percent = maxAmount * 10 / 100;

    print(
        "length data::::::::${widget.listExpense.length} --- title:::::${widget.title} ---- isCategory:::::${widget.isCategory}");
    print("maxAmount:::$maxAmount");
    print("restAmount:::$restAmount");
    if (restAmount > amount50Percent) return Colors.green;
    print("1:::::::::::");
    if (restAmount > amount30Percent) return Colors.amber;
    print("2:::::::::::");
    if (restAmount > amount10Percent) return Colors.purple;
    print("3:::::::::::");
    return Colors.red;
  }

  int _getMaxAmountOfCategory() {
    int maxAmount = 0;
    for (Category category in InfoOfMonth.currentInfoOfMonth.category) {
      if (category.name == widget.title) {
        maxAmount = category.money;
        break;
      }
    }
    return maxAmount;
  }

  int _calculateRestAmount() {
    if (!widget.isCategory) return 0;
    int rest = _getMaxAmountOfCategory() - _totalAmount();
    return rest;
  }

  String _contentRestAmount() {
    if (!widget.isCategory) return "";
    return "(còn lại ${Utils().formatMoneyWithInt(_calculateRestAmount())})";
  }

  Widget _itemExpense(Expense expense) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Colors.black,
            margin: EdgeInsets.only(bottom: 10),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Nội dung chi tiêu: ${expense.content}",
              style: defaultTextStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Tiền: ${expense.total}",
              style: defaultTextStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Tiêu đề: ${expense.category}",
              style: defaultTextStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Ngày: ${expense.date}",
              style: defaultTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  int _totalAmount() {
    int total = 0;
    for (Expense expense in widget.listExpense) {
      total += expense.total;
    }

    return total;
  }
}
