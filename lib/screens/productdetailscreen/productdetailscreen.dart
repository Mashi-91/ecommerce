import 'package:ecommerce/model/productmodel.dart';
import 'package:ecommerce/screens/productdetailscreen/productdetailcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends GetView<ProductDetailController> {
  @override
  Widget build(BuildContext context) {
    final Product product = Get.arguments;

    // Initialize quantity and fetch the current value from Firestore
    controller.fetchProductQuantity(product.id.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          Obx(() {
            final isFavorite = controller.isFavoriteProduct(product);

            return IconButton(
              onPressed: () {
                controller.toggleFavorite(product);
                Get.snackbar(
                  isFavorite
                      ? 'Removed from Favorites'
                      : 'Added to Favorites',
                  isFavorite
                      ? 'The item has been removed from your favorites.'
                      : 'The item has been added to your favorites.',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.black.withOpacity(0.7),
                  colorText: Colors.white,
                );
              },
              icon: isFavorite
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite),
            );
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(product.image),
              const SizedBox(height: 16.0),
              Text(
                product.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text('\$${product.price}', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 16.0),
              Text(
                product.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              Text('Category: ${product.category}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16.0),
              Text(
                  'Rating: ${product.rating.rate} (${product.rating.count} reviews)',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24.0),

              // Quantity control row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    'Quantity: ${controller.currentQuantity.value}',
                    style: const TextStyle(fontSize: 16),
                  )),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (controller.currentQuantity.value > 0) {
                            controller.decreaseQuantity(product.id.toString());
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        onPressed: () {
                          controller.addToCart(product);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
