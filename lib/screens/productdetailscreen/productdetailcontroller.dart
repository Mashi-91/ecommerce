import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/model/productmodel.dart';
import '../../service/apiservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailController extends GetxController {
  final ApiService apiService = ApiService();
  var favoriteProducts = <Product>[].obs;
  var cartProducts = <Product>[].obs;
  final RxInt currentQuantity = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchFavoriteProducts();
  }

  void _fetchFavoriteProducts() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        return Product.fromJson(data);
      }).toList();

      favoriteProducts.value = products;
    });
  }

  void toggleFavorite(Product product) async {
    final isFavorite = isFavoriteProduct(product);

    try {
      await apiService.toggleFavorite(product, !isFavorite);
      if (isFavorite) {
        favoriteProducts.removeWhere((p) => p.id == product.id);
      } else {
        favoriteProducts.add(product);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update favorite status');
    }
  }

  Future<void> fetchProductQuantity(String productId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final cartDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId);

      final docSnapshot = await cartDoc.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final quantity = data['quantity'] ?? 0;
        currentQuantity.value = quantity;
      } else {
        currentQuantity.value = 0; // Product is not in cart
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch product quantity: $e');
    }
  }

  Future<void> addToCart(Product product) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final cartDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(product.id.toString());

      final docSnapshot = await cartDoc.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final currentQuantity = data['quantity'] ?? 0;
        await cartDoc.update({
          'quantity': currentQuantity + 1,
        });
      } else {
        await cartDoc.set({
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'category': product.category,
          'image': product.image,
          'rating': product.rating.toJson(),
          'quantity': 1,
        });
      }

      currentQuantity.value++;
      Get.snackbar(
        'Cart',
        '${product.title} added to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product to cart: $e');
    }
  }

  Future<void> decreaseQuantity(String productId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final cartDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId);

      final docSnapshot = await cartDoc.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final currentQuantityInCart = data['quantity'] ?? 0;

        if (currentQuantityInCart > 1) {
          await cartDoc.update({
            'quantity': currentQuantityInCart - 1,
          });
        } else {
          await cartDoc.delete();
        }
        fetchProductQuantity(productId); // Refresh quantity
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to decrease product quantity: $e');
    }
  }


  bool isFavoriteProduct(Product product) {
    return favoriteProducts.any((p) => p.id == product.id);
  }
}
