import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/route/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var profileImageUrl = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    if (currentUser != null) {
      nameController.text = currentUser!.displayName ?? '';
      emailController.text = currentUser!.email ?? '';
      profileImageUrl.value = currentUser!.photoURL ?? '';
    }
  }

  // Method to pick image from gallery
  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> updateProfile({File? imageFile, required String password}) async {
    try {
      if (currentUser == null) return;

      // Re-authenticate the user if the email is being updated
      if (emailController.text.isNotEmpty && emailController.text != currentUser!.email) {
        try {
          AuthCredential credential = EmailAuthProvider.credential(
            email: currentUser!.email!,
            password: password,
          );

          await currentUser!.reauthenticateWithCredential(credential);
          await currentUser!.verifyBeforeUpdateEmail(emailController.text);

          Get.snackbar('Verification Sent', 'A verification email has been sent to your new address.');

          passwordController.clear();

          // Reload user to get updated information
          await _auth.currentUser!.reload();
          User? updatedUser = _auth.currentUser;

          await _firestore.collection('users').doc(updatedUser!.uid).update({
            'displayName': nameController.text,
            'email': emailController.text,
            'photoURL': profileImageUrl.value,
          });

          // Sign out the user to require re-login with the new email address
          await _auth.signOut();

          // Notify the user to log in again
          Get.snackbar('Success', 'Email updated successfully. Please log in again with your new email address.');
          Get.offAllNamed(AppRoutes.loginScreenRoute);

          Get.snackbar('Note', 'If not signed out automatically after changing email and verifying, please sign out manually.');
        } catch (e) {
          Get.snackbar('Error', 'Failed to update email: ${e.toString()}');
        }
      } else {
        await _updateFirestoreProfile();
      }

      // Upload image to Firebase Storage if an image is provided
      if (imageFile != null) {
        final storageRef = _storage.ref().child('profile_images').child(currentUser!.uid);
        await storageRef.putFile(imageFile);
        final downloadUrl = await storageRef.getDownloadURL();
        profileImageUrl.value = downloadUrl;
        await currentUser!.updatePhotoURL(downloadUrl);
      }

      // Update display name if provided
      if (nameController.text.isNotEmpty) {
        await currentUser!.updateDisplayName(nameController.text);
      }

    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
      log(e.toString());
    }
  }


  Future<void> _updateFirestoreProfile() async {
    try {
      if (currentUser == null) return;

      await _firestore.collection('users').doc(currentUser!.uid).update({
        'displayName': nameController.text,
        'email': emailController.text,
        'photoURL': profileImageUrl.value,
      });

      Get.snackbar('Success', 'Profile updated successfully in Firestore');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile in Firestore: $e');
    }
  }

}
