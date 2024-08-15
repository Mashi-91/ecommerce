import 'package:ecommerce/screens/authscreen/forgotscreen/forgotscreencontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Forgotscreen extends GetView<ForgotScreenController> {
  const Forgotscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
          titleTextStyle: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold,),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your email address below and we will send you instructions to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: controller.emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  onChanged: (value) {
                    controller.email.value = value;
                  },
                ),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.sendResetLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white),
                  )
                      : const Text('Send Reset Link',style: TextStyle(color: Colors.white),),
                )),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Get.back(); // Navigate back to the login screen
                  },
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
  }
