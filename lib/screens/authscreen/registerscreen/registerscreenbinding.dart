import 'package:ecommerce/screens/authscreen/registerscreen/registerscreencontroller.dart';
import 'package:get/get.dart';

class RegisterScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> RegisterScreenController());
  }

}