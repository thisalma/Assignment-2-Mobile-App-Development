import 'package:flutter/material.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              const Text(
                'Thank you!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'You have placed your order successfully.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Back to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
