import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartService with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addToCart(String id, String name, double price) {
    var existingItem = _items.firstWhere(
      (item) => item.id == id,
      orElse: () => CartItem(id: '', name: '', price: 0),
    );

    if (existingItem.id.isNotEmpty) {
      existingItem.quantity++;
    } else {
      _items.add(CartItem(id: id, name: name, price: price));
    }

    notifyListeners();
  }

  void increaseQuantity(String id) {
    var item = _items.firstWhere((item) => item.id == id);
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(String id) {
    var item = _items.firstWhere((item) => item.id == id);
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.removeWhere(
          (item) => item.id == id); // Ha a mennyiség 1, eltávolítjuk a terméket
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
