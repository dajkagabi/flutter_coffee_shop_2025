//Kávéfajták modellje

class Coffee {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  factory Coffee.fromMap(Map<String, dynamic> data) {
    return Coffee(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      price: data['price'],
    );
  }
}
