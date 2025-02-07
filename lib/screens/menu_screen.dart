import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coffee.dart';
import '../services/cart_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuScreen extends StatelessWidget {
  final List<Coffee> coffees = [
    Coffee(
        id: '1',
        name: 'Espresso',
        description: 'Erős és intenzív kávé.',
        imageUrl: 'assets/icons/espresso.svg',
        price: 5.0),
    Coffee(
        id: '2',
        name: 'Cappuccino',
        description: 'Klasszikus cappuccino.',
        imageUrl: 'assets/icons/cappuccino.svg',
        price: 15.0),
    Coffee(
        id: '3',
        name: 'Latte',
        description: 'Tejhabos latte.',
        imageUrl: 'assets/icons/latte.svg',
        price: 18.0),
  ];

  MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Kávé Menük')),
      body: ListView.builder(
        itemCount: coffees.length,
        itemBuilder: (ctx, index) {
          final coffee = coffees[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: SvgPicture.asset(coffee.imageUrl, width: 50, height: 50),
              title: Text(coffee.name),
              subtitle: Text(coffee.description),
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
