import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_2025/screens/menu_screen.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';
import '../services/cart_service.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Shop'),
        actions: [
          // Kosár ikon a badge-el
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: -7, end: -1),
            badgeContent: Text(
              cart.items.length.toString(), // Kosárban lévő termékek száma
              style: const TextStyle(color: Colors.white),
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red, // Piros háttér
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // Navigálás a kosárhoz
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Háttérkép átlátszósággal
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black54, // Sötét átlátszóság
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Tartalom középen
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Üdvözlünk a Coffee Shopban!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigálás a menü képernyőre
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[700], // Kávébarna gomb
                    foregroundColor: Colors.white, // Fehér szöveg
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Menü megtekintése'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
