import 'package:ecommerce/route/routes.dart';
import 'package:ecommerce/screens/authscreen/loginscreen/loginscreencontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Commerce'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold,),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Please login to your account',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30.0),
                  Obx(() {
                    return TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: const OutlineInputBorder(),
                        errorText: controller.emailError.value.isNotEmpty
                            ? controller.emailError.value
                            : null,
                      ),
                      onChanged: (value) => controller.validateEmail(value),
                    );
                  }),
                  const SizedBox(height: 16.0),
                  Obx(() {
                    return TextField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        errorText: controller.passwordError.value.isNotEmpty
                            ? controller.passwordError.value
                            : null,
                      ),
                      onChanged: (value) => controller.validatePassword(value),
                    );
                  }),
                  const SizedBox(height: 24.0),
                  Obx(() {
                    return ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              if (controller.isFormValid()) {
                                controller.login();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                    );
                  }),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // Navigate to Forgot Password Screen
                      Get.toNamed(AppRoutes.forgotScreenRoute);
                    },
                    child: const Text('Forgot Password?'),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // Navigate to Registration Screen
                      Get.toNamed(AppRoutes.registerScreenRoute);
                    },
                    child: const Text('Don\'t have an account? Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
