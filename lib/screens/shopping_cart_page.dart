// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:ecommerce_app/provider/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    final items = cart.items;

    double calculateTotalOrder() {
      return items.entries
          .fold(0, (total, item) => total + item.key.price * item.value);
    }

    double serviceFee = 2.0;
    LatLng deliveryLocation = LatLng(0, 0);
    String locationNotes = '';

    void _handleLocationResult(dynamic result) {
      setState(() {
        //This setState is now correctly placed within a StatefulWidget
        deliveryLocation = result['location'];
        locationNotes = result['notes'];
      });
    }

    double totalOrder = calculateTotalOrder();
    double totalPayment = totalOrder + serviceFee;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: items.isEmpty
          ? Center(
              child: Text('Your shopping cart is empty!'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final product = items.keys.elementAt(index);
                      final quantity = items[product]!;
                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(product.title),
                        subtitle: Text(
                          'Price: \$${product.price} x $quantity = \$${(product.price * quantity).toStringAsFixed(2)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                cart.addToCart(product, -1);
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                cart.addToCart(product, 1);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Order Summary',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Total Order: \$${totalOrder.toStringAsFixed(2)}'),
                      Text('Service Fee: \$${serviceFee.toStringAsFixed(2)}'),
                      SizedBox(height: 8),
                      Text(
                          'Total Payment: \$${totalPayment.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.pushNamed(
                              context, '/location',
                              arguments: _handleLocationResult);
                          if (result != null) {}
                        },
                        child: Text('Set Delivery Location'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/confirmation',
                              arguments: {
                                'totalPayment': totalPayment,
                                'cartItems': items,
                              });
                        },
                        child: Text('Proceed to Payment'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
