// ignore_for_file: library_private_types_in_public_api, unnecessary_brace_in_string_interps

import 'package:ecommerce_app/provider/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
// Pastikan Anda memiliki CartModel

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel for product images
            SizedBox(
              height: 300,
              child: PageView(
                children: [
                  Image.network(product.image, fit: BoxFit.cover),
                  Image.network(product.image,
                      fit: BoxFit.cover), // Add more images if available
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Category: ${product.category}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '\$${product.price}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) quantity--;
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$quantity', style: const TextStyle(fontSize: 18)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<CartModel>(context, listen: false)
                          .addToCart(product, quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${quantity} x ${product.title} added to cart'),
                        ),
                      );
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/shoppingCart');
              },
              child: const Icon(Icons.shopping_cart),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFavorite
                        ? '${product.title} added to favorites'
                        : '${product.title} removed from favorites'),
                  ),
                );
              },
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
