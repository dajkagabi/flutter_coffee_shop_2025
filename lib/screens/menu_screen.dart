import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_2025/models/coffee.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuScreen extends StatelessWidget {
  final List<Coffee> coffees = [
    Coffee(
      id: '1',
      name: 'Espresso',
      description: 'Erős és intenzív kávé.',
      imageUrl: 'assets/icons/espresso.svg',
      price: 5.0,
    ),
    Coffee(
      id: '2',
      name: 'Cappuccino',
      description:
          'A cappuccino egyenlő arányban tartalmaz eszpresszót, gőzölt tejet és tejhabot.',
      imageUrl: 'assets/icons/cappuccino.svg',
      price: 15.0,
    ),
    Coffee(
      id: '3',
      name: 'Latte',
      description: 'Tejhab és kávé tökéletes keveréke.',
      imageUrl: 'assets/icons/latte.svg',
      price: 18.0,
    ),
  ];

  MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kávé Menük'),
      ),
      body: ListView.builder(
        itemCount: coffees.length,
        itemBuilder: (ctx, index) {
          final coffee = coffees[index];
          return CoffeeCard(coffee: coffee);
        },
      ),
    );
  }
}

class CoffeeCard extends StatelessWidget {
  final Coffee coffee;

  const CoffeeCard({super.key, required this.coffee});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: SvgPicture.asset(coffee.imageUrl, width: 50, height: 50),
        title: Text(coffee.name),
        subtitle: Text(coffee.description),
        trailing: Text('\$${coffee.price.toStringAsFixed(2)}'),
        onTap: () {
          // Kávé részletezés, vagy hozzáadás a kosárhoz
        },
      ),
    );
  }
}
