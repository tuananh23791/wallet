import 'package:flutter/material.dart';
import 'package:wallet/utils/color.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final Function onClick;
  final String text;

  const CustomButton(
      {Key key, this.width, this.height, this.onClick, this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: purple,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: TextButton(
        style: ButtonStyle(
//        overlayColor: MaterialStateProperty.resolveWith<Color>(
//                (Set<MaterialState> states) {
//              return Colors.white; // Defer to the widget's default.
//            }
//        ),
            ),
        onPressed: () {
          if (onClick != null) onClick();
        },
        child: Text(text ?? "",
            style: TextStyle(color: Colors.white, fontSize: 17)),
      ),
    );
  }
}
