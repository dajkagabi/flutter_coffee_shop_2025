import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_coffee_shop_2025/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'screens/cart_screen.dart';
import 'screens/login_screen.dart'; // Bejelentkezési képernyő importálása
import 'screens/profile_screen.dart'; // Profilképernyő importálása
import 'services/cart_service.dart';
import 'services/auth_service.dart'; // AuthService importálása

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartService()),
        ChangeNotifierProvider(
            create: (context) => AuthService()), // AuthService hozzáadása
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
      home: const HomeScreen(), // Főoldal betöltése alapértelmezettként
      routes: {
        '/cart': (context) => const CartScreen(),
        '/profile': (context) =>
            const ProfileScreen(), // Profilképernyő hozzáadása
        '/login': (context) =>
            const LoginScreen(), // Bejelentkezési képernyő hozzáadása
      },
    );
  }
}
