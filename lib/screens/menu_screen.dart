import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coffee.dart';
import '../services/cart_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'cart_screen.dart';
import 'package:badges/badges.dart' as badges;

class MenuScreen extends StatelessWidget {
  final List<Coffee> coffees = [
    Coffee(
        id: '1',
        name: 'Espresso',
        description: 'Erős és intenzív kávé.',
        imageUrl: 'assets/icons/espresso.svg',
        price: 800),
    Coffee(
        id: '2',
        name: 'Cappuccino',
        description: 'Klasszikus cappuccino.',
        imageUrl: 'assets/icons/cappuccino.svg',
        price: 1245),
    Coffee(
        id: '3',
        name: 'Latte',
        description: 'Tejhabos latte.',
        imageUrl: 'assets/icons/latte.svg',
        price: 1500),
  ];

  MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kávé Menük'),
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
      body: ListView.builder(
        itemCount: coffees.length,
        itemBuilder: (ctx, index) {
          final coffee = coffees[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: SvgPicture.asset(coffee.imageUrl, width: 50, height: 50),
              title: Text(coffee.name),
              subtitle: Text(
                  "${coffee.description}\nÁr: ${NumberFormat.currency(locale: 'hu_HU', symbol: 'Ft').format(coffee.price)}"), // Formázott ár
              trailing: ElevatedButton(
                onPressed: () {
                  cart.addToCart(coffee.id, coffee.name, coffee.price);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("${coffee.name} hozzáadva a kosárhoz")),
                  );
                },
                child: const Text('Kosárba'),
              ),
            ),
          );
        },
      ),
    );
  }
}
