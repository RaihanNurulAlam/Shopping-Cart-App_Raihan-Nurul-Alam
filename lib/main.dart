// ignore_for_file: prefer_const_constructors

import 'package:ecommerce_app/provider/cart_model.dart';
import 'package:ecommerce_app/screens/confirmation_page.dart';
import 'package:ecommerce_app/screens/location_page.dart';
import 'package:ecommerce_app/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/shopping_cart_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MyApp(),
    ),
  );
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
        '/login': (context) => LoginPage(),
        '/': (context) => const HomePage(username: 'Raihan Nurul Alam'),
        '/productDetail': (context) => ProductDetailPage(),
        '/shoppingCart': (context) => ShoppingCartPage(),
        '/confirmation': (context) => ConfirmationPage(),
        '/location': (context) => LocationPage(),
      },
    );
  }
}
