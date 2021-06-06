import 'package:get/get.dart';
import 'package:wallet/page/detail_screen/detail_screen_controller.dart';
import 'package:wallet/page/home_screen/home_screen_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeScreenController(), permanent: true);
    Get.put(DetailScreenController());
  }
}
