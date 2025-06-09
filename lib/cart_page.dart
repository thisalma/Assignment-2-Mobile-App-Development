import 'package:flutter/material.dart';
import 'product_data.dart';
import 'checkout_page.dart'; 

class CartPage extends StatefulWidget {
  final List<Product> cartItems;
  final Function(Product) onRemove;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemove,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void increaseQuantity(Product item) {
    setState(() {
      item.quantity++;
    });
  }

  void decreaseQuantity(Product item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double grandTotal = widget.cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.cartItems.isEmpty
                ? const Center(
                    child: Text('Your cart is empty.', style: TextStyle(fontSize: 18)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      final itemTotal = item.price * item.quantity;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Image.asset(item.image, width: 60, fit: BoxFit.cover),
                                title: Text(item.name),
                                subtitle: Text('Rs. ${item.price.toStringAsFixed(2)}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => widget.onRemove(item),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline),
                                        onPressed: () => decreaseQuantity(item),
                                      ),
                                      Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline),
                                        onPressed: () => increaseQuantity(item),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Total: Rs. ${itemTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (widget.cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total: Rs. ${grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(checkoutItems: widget.cartItems),
                        ),
                      );
                    },

                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
