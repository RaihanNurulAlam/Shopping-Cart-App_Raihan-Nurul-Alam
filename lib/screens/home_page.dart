import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_icon.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> allProducts = []; // Semua produk dari API
  List<Product> products = []; // Produk yang ditampilkan (hasil filter)
  List<String> categories = ['All']; // Daftar kategori, dimulai dengan 'All'
  String selectedCategory = 'All'; // Kategori terpilih
  final Map<Product, int> cartItems = {}; // Keranjang

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      final fetchedProducts = await ApiService.fetchProducts();

      // Mengambil daftar kategori unik
      final uniqueCategories =
          fetchedProducts.map((product) => product.category).toSet().toList();

      setState(() {
        allProducts = fetchedProducts;
        products = allProducts; // Awalnya tampilkan semua produk
        categories.addAll(uniqueCategories); // Tambahkan kategori ke dropdown
      });

      print('Produk berhasil dimuat: $allProducts');
      print('Kategori: $categories');
    } catch (e) {
      print("Gagal memuat produk: $e");
    }
  }

  void filterProducts(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        products = allProducts; // Tampilkan semua produk
      } else {
        products = allProducts
            .where((product) => product.category == category)
            .toList();
      }
    });

    print('Produk setelah filter: $products');
  }

  void searchProducts(String query) {
    setState(() {
      products = allProducts
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    print('Produk setelah pencarian: $products');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}!'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: searchProducts,
                  decoration: InputDecoration(
                    labelText: 'Search Product',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newCategory) {
                    if (newCategory != null) {
                      filterProducts(newCategory);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: products.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () async {
                          final updatedProduct = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(),
                              settings: RouteSettings(arguments: product),
                            ),
                          );
                          if (updatedProduct != null) {
                            setState(() {
                              cartItems[updatedProduct] =
                                  (cartItems[updatedProduct] ?? 0) + 1;
                            });
                          }
                        },
                      );
                    },
                  )
                : Center(
                    child: Text('No products available'),
                  ),
          ),
        ],
      ),
      floatingActionButton: CartIcon(
        itemCount: cartItems.values.fold(0, (sum, quantity) => sum + quantity),
        onTap: () {
          Navigator.pushNamed(context, '/shoppingCart', arguments: cartItems);
        },
      ),
    );
  }
}
