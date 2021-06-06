import 'package:flutter/material.dart';
import 'package:wallet/utils/color.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController textEditingController;
  final double width;
  final double height;
  final double textSize;
  final TextInputType textInputType;
  final bool isPassword;
  final bool isShowClearText;

  const CustomTextField({
    Key key,
    this.labelText,
    this.textEditingController,
    this.width,
    this.height,
    this.textInputType,
    this.textSize,
    this.isPassword,
    this.isShowClearText = false,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final focusNode = FocusNode();
  bool hasFocus = false;
  TextStyle labelStyle;
  bool showClearText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    focusNode.removeListener(onFocusChange);
    super.dispose();
  }

  void onFocusChange() {
    _showClearText();
    setState(() {
      labelStyle = focusNode.hasFocus
          ? TextStyle(color: Colors.blue)
          : TextStyle(color: Colors.grey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          child: TextFormField(
            onChanged: (value) {
              _showClearText();
            },
            focusNode: focusNode,
            decoration: InputDecoration(
              isDense: true,
              suffixIcon: showClearText ? clearIcon() : SizedBox(),
              contentPadding: EdgeInsets.fromLTRB(
                  20, widget.height / 4, 20, widget.height / 4),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: purple, width: 2),
              ),
              labelText: widget.labelText ?? "",
              labelStyle: labelStyle,
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            autofocus: false,
            obscureText: widget.isPassword ?? false,
            maxLines: 3,
            maxLength: 200,
            buildCounter: (BuildContext context,
                    {int currentLength, int maxLength, bool isFocused}) =>
                null,
            controller: widget.textEditingController ?? TextEditingController(),
            keyboardType: widget.textInputType ?? TextInputType.text,
          ),
        ),
//        showClearText ? clearIcon() : SizedBox(),
      ],
    );
  }

  Widget clearIcon() {
    return GestureDetector(
      onTap: () {
        widget.textEditingController.text = "";
        setState(() {
          showClearText = false;
        });
      },
      child: Container(
        height: 70,
        width: 50,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "X",
            style: TextStyle(
                color: purple, fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
      ),
    );
  }

  _showClearText() {
    if (widget.isShowClearText) {
      if (widget.textEditingController.text.length > 0 && focusNode.hasFocus) {
        setState(() {
          showClearText = true;
        });
      } else {
        setState(() {
          showClearText = false;
        });
      }
    }
  }
}
