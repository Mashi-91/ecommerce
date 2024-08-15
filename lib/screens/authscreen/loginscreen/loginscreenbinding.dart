import 'package:ecommerce/screens/authscreen/loginscreen/loginscreencontroller.dart';
import 'package:get/get.dart';

class LoginScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>LoginScreenController());
  }

}