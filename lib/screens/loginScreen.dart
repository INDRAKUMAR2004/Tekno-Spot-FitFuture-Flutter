import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  /// LOGIN → Validating with Firebase Auth
  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Enter email & password.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Sign in with Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If successful, navigate to home
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found') {
        message = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided.";
      } else if (e.code == 'invalid-email') {
        message = "The email address is badly formatted.";
      }
      _showError(message);
    } catch (e) {
      debugPrint("Login Error: $e");
      _showError("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth > 500 ? 450 : constraints.maxWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "FitFuture",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF39FF14),
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Your personal fitness & lifestyle assistant",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),

                      const SizedBox(height: 50),

                      const Text(
                        "Welcome Back 👋",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF39FF14),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Login to continue your wellness journey",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),

                      const SizedBox(height: 40),

                      _inputBox("Email", _emailController),
                      const SizedBox(height: 20),
                      _inputBox("Password", _passwordController, obscure: true),

                      const SizedBox(height: 35),

                      _isLoading
                          ? const CircularProgressIndicator(color: Color(0xFF39FF14))
                          : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF39FF14),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: const Text(
                          "New here? Create Account",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _inputBox(String label, TextEditingController controller,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF39FF14)),
        filled: true,
        fillColor: Colors.black,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF39FF14)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF39FF14), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
