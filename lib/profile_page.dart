// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'user_profile.dart';
import 'login.dart';
import 'order_history.dart'; // Import the new Order History screen

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

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadDetails();
  }

  // Load image path from SharedPreferences
  void _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profileImagePath');
    if (path != null && path.isNotEmpty) {
      setState(() {
        _profileImage = File(path);
      });
    }
  }

  // Save image path to SharedPreferences
  void _saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', path);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      _saveProfileImagePath(pickedFile.path);
    }
  }

  // Load details from SharedPreferences
  void _loadDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user.name = prefs.getString('name') ?? "";
      user.email = prefs.getString('email') ?? "";
      user.contact = prefs.getString('contact') ?? "";
      user.address = prefs.getString('address') ?? "";
    });
  }

  // Save details into SharedPreferences
  void _saveDetailsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('contact', user.contact);
    await prefs.setString('address', user.address);
  }

  void saveDetails() {
    setState(() {
      user.name = nameController.text;
      user.email = emailController.text;
      user.contact = contactController.text;
      user.address = addressController.text;

      showDetailsForm = false;
    });

    _saveDetailsToPrefs();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Details saved successfully')),
    );
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(height: 20),

              // Profile Picture with Camera Icon
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _profileImage != null ? FileImage(_profileImage!) : null,
                      child: _profileImage == null
                          ? const Icon(Icons.person, size: 60, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // DETAILS SECTION
              const Text(
                "Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),

              if (showDetailsForm) ...[
                _buildTextFieldCard("Name", nameController),
                const SizedBox(height: 12),
                _buildTextFieldCard("Email", emailController,
                    keyboard: TextInputType.emailAddress),
                const SizedBox(height: 12),
                _buildTextFieldCard("Contact Number", contactController,
                    keyboard: TextInputType.phone),
                const SizedBox(height: 12),
                _buildTextFieldCard("Address", addressController),

                // Save button bottom-right
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: saveDetails,
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ] else ...[
                _buildInfoCard("Name", user.name),
                const SizedBox(height: 8),
                _buildInfoCard("Email", user.email),
                const SizedBox(height: 8),
                _buildInfoCard("Contact", user.contact),
                const SizedBox(height: 8),
                _buildInfoCard("Address", user.address),

                // Row with Order History and Edit buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Order History Button (left)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const OrderHistoryScreen()),
                        );
                      },
                      child: const Text(
                        "Order History",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),

                    // Edit Button (right)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        setState(() {
                          showDetailsForm = true;
                          nameController.text = user.name;
                          emailController.text = user.email;
                          contactController.text = user.contact;
                          addressController.text = user.address;
                        });
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  // Widget for editable text fields in cards
  Widget _buildTextFieldCard(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: TextField(
          controller: controller,
          keyboardType: keyboard,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // Widget for displaying saved info in cards
  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          value.isNotEmpty ? value : '-',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
