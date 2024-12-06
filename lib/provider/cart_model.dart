import 'package:flutter/material.dart';
import '../models/product.dart';

class CartModel extends ChangeNotifier {
  final Map<Product, int> _items = {};

  Map<Product, int> get items => _items;

  void addToCart(Product product, int quantity) {
    if (_items.containsKey(product)) {
      _items[product] =
          (_items[product]! + quantity).clamp(0, double.infinity).toInt();
      if (_items[product] == 0) {
        _items.remove(product);
      }
    } else if (quantity > 0) {
      _items[product] = quantity;
    }
    notifyListeners();
  }

  int get totalItems => _items.values
      .fold(0, (previousValue, element) => previousValue + element);
}
