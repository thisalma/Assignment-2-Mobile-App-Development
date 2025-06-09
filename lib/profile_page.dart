import 'package:flutter/material.dart';
import 'user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showDetailsForm = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final user = UserProfile();

  void saveDetails() {
    setState(() {
      user.name = nameController.text;
      user.email = emailController.text;
      user.contact = contactController.text;
      user.address = addressController.text;

      showDetailsForm = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Details saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showDetailsForm = !showDetailsForm;
                  });
                },
                child: const Text(
                  'Detail >',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (showDetailsForm) ...[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: saveDetails,
                  child: const Text('Save'),
                ),
              ],
              if (!showDetailsForm && user.name.isNotEmpty) ...[
                const Divider(height: 30),
                const Text("Saved Info:",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Name: ${user.name}"),
                Text("Email: ${user.email}"),
                Text("Contact: ${user.contact}"),
                Text("Address: ${user.address}"),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
