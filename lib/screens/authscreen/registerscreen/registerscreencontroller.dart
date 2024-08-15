import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreenController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxString usernameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString profilePicUrl = ''.obs;
  final RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();
  File? _profilePic;

  void validateUsername(String value) {
    if (value.isEmpty) {
      usernameError.value = 'Username is required';
    } else {
      usernameError.value = '';
    }
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(value)) {
      emailError.value = 'Invalid email address';
    } else {
      emailError.value = '';
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters long';
    } else {
      passwordError.value = '';
    }
  }

  bool isFormValid() {
    return usernameError.value.isEmpty &&
        emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        profilePicUrl.value.isNotEmpty;
  }

  Future<void> register() async {
    if (!isFormValid()) return;

    try {
      isLoading.value = true;

      // Create user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user == null) {
        throw Exception('User creation failed');
      }

      // Save profile picture to Firebase Storage
      String picUrl = '';
      if (_profilePic != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pics')
            .child('${user.uid}.jpg');
        await ref.putFile(_profilePic!);
        picUrl = await ref.getDownloadURL();

        // Update user's profile picture URL in Firebase Authentication
        await user.updatePhotoURL(picUrl);
      }

      // Update user's display name in Firebase Authentication
      await user.updateDisplayName(usernameController.text);

      // Save user information to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': usernameController.text,
        'email': emailController.text,
        'profilePic': picUrl,
      });

      Get.back();
      // Show success message
      Get.snackbar(
        'Success',
        'Registration successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Handle error
      Get.snackbar(
        'Error',
        'Registration failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> pickProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profilePic = File(pickedFile.path);
      profilePicUrl.value = pickedFile.path; // You can update this to display the selected image
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
