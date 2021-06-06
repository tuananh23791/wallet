import 'package:flutter/material.dart';
import 'package:wallet/utils/color.dart';

abstract class BaseStatefulWidgetState<statefulWidget extends StatefulWidget>
    extends State<statefulWidget> {
  @override
  Widget build(BuildContext context) {
    return appBarTitle() == null
        ? MaterialApp(
            home: SafeArea(
              child: Stack(
                children: [
                  buildWidget(context),
                ],
              ),
            ),
          )
        : MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Text(appBarTitle()),
                centerTitle: true,
                backgroundColor: purple,
                leading: isCanGoBack()
                    ? new IconButton(
                        icon: new Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    : SizedBox(),
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    buildWidget(context),
                  ],
                ),
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
