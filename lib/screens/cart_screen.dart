import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import 'order_screen.dart';

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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cart.decreaseQuantity(item.id),
                      ),
                      Text(
                          "${(item.price * item.quantity).toStringAsFixed(0)} Ft"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cart.increaseQuantity(item.id),
                      ),
                    ],
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => cart.removeFromCart(item.id),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Megrendelés gomb
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigálás az OrderScreen-re
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreen(cart: cart),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Zöld gomb
                        foregroundColor: Colors.white, // Fehér szöveg
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Megrendelés'),
                    ),
                  ),
                  const SizedBox(width: 8), // Kis térköz a gombok között
                  // Kosár törlése gomb
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => cart.clearCart(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Piros gomb
                        foregroundColor: Colors.white, // Fehér szöveg
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Kosár törlése'),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
