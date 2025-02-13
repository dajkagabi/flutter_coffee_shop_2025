//Firestore adatkezelés
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart'; // Importáld a CartItem modellt

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Rendelés elküldése Firestore-ba
  Future<void> submitOrder({
    required String name,
    required String address,
    required String phone,
    required String email,
    required List<CartItem> items,
    required double totalPrice,
  }) async {
    try {
      await _firestore.collection('orders').add({
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
        'items': items
            .map((item) => {
                  'id': item.id,
                  'name': item.name,
                  'price': item.price,
                  'quantity': item.quantity,
                })
            .toList(),
        'totalPrice': totalPrice,
        'timestamp': FieldValue.serverTimestamp(), // Rendelés időpontja
      });
    } catch (e) {
      throw Exception('Hiba történt a rendelés elküldése során: $e');
    }
  }
}
