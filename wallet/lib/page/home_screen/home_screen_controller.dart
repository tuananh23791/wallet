import 'package:get/get.dart';
import 'package:wallet/model/expense.dart';

class HomeScreenController extends GetxController {
  var totalAmountExpenseOfMonth = 0.obs;
  var totalSalary = 0.obs;
  var targetSaveMoney = 0.obs;
  var totalSaveMoney = 0.obs;
  var totalAmount = 0.obs;
  var listExpenseOfMonth = <Expense>[].obs;

  setExpense(int amount) {
    totalAmountExpenseOfMonth.value += amount;
    print("totalSaveMoney::::::::::::$totalSaveMoney");
    totalSaveMoney.value = totalSalary.value - totalAmountExpenseOfMonth.value;
  }
}
