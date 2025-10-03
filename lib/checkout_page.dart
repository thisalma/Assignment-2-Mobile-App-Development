// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'product_data.dart';
import 'user_profile.dart';
import 'thank_you_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<Product> checkoutItems;

  const CheckoutPage({super.key, required this.checkoutItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? selectedPayment; // No default selection
  double codFee = 250.0;

  // Card details controllers
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  bool isPlacingOrder = false;

  @override
  Widget build(BuildContext context) {
    double subtotal = widget.checkoutItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    double total = subtotal + (selectedPayment == 'cod' ? codFee : 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Order Summary', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ...widget.checkoutItems.map((item) {
                    final itemTotal = item.price * item.quantity;
                    return ListTile(
                      leading: Image.asset(item.image, width: 50, fit: BoxFit.cover),
                      title: Text(item.name),
                      subtitle: Text('Qty: ${item.quantity} x Rs. ${item.price.toStringAsFixed(2)}'),
                      trailing: Text('Rs. ${itemTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 12),
                  const Text('Shipping Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildShippingDetails(),
                  const SizedBox(height: 16),
                  const Text('Payment Method', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  RadioListTile(
                    title: Text('Cash on Delivery (Rs. $codFee)'),
                    value: 'cod',
                    groupValue: selectedPayment,
                    onChanged: (value) {
                      setState(() => selectedPayment = value.toString());
                    },
                  ),
                  RadioListTile(
                    title: const Text('Card Payment'),
                    value: 'card',
                    groupValue: selectedPayment,
                    onChanged: (value) {
                      setState(() => selectedPayment = value.toString());
                    },
                  ),
                  if (selectedPayment == 'card') _buildCardDetails(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Rs. ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isPlacingOrder ? null : _confirmOrder,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 14)),
                child: isPlacingOrder ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirm Order', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingDetails() {
    final user = UserProfile();

    if (user.name.isEmpty) {
      return const Text('No shipping details available. Please fill them in the profile page.', style: TextStyle(color: Colors.red));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name: ${user.name}"),
        Text("Email: ${user.email}"),
        Text("Contact: ${user.contact}"),
        Text("Address: ${user.address}"),
      ],
    );
  }

  Widget _buildCardDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        TextField(
          controller: cardNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Card Number', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: expiryController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(labelText: 'Expiry Date', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'CVV', border: OutlineInputBorder()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmOrder() async {
    final user = UserProfile();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Validate shipping details
    if (user.name.isEmpty || user.email.isEmpty || user.contact.isEmpty || user.address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in your shipping details in the profile page."), backgroundColor: Colors.red),
      );
      return;
    }

    // Validate payment selection
    if (selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a payment method."), backgroundColor: Colors.red),
      );
      return;
    }

    // Validate card info if card payment selected
    if (selectedPayment == 'card') {
      if (cardNumberController.text.isEmpty || expiryController.text.isEmpty || cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in your card details."), backgroundColor: Colors.red),
        );
        return;
      }
    }

    // Prepare totals
    double subtotal = widget.checkoutItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double total = subtotal + (selectedPayment == 'cod' ? codFee : 0);

    // Prepare order items
    List<Map<String, dynamic>> apiItems = widget.checkoutItems.map((item) => {
      'name': item.name,
      'quantity': item.quantity,
      'price': item.price,
    }).toList();

    setState(() => isPlacingOrder = true);

    try {
      print("Placing order...");
      final result = await ApiService().placeOrder(
        apiItems,
        total,
        selectedPayment!,
        token: token ?? '',
      );
      print("Order result: $result");

      // Optional: clear cart
      // widget.checkoutItems.clear();

      // Navigate to Thank You Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ThankYouPage()),
      );
    } catch (e) {
      print("Order error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isPlacingOrder = false);
    }
  }
}
