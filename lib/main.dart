// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'product_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food & Beverages App',

      // Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
      ),

      // Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.black,
      ),

      //  Automatically use system setting
      themeMode: ThemeMode.system,

      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
