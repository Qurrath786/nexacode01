import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/home_screen.dart';
import '../widgets/shake_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<ShakeWidgetState> _shakeKey = GlobalKey<ShakeWidgetState>();
  bool isLoading = false;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _shakeKey.currentState?.shake();
      showMessage('Please enter both email and password');
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      showMessage('Login successful 🎉');

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    } catch (e) {
      _shakeKey.currentState?.shake();

      String errorText = 'Unexpected error occurred';

      if (e is FirebaseAuthException) {
        errorText = 'Auth error: ${e.message ?? "Login failed"}';
      } else if (e is FirebaseException) {
        errorText = 'Firebase error: ${e.message ?? "Something went wrong"}';
      } else {
        errorText = 'Error: ${e.toString()}';
      }

      showMessage(errorText);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'FiraCode')),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/nexa_logo.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.black),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ShakeWidget(
                key: _shakeKey,
                child: Column(
                  children: [
                    _glowingTextField(
                      controller: emailController,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _glowingTextField(
                      controller: passwordController,
                      hint: 'Password',
                      obscure: true,
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.lightBlueAccent,
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: login,
                            child: const Text(
                              'Login',
                              style: TextStyle(fontFamily: 'FiraCode'),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowingTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // Extract RGB values from lightBlueAccent
    final accent = Colors.lightBlueAccent;
    final r = (accent.r * 255.0).round() & 0xff;
    final g = (accent.g * 255.0).round() & 0xff;
    final b = (accent.b * 255.0).round() & 0xff;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(r, g, b, 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontFamily: 'FiraCode'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.lightBlueAccent),
          filled: true,
          fillColor: const Color.fromRGBO(
              0, 0, 0, 0.6), // replaces Colors.black.withOpacity(0.6)
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.lightBlueAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.lightBlueAccent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
