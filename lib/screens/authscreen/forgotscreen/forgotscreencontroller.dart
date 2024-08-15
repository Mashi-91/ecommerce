import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotScreenController extends GetxController {
  var email = ''.obs;
  var isLoading = false.obs;

  final emailController = TextEditingController();

  void sendResetLink() async {
    if (emailController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        // Simulate a network request
        await Future.delayed(Duration(seconds: 2));
        // Perform your password reset logic here
        // Example: FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        Get.snackbar('Success', 'Password reset link sent to your email',
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Error', 'Failed to send reset link',
            snackPosition: SnackPosition.BOTTOM);
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Error', 'Please enter your email address',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}