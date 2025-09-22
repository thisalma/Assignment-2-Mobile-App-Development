import 'package:flutter/material.dart';
import 'product_data.dart';
import 'user_profile.dart';
import 'thank_you_page.dart';

class CheckoutPage extends StatelessWidget {
  final List<Product> checkoutItems;

  const CheckoutPage({super.key, required this.checkoutItems});

  @override
  Widget build(BuildContext context) {
    double total = checkoutItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: [
                  ...checkoutItems.map((item) {
                    final itemTotal = item.price * item.quantity;
                    return ListTile(
                      leading: Image.asset(item.image, width: 50, fit: BoxFit.cover),
                      title: Text(item.name),
                      subtitle: Text(
                        'Qty: ${item.quantity} x Rs. ${item.price.toStringAsFixed(2)}',
                      ),
                      trailing: Text(
                        'Rs. ${itemTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }),

                  const Divider(thickness: 1.5),
                  const SizedBox(height: 12),

                  const Text(
                    'Shipping Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildShippingDetails(),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rs. ${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final user = UserProfile();

                  if (user.name.isEmpty ||
                      user.email.isEmpty ||
                      user.contact.isEmpty ||
                      user.address.isEmpty) {
                    // Show error if shipping details are missing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill in your shipping details in the profile page."),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return; // stop here
                  }

                  // If details are available, go to Thank You page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ThankYouPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Confirm Order',
                  style: TextStyle(fontSize: 16),
                ),
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
      return const Text(
        'No shipping details available. Please fill them in the profile page.',
        style: TextStyle(color: Colors.red),
      );
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
}
