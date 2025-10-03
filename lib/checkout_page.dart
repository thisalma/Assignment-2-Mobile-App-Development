import 'package:flutter/material.dart';
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
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
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

                  // Payment options
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile(
                    title: Text('Cash on Delivery (Rs. $codFee)'),
                    value: 'cod',
                    groupValue: selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Card Payment'),
                    value: 'card',
                    groupValue: selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = value.toString();
                      });
                    },
                  ),

                  if (selectedPayment == 'card') _buildCardDetails(),

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill in your shipping details in the profile page."),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (selectedPayment == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a payment method."),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (selectedPayment == 'card') {
                    if (cardNumberController.text.isEmpty ||
                        expiryController.text.isEmpty ||
                        cvvController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill in your card details."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }

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

  Widget _buildCardDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        TextField(
          controller: cardNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: expiryController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
