import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/screens/authscreen/registerscreen/registerscreencontroller.dart';

class RegisterScreen extends GetView<RegisterScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                    'Create an Account',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Please fill in the details to register',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30.0),

                  Obx(() {
                    return GestureDetector(
                      onTap: () => controller.pickProfilePicture(),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: controller.profilePicUrl.value.isNotEmpty
                            ? FileImage(File(controller.profilePicUrl.value))
                            : null,
                        child: controller.profilePicUrl.value.isEmpty
                            ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[700])
                            : null,
                      ),
                    );
                  }),
                  const SizedBox(height: 16.0),

                  Obx(() {
                    return TextField(
                      controller: controller.usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                        errorText: controller.usernameError.value.isNotEmpty ? controller.usernameError.value : null,
                      ),
                      onChanged: (value) => controller.validateUsername(value),
                    );
                  }),
                  const SizedBox(height: 16.0),

                  Obx(() {
                    return TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: const OutlineInputBorder(),
                        errorText: controller.emailError.value.isNotEmpty ? controller.emailError.value : null,
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
                        errorText: controller.passwordError.value.isNotEmpty ? controller.passwordError.value : null,
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
                          controller.register();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Register', style: TextStyle(color: Colors.white),),
                    );
                  }),
                  const SizedBox(height: 16.0),

                  TextButton(
                    onPressed: () {
                      // Navigate to Login Screen
                      Get.offAllNamed('/login');
                    },
                    child: const Text('Already have an account? Login'),
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
