import 'package:get/get.dart';
import 'package:wallet/model/expense.dart';
import 'package:wallet/model/info_of_month.dart';
import 'package:wallet/utils/utils.dart';

class HomeScreenController extends GetxController {
  var totalAmountExpenseOfMonth = 0.obs;
  var totalSalary = 0.obs;
  var targetSaveMoney = 0.obs;
  var totalSaveMoney = 0.obs;
  var totalAmount = 0.obs;
  var month = "".obs;
  var listExpenseOfMonth = <Expense>[].obs;

  setExpense(int amount) {
    totalAmountExpenseOfMonth.value += amount;
    print("totalSaveMoney::::::::::::$totalSaveMoney");
    totalSaveMoney.value = totalSalary.value - totalAmountExpenseOfMonth.value;
  }

  clearData() {
    if (Utils().isCurrentDate()) return;
    totalAmountExpenseOfMonth.value = 0;
    totalSalary.value = 0;
    targetSaveMoney.value = 0;
    totalSaveMoney.value = 0;
    totalAmount.value = 0;
    listExpenseOfMonth.value = <Expense>[];
    InfoOfMonth.currentInfoOfMonth = InfoOfMonth();
  }
}
