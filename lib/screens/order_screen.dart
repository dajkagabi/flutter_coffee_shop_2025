import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../services/firestore_service.dart'; // Importáld a FirestoreService-t

class OrderScreen extends StatefulWidget {
  final CartService cart;

  const OrderScreen({super.key, required this.cart});

  @override
  // ignore: library_private_types_in_public_api
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false; // Betöltés állapota

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> submitOrder() async {
    setState(() => isLoading = true);

    try {
      await firestoreService.submitOrder(
        name: nameController.text,
        address: addressController.text,
        phone: phoneController.text,
        email: emailController.text,
        items: widget.cart.items,
        totalPrice: widget.cart.totalPrice,
      );

      if (!mounted) return; // Ellenőrizzük, hogy még a fában van-e

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rendelés sikeresen elküldve!'),
          duration: Duration(seconds: 2),
        ),
      );

      widget.cart.clearCart(); // Kosár kiürítése

      Navigator.pop(context); // Visszalépés az előző oldalra
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hiba történt: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rendelési információk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Név')),
            TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Cím')),
            TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefonszám')),
            TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : submitOrder,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Megrendelés'),
            ),
          ],
        ),
      ),
    );
  }
}
