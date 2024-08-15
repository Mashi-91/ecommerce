import 'package:ecommerce/route/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailError = ''.obs; // Use empty string as default value
  final passwordError = ''.obs; // Use empty string as default value
  final isLoading = false.obs;

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email cannot be empty';
    } else if (!GetUtils.isEmail(value)) {
      emailError.value = 'Invalid email address';
    } else {
      emailError.value = ''; // Clear error if valid
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password cannot be empty';
    } else if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters long';
    } else {
      passwordError.value = ''; // Clear error if valid
    }
  }

  bool isFormValid() {
    return emailError.value.isEmpty && passwordError.value.isEmpty;
  }

  Future<void> login() async {
    if (!isFormValid()) return;

    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if(userCredential.user != null) {
        Get.offAllNamed(AppRoutes.bottomNavigationRoute);
      }
      // Handle successful login (e.g., navigate to home screen)
    } catch (e) {
      // Handle login error
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
