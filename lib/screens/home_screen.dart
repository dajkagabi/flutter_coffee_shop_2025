import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Háttérkép átlátszósággal
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/background.jpg'),
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
                    // Ide jön a navigáció a menühöz
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
