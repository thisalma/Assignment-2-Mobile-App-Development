import 'package:flutter/material.dart';
import 'product_data.dart';
import 'product_details.dart';

class CategoryPage extends StatelessWidget {
  final Function(Product) onAddToCart;
  final List<Product> cart;

  const CategoryPage({super.key, required this.onAddToCart, required this.cart});

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.yellow),
              child: Text('Shop by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(title: Text('Granola')),
            ListTile(title: Text('Chocolates')),
            ListTile(title: Text('Hot Beverages')),
            ListTile(title: Text('Drinks')),
            ListTile(title: Text('Noodles')),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('OUR PRODUCTS'),
        backgroundColor: Colors.yellow[700],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Row(
        children: [
          if (isLandscape)
            Container(
              width: 200,
              color: Colors.yellow[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Shop by Category', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  CategoryButton(label: 'Granola'),
                  CategoryButton(label: 'Chocolates'),
                  CategoryButton(label: 'Hot Beverages'),
                  CategoryButton(label: 'Drinks'),
                  CategoryButton(label: 'Noodles'),
                ],
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: productList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = productList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          product: product,
                          onAddToCart: onAddToCart,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Expanded(child: Image.asset(product.image, fit: BoxFit.cover)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '${product.name}\nRs. ${product.price}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              ElevatedButton.icon(
                                onPressed: () => onAddToCart(product),
                                icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                                label: const Text('ADD TO CART'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;

  const CategoryButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        child: Text(label),
      ),
    );
  }
}
