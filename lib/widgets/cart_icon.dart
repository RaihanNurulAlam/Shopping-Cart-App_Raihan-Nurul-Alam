// widgets/cart_icon.dart
import 'package:flutter/material.dart';

class CartIcon extends StatelessWidget {
  final int itemCount;
  final VoidCallback onTap;

  const CartIcon({super.key, required this.itemCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: FloatingActionButton(
        onPressed: onTap,
        child: Stack(
          children: [
            const Icon(Icons.shopping_cart),
            if (itemCount > 0)
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$itemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
