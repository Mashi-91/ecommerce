import 'package:ecommerce/screens/home_screen/profilescreen/profilecontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../route/routes.dart';

class ProfileScreen extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(AppRoutes.loginScreenRoute);
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              final user = controller.currentUser;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final imageFile = await controller.pickImage();
                      if (imageFile != null) {
                        await controller.updateProfile(imageFile: imageFile, password: controller.passwordController.text);
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        controller.profileImageUrl.value.isNotEmpty
                            ? controller.profileImageUrl.value
                            : 'https://png.pngitem.com/pimgs/s/522-5220445_anonymous-profile-grey-person-sticker-glitch-empty-profile.png',
                      ),
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'User Name',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    user?.email ?? 'user@example.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Enter Current Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await controller.updateProfile(password: controller.passwordController.text);
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
