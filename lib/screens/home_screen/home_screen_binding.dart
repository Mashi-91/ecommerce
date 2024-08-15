import 'package:ecommerce/screens/home_screen/home_screen_controller.dart';
import 'package:ecommerce/screens/home_screen/profilescreen/profilecontroller.dart';
import 'package:get/get.dart';

class HomeScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>HomeScreenController());
    Get.lazyPut(()=>ProfileController());
  }

}