import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wallet/model/expense.dart';
import 'package:wallet/utils/my_style.dart';
import 'package:wallet/utils/utils.dart';

class ItemExpense extends StatefulWidget {
  final List<Expense> listExpense;
  final String title;

  const ItemExpense({
    Key key,
    this.listExpense, this.title,
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

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Widget _groupItem() {
    return widget.listExpense.length > 0
        ? Theme(
            data: Theme.of(context).copyWith(
                accentColor: Colors.white, unselectedWidgetColor: Colors.white),
            child: ExpansionTile(
              title: Text(
                widget.title == null?"null" : "${widget.title} (đã chi: ${Utils().formatMoneyWithInt(_totalAmount())})",
                style: defaultTextStyle,
              ),
              // initiallyExpanded: true,
              collapsedBackgroundColor: Colors.amber,
              backgroundColor: Colors.amber,
              children: widget.listExpense
                  .map((expense) => _itemExpense(expense))
                  .toList(),
            ))
        : SizedBox();
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
