import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/model/productmodel.dart';
import 'package:ecommerce/screens/home_screen/cartscreen.dart';
import 'package:ecommerce/screens/home_screen/favoritescreen.dart';
import 'package:ecommerce/screens/home_screen/home_screen.dart';
import 'package:ecommerce/screens/home_screen/profilescreen/profilescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../service/apiservice.dart';

class HomeScreenController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = true.obs;
  final ApiService apiService = ApiService();
  var currentIndex = 0.obs;


  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  List<Widget> pages = [
    HomeScreen(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      // Fetch products from the API
      var productList = await apiService.getAllProductData();
      products.assignAll(productList);
      filteredProducts.assignAll(productList);
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeFromFavorites(Product product) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(product.id.toString())
          .delete();

      Get.snackbar(
        'Removed from Favorites',
        '${product.title} has been removed from your favorites.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black.withOpacity(0.7),
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle errors
      Get.snackbar(
        'Error',
        'Failed to remove ${product.title} from favorites.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black.withOpacity(0.7),
        colorText: Colors.white,
      );
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  Stream<QuerySnapshot> getCartItemsStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFavoriteProduct() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Handle the case where the user is not logged in
      throw Exception('User not logged in');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots();
  }


  void changeIndex(int index) {
    currentIndex.value = index;
  }

  void filterProducts(String query) {
    final lowerQuery = query.toLowerCase();
    filteredProducts.value = products.where((product) {
      return product.title.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<double> calculateTotalPrice() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return 0.0;

    try {
      final cartItemsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      double totalPrice = 0.0;

      for (final doc in cartItemsSnapshot.docs) {
        final item = doc.data() as Map<String, dynamic>;
        final price = (item['price'] as num).toDouble();
        final quantity = (item['quantity'] as num).toInt();
        totalPrice += price * quantity;
      }

      return totalPrice;
    } catch (e) {
      print('Error fetching cart items: $e');
      return 0.0;
    }
  }

  Future<void> checkout(BuildContext context) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Get.snackbar('Error', 'No user logged in.');
        return;
      }

      final cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cart');

      // Get all documents in the cart collection
      final cartItems = await cartCollection.get();

      // Delete all cart items
      for (var item in cartItems.docs) {
        await item.reference.delete();
      }

      Get.snackbar('Success', 'Cart has been cleared.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear the cart: $e');
    }
  }

}