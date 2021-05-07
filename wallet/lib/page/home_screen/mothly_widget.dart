import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wallet/page/detail_screen/detail_screen_controller.dart';
import 'package:wallet/page/home_screen/home_screen_controller.dart';
import 'package:wallet/utils/my_style.dart';
import 'package:wallet/utils/strings.dart';
import 'package:wallet/utils/utils.dart';
import 'package:wallet/widgets/custom_button.dart';
import 'package:wallet/widgets/dialog_add_category.dart';

import '../../utils/utils.dart';

class MonthlyWidget extends StatelessWidget {
  final oCcy = new NumberFormat("#,###", "en_US");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: total(),
      ),
    );
  }

  Widget total() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showDialogUpdateMoney(isSalary: true);
          },
          child: Text(
            "Thu nhập trong tháng:",
            style: defaultTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Obx(() => GestureDetector(
              onTap: () {
                showDialogUpdateMoney(isSalary: true);
              },
              child: Text(
                "${oCcy.format(Get.find<HomeScreenController>().totalSalary.value)} đ",
                style: moneyTextStyle,
                textAlign: TextAlign.center,
              ),
            )),
        SizedBox(
          height: 30,
        ),
        Text(
          "Chi trong tháng:",
          style: defaultTextStyle,
        ),
        Obx(() => Text(
              "${oCcy.format(Get.find<HomeScreenController>().totalAmountExpenseOfMonth.value)} đ",
              style: moneyTextStyle,
              textAlign: TextAlign.center,
            )),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            showDialogUpdateMoney(isSalary: false);
          },
          child: Text(
            "Mục tiêu để dành trong tháng:",
            style: defaultTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Obx(() => GestureDetector(
              onTap: () {
                showDialogUpdateMoney(isSalary: false);
              },
              child: Text(
                "${oCcy.format(Get.find<HomeScreenController>().targetSaveMoney.value)} đ",
                style: moneyTextStyle,
                textAlign: TextAlign.center,
              ),
            )),
        SizedBox(
          height: 30,
        ),
        Text(
          "Còn lại:",
          style: defaultTextStyle,
          textAlign: TextAlign.center,
        ),
        Obx(() => Text(
              "${oCcy.format(Get.find<HomeScreenController>().totalSaveMoney.value)} đ",
              style: moneyTextStyle,
              textAlign: TextAlign.center,
            )),
        SizedBox(
          height: 30,
        ),
        CustomButton(
          height: 70,
          width: 200,
          text: "Chi tiết",
          onClick: () {
            Get.find<DetailScreenController>().month = Utils().getMonth();
            Get.toNamed(DETAIL_SCREEN);
          },
        ),
        SizedBox(
          height: 30,
        ),
        CustomButton(
          height: 70,
          width: 200,
          text: "Tạo tiêu đề",
          onClick: showDialogAddCategory,
        ),
      ],
    );
  }
}
