import 'package:flutter/material.dart';

class TotalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Tổng thu nhập:"),
          Text("Tổng chi:"),
          Text("Còn lại:"),
        ],
      ),
    );
  }
}
