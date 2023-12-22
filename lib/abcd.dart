import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
  });
}

class Cart {
  List<Product> items = [];

  void addToCart(Product product) {
    items.add(product);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  Cart cart = Cart();

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Product> fetchedProducts = data.map((productData) {
        return Product(
          id: productData['id'],
          title: productData['title'],
          price: productData['price'].toDouble(),
          description: productData['description'],
          image: productData['image'],
        );
      }).toList();

      setState(() {
        products = fetchedProducts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake Store App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cart: cart),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index].title),
            subtitle: Text('\$${products[index].price.toStringAsFixed(2)}'),
            trailing: ElevatedButton(
              onPressed: () {
                cart.addToCart(products[index]);
              },
              child: Text("Add to Cart"),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final Cart cart;

  CartScreen({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cart.items[index].title),
            subtitle: Text('\$${cart.items[index].price.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
