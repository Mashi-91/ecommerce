import 'package:ecommerce/screens/productdetailscreen/productdetailcontroller.dart';
import 'package:get/get.dart';

class ProductDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>ProductDetailController());
  }

}