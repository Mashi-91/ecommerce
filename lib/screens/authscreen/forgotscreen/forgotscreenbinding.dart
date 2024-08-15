import 'package:ecommerce/screens/authscreen/forgotscreen/forgotscreencontroller.dart';
import 'package:get/get.dart';

class ForgotScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> ForgotScreenController());
  }

}