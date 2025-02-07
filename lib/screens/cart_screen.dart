//Kosár
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Kosár")),
      body: cart.items.isEmpty
          ? const Center(child: Text("A kosár üres"))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                var item = cart.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("Darab: ${item.quantity}"),
                  trailing: Text(
                      "\$${(item.price * item.quantity).toStringAsFixed(2)}"),
                  leading: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () => cart.removeFromCart(item.id),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => cart.clearCart(),
                child: Text(
                    "Kosár törlése (\$${cart.totalPrice.toStringAsFixed(2)})"),
              ),
            )
          : null,
    );
  }
}
