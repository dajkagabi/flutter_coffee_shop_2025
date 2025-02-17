import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_2025/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Külön FormKey-k mindkét fülhöz
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  // Külön TextEditingController-ek mindkét fülhöz
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerConfirmPasswordController =
      TextEditingController();

  bool rememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bejelentkezés / Regisztráció'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Bejelentkezés'),
            Tab(text: 'Regisztráció'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Bejelentkezési űrlap
          _buildLoginForm(authService),
          // Regisztrációs űrlap
          _buildRegisterForm(authService),
        ],
      ),
    );
  }

  Widget _buildLoginForm(AuthService authService) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: _loginEmailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kérjük, add meg az email címed!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _loginPasswordController,
              decoration: const InputDecoration(labelText: 'Jelszó'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kérjük, add meg a jelszavad!';
                }
                return null;
              },
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
                  onPressed: () {
                    _showForgotPasswordDialog(context, authService);
                  },
                  child: const Text('Elfelejtett jelszó?'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  if (_loginFormKey.currentState!.validate()) {
                    setState(() => isLoading = true);
                    try {
                      await authService.signIn(_loginEmailController.text,
                          _loginPasswordController.text);
                      if (rememberMe) {
                        await authService.saveLoginState(true);
                      }
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hiba: ${e.toString()}')),
                      );
                    } finally {
                      if (mounted) setState(() => isLoading = false);
                    }
                  }
                },
                child: const Text('Bejelentkezés'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm(AuthService authService) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _registerFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: _registerNameController,
              decoration: const InputDecoration(labelText: 'Teljes név'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kérjük, add meg a neved!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _registerEmailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kérjük, add meg az email címed!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _registerPasswordController,
              decoration: const InputDecoration(labelText: 'Jelszó'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kérjük, add meg a jelszavad!';
                }
                if (value.length < 6) {
                  return 'A jelszónak legalább 6 karakter hosszúnak kell lennie!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _registerConfirmPasswordController,
              decoration:
                  const InputDecoration(labelText: 'Jelszó megerősítése'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kérjük, erősítsd meg a jelszavad!';
                }
                if (value != _registerPasswordController.text) {
                  return 'A jelszavak nem egyeznek!';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  if (_registerFormKey.currentState!.validate()) {
                    setState(() => isLoading = true);
                    try {
                      await authService.signUp(_registerEmailController.text,
                          _registerPasswordController.text);
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hiba: ${e.toString()}')),
                      );
                    } finally {
                      if (mounted) setState(() => isLoading = false);
                    }
                  }
                },
                child: const Text('Regisztráció'),
              ),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(
      BuildContext context, AuthService authService) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Elfelejtett jelszó'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kérjük, add meg az email címed!';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Bezárja a dialógusablakot
              },
              child: const Text('Mégse'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty) {
                  try {
                    await authService.resetPassword(emailController.text);
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Jelszó-visszaállítási e-mail elküldve.'),
                      ),
                    );
                    Navigator.pop(context); // Bezárja a dialógusablakot
                  } catch (e) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Hiba: ${e.toString()}')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kérjük, add meg az e-mail címed.'),
                    ),
                  );
                }
              },
              child: const Text('Küldés'),
            ),
          ],
        );
      },
    );
  }
}
