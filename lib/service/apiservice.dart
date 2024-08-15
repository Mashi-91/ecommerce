import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../model/productmodel.dart';

class ApiService {
  final String baseUrl = 'https://fakestoreapi.com/products';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firestoreAuth = FirebaseAuth.instance;

  Future<List<Product>> getAllProductData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> productJson = json.decode(response.body);
        return productJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      // Handle errors
      throw Exception('Failed to load products: $error');
    }
  }

  Future<void> addToCart(Product product) async {
    try {
      final userId = _firestoreAuth.currentUser?.uid;
      await _firestore.collection('users').doc(userId).collection('cart').doc(product.id.toString()).set({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'category': product.category,
        'image': product.image,
        'rating': product.rating.toJson(),
      });
    } catch (e) {
      throw Exception('Failed to add product to cart: $e');
    }
  }

  Future<void> toggleFavorite(Product product, bool isFavorite) async {
    try {
      final userId = _firestoreAuth.currentUser?.uid;
      if (isFavorite) {
        await _firestore.collection('users').doc(userId).collection('favorites').doc(product.id.toString()).set({
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'category': product.category,
          'image': product.image,
          'rating': product.rating.toJson(),
        });
      } else {
        await _firestore.collection('users').doc(userId).collection('favorites').doc(product.id.toString()).delete();
      }
    } catch (e) {
      throw Exception('Failed to update favorite status: $e');
    }
  }
}
