import 'package:flutter/material.dart';
import 'package:wallet/utils/color.dart';

abstract class BaseStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return appBarTitle() == null
        ? SafeArea(
            child: Stack(
              children: [
                buildWidget(context),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
                title: Text(appBarTitle()),
                centerTitle: true,
                backgroundColor: purple,
                automaticallyImplyLeading: isCanGoBack()),
            body: SafeArea(
              child: Stack(
                children: [
                  buildWidget(context),
                ],
              ),
            ),
          );
  }

  Widget buildWidget(BuildContext context);
  String appBarTitle();

  @protected
  bool isCanGoBack() {
    return false;
  }
}
