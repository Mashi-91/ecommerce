import 'package:ecommerce/screens/authscreen/forgotscreen/forgotscreen.dart';
import 'package:ecommerce/screens/authscreen/forgotscreen/forgotscreenbinding.dart';
import 'package:ecommerce/screens/authscreen/loginscreen/loginscreen.dart';
import 'package:ecommerce/screens/authscreen/loginscreen/loginscreenbinding.dart';
import 'package:ecommerce/screens/authscreen/registerscreen/registerscreen.dart';
import 'package:ecommerce/screens/authscreen/registerscreen/registerscreenbinding.dart';
import 'package:ecommerce/screens/home_screen/bottomnavigation.dart';
import 'package:ecommerce/screens/home_screen/home_screen.dart';
import 'package:ecommerce/screens/home_screen/home_screen_binding.dart';
import 'package:ecommerce/screens/productdetailscreen/productdetailbinding.dart';
import 'package:ecommerce/screens/productdetailscreen/productdetailscreen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const homeRoute = '/homeRoute';
  static const bottomNavigationRoute = '/bottomNavigationRoute';
  static const productDetailRoute = '/productDetailRoute';
  static const loginScreenRoute = '/loginScreenRoute';
  static const registerScreenRoute = '/registerScreenRoute';
  static const forgotScreenRoute = '/forgotScreenRoute';
}

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.homeRoute,
      page: () => HomeScreen(),
      binding: HomeScreenBinding(),
    ),GetPage(
      name: AppRoutes.bottomNavigationRoute,
      page: () => Bottomnavigation(),
      binding: HomeScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetailRoute,
      page: () => ProductDetailScreen(),
      binding: ProductDetailBinding(),
    ),GetPage(
      name: AppRoutes.loginScreenRoute,
      page: () => LoginScreen(),
      binding: LoginScreenBinding(),
    ),GetPage(
      name: AppRoutes.registerScreenRoute,
      page: () => RegisterScreen(),
      binding: RegisterScreenBinding(),
    ),GetPage(
      name: AppRoutes.forgotScreenRoute,
      page: () => Forgotscreen(),
      binding: ForgotScreenBinding(),
    ),
  ];
}
