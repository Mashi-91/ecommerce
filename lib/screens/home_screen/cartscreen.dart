import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screens/home_screen/home_screen_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends GetView<HomeScreenController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<double>(
        future: controller.calculateTotalPrice(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == 0.0) {
            return const Center(child: Text('Your cart is empty.'));
          }

          final totalPrice = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _fetchCartItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('Your cart is empty.'));
                    }

                    final cartItems = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index].data() as Map<String, dynamic>;
                        final price = (item['price'] as num).toDouble();
                        final quantity = (item['quantity'] as num).toInt();

                        return ListTile(
                          title: Text(item['title']),
                          subtitle: Text('\$${price.toStringAsFixed(2)} x $quantity'),
                          trailing: Text('\$${(price * quantity).toStringAsFixed(2)}'),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: \$${totalPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.displaySmall),
                    ElevatedButton(
                      onPressed: () {
                        controller.checkout(context);
                      },
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> _fetchCartItems() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots();
  }
}
