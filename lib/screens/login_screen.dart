import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart'; // Főoldal importálása

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Bejelentkezés')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Jelszó'),
              obscureText: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    const Text('Emlékezz rám'),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    if (emailController.text.isNotEmpty) {
                      setState(() => isLoading = true);
                      try {
                        await authService.resetPassword(emailController.text);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Jelszó-visszaállítási email elküldve'),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hiba: ${e.toString()}')),
                        );
                      } finally {
                        if (mounted) setState(() => isLoading = false);
                      }
                    }
                  },
                  child: const Text('Elfelejtett jelszó?'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // **Betöltés állapot jelzés**
            if (isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      try {
                        await authService.signIn(
                            emailController.text, passwordController.text);
                        if (rememberMe) {
                          await authService.saveLoginState(true);
                        }
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hiba: ${e.toString()}')),
                        );
                      } finally {
                        if (mounted) setState(() => isLoading = false);
                      }
                    },
                    child: const Text('Bejelentkezés'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      try {
                        await authService.signUp(
                            emailController.text, passwordController.text);
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hiba: ${e.toString()}')),
                        );
                      } finally {
                        if (mounted) setState(() => isLoading = false);
                      }
                    },
                    child: const Text('Regisztráció'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      try {
                        // **Ne hívd meg a signInAsGuest metódust**
                        if (!context.mounted) return;

                        // Popup üzenet megjelenítése
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Vendég mód'),
                              content: const Text(
                                  'Vendég módban vagy. A hűségprogram nem érhető el.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // Bezárja a popup-ot
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hiba: ${e.toString()}')),
                        );
                      } finally {
                        if (mounted) setState(() => isLoading = false);
                      }
                    },
                    child: const Text('Vendégként belépés'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
