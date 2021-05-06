import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wallet/firebase/firebase_database_manager.dart';
import 'package:wallet/model/info_of_month.dart';
import 'package:wallet/page/home_screen/mothly_widget.dart';
import 'package:wallet/page/home_screen/total_widget.dart';
import 'package:wallet/struct/base_stateful_widget.dart';
import 'package:wallet/utils/my_style.dart';
import 'package:wallet/utils/strings.dart';
import 'package:wallet/utils/utils.dart';

import 'home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStatefulWidgetState<HomeScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  String appBarTitle() {
    return null;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: tabBarView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () => _onPress(),
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: GestureDetector(
          onTap: () {
            showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100))
                .then((date) {
              if (date == null) return;
              var df = DateFormat("MM-yyyy");
              String dateTime = df.format(date);
              InfoOfMonth.currentInfoOfMonth?.month = dateTime;
              _loadData();
            });
          },
          child: Obx(() => Text(
              "Chi tieu thang ${Get.find<HomeScreenController>().month.value}"))),
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        tabs: <Widget>[
          Text(
            "Ngày",
            style: defaultTextStyle.copyWith(color: Colors.white),
          ),
          Text(
            "Toàn bộ",
            style: defaultTextStyle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  TabBarView tabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        MonthlyWidget(),
        TotalWidget(),
      ],
    );
  }

  _onPress() {
    print("hello");
    Get.toNamed(EXPENSE_SCREEN);
  }

  _loadData() {
    FireBaseDatabaseManager().loadDataWithMonth(Utils().getMonth());
  }
}
