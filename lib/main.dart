// Main File (main.dart)
// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/shopping_cart_page.dart';
import 'screens/confirmation_page.dart' as confirmation;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(username: 'Raihan Nurul Alam'),
        '/productDetail': (context) => ProductDetailPage(),
        '/shoppingCart': (context) => ShoppingCartPage(),
        '/confirmation': (context) => ConfirmationPage(),
      },
    );
  }
}
