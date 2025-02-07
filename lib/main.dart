import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_2025/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'screens/cart_screen.dart';
import 'services/cart_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Shop',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: HomeScreen(),
      routes: {
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
