import 'package:get/get.dart';
import 'package:wallet/page/detail_screen/detail_screen.dart';
import 'package:wallet/page/detail_screen/detail_screen_binding.dart';
import 'package:wallet/page/expense/expense_bindings.dart';
import 'package:wallet/page/expense/expense_screen.dart';
import 'package:wallet/page/home_screen/home_screen.dart';
import 'package:wallet/page/home_screen/home_screen_binding.dart';
import 'package:wallet/utils/strings.dart';

GetMaterialApp router() {
  return GetMaterialApp(
    initialRoute: "/",
    getPages: [
      GetPage(
          name: '/', page: () => HomeScreen(), binding: HomeScreenBinding()),
      GetPage(
          name: EXPENSE_SCREEN,
          page: () => ExpenseScreen(),
          binding: ExpenseBinding(),
          transition: Transition.rightToLeft),
      GetPage(
          name: DETAIL_SCREEN,
          page: () => DetailScreen(),
          binding: DetailScreenBinding(),
          transition: Transition.rightToLeft)
      // GetPage(
      //     name: LOGIN_SCREEN,
      //     page: () => VideoPickerPage(),
      //     binding: LoginBinding(),
      //     transition: Transition.rightToLeft),
      // GetPage(
      //     name: BLANK_SCREEN,
      //     page: () => BlankScreen(),
      //     binding: BlankScreenBinding(),
      //     transition: Transition.rightToLeft),
    ],
  );
}
